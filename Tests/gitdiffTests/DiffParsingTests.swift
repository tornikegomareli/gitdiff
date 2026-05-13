import Testing

@testable import gitdiff

/// Contract tests for the `DiffParsing` extension point: custom parsers can
/// construct the library's domain model directly without relying on the
/// built-in unified-diff parser.
struct DiffParsingTests {

  // MARK: - UnifiedDiffParser

  @Test
  func unifiedDiffParserMatchesLegacyStaticParser() async throws {
    let diff = """
      diff --git a/foo.txt b/foo.txt
      index 1111111..2222222 100644
      --- a/foo.txt
      +++ b/foo.txt
      @@ -1,2 +1,3 @@
       line1
      -line2
      +line2 changed
      +line3
      """

    let legacy = try await DiffParser.parse(diff)
    let viaProtocol = try await UnifiedDiffParser().parse(diff)

    #expect(legacy.count == viaProtocol.count)
    for (a, b) in zip(legacy, viaProtocol) {
      #expect(a.oldPath == b.oldPath)
      #expect(a.newPath == b.newPath)
      #expect(a.hunks.count == b.hunks.count)
      for (h1, h2) in zip(a.hunks, b.hunks) {
        #expect(h1.lines.count == h2.lines.count)
        for (l1, l2) in zip(h1.lines, h2.lines) {
          #expect(l1.type == l2.type)
          #expect(l1.content == l2.content)
        }
      }
    }
  }

  // MARK: - Custom parser path

  @Test
  func customParserCanBuildDiffFilesDirectly() async throws {
    /// A throwaway parser that ignores its input and produces a single
    /// hand-built `DiffFile`. This exercises the public initialisers on
    /// `DiffFile` / `DiffHunk` / `DiffLine` and the protocol contract.
    struct FixtureParser: DiffParsing {
      let filePath: String
      func parse(_ diffText: String) async throws -> [DiffFile] {
        [
          DiffFile(
            oldPath: filePath,
            newPath: filePath,
            hunks: [
              DiffHunk(
                oldStart: 1,
                oldCount: 1,
                newStart: 1,
                newCount: 1,
                header: "fixture",
                lines: [
                  DiffLine(type: .removed, content: "old", oldLineNumber: 1, newLineNumber: nil),
                  DiffLine(type: .added, content: "new", oldLineNumber: nil, newLineNumber: 1),
                ]
              )
            ]
          )
        ]
      }
    }

    let files = try await FixtureParser(filePath: "x.swift").parse("anything")
    #expect(files.count == 1)
    #expect(files[0].oldPath == "x.swift")
    #expect(files[0].hunks[0].lines[0].type == .removed)
    #expect(files[0].hunks[0].lines[1].type == .added)
  }

  @Test
  func defaultEnvironmentParserIsUnifiedDiffParser() {
    /// Confirms the environment default that `DiffRenderer` reads.
    let key = DiffParserKey.defaultValue
    #expect(key is UnifiedDiffParser)
  }

  @Test
  func parserCanReturnEmptyArrayToTriggerNoContentState() async throws {
    struct EmptyParser: DiffParsing {
      func parse(_ diffText: String) async throws -> [DiffFile] { [] }
    }
    let result = try await EmptyParser().parse("ignored")
    #expect(result.isEmpty)
  }
}
