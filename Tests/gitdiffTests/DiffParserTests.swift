import Testing

@testable import gitdiff

internal func makeLargeMultiHunkDiff(hunks: Int, linesPerHunk: Int) -> String {
  var parts: [String] = []
  parts.append("diff --git a/large.txt b/large.txt")
  parts.append("index 7777777..8888888 100644")
  parts.append("--- a/large.txt")
  parts.append("+++ b/large.txt")
  var oldStart = 1
  var newStart = 1
  for _ in 0..<hunks {
    parts.append("@@ -\(oldStart),\(linesPerHunk) +\(newStart),\(linesPerHunk) @@")
    // Add alternating context/removed/added to keep parser busy
    for j in 0..<linesPerHunk {
      if j % 3 == 0 {
        parts.append(" context line \(j)")
        oldStart += 1
        newStart += 1
      } else if j % 3 == 1 {
        parts.append("-removed line \(j)")
        oldStart += 1
      } else {
        parts.append("+added line \(j)")
        newStart += 1
      }
    }
  }
  return parts.joined(separator: "\n")
}
struct DiffParserTests {
  // MARK: - Helpers
  private func makeSimpleSingleHunkDiff() -> String {
    return """
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
  }

  private func makeTwoHunksDiff() -> String {
    return """
      diff --git a/bar.txt b/bar.txt
      index 3333333..4444444 100644
      --- a/bar.txt
      +++ b/bar.txt
      @@ -1,2 +1,2 @@
       a
      -b
      +B
      @@ -5,2 +5,3 @@
       five
      -six
      +six!
      +seven
      """
  }

  private func makeBinaryDiff() -> String {
    return """
      diff --git a/bin/file.bin b/bin/file.bin
      index abcdef1..abcdef2 100644
      Binary files a/bin/file.bin and b/bin/file.bin differ
      """
  }

  private func makeRenameDiff() -> String {
    return """
      diff --git a/old.txt b/new.txt
      similarity index 100%
      rename from old.txt
      rename to new.txt
      index 5555555..6666666 100644
      --- a/old.txt
      +++ b/new.txt
      """
  }

  // MARK: - Tests

  @Test
  func testParseEmptyReturnsEmpty() async throws {
    let files = try await DiffParser.parse("")
    #expect(files.count == 0)
  }

  @Test
  func testParseSingleFileSingleHunk() async throws {
    let diff = makeSimpleSingleHunkDiff()
    let files = try await DiffParser.parse(diff)
    #expect(files.count == 1)
    let file = try #require(files.first)
    #expect(file.oldPath == "foo.txt")
    #expect(file.newPath == "foo.txt")
    #expect(file.isBinary == false)
    #expect(file.isRenamed == false)
    #expect(file.hunks.count == 1)
    let hunk = try #require(file.hunks.first)
    #expect(hunk.header.trimmingCharacters(in: .whitespaces) == "@@ -1,2 +1,3 @@")
    #expect(hunk.lines.count == 4)
    #expect(hunk.lines[0].type == .context)
    #expect(hunk.lines[0].content == "line1")
    #expect(hunk.lines[1].type == .removed)
    #expect(hunk.lines[1].content == "line2")
    #expect(hunk.lines[2].type == .added)
    #expect(hunk.lines[2].content == "line2 changed")
    #expect(hunk.lines[3].type == .added)
    #expect(hunk.lines[3].content == "line3")
  }

  @Test
  func testParseMultipleHunksInOneFile() async throws {
    let diff = makeTwoHunksDiff()
    let files = try await DiffParser.parse(diff)
    #expect(files.count == 1)
    let file = try #require(files.first)
    #expect(file.hunks.count == 2)
  }

  @Test
  func testParseBinaryFile() async throws {
    let diff = makeBinaryDiff()
    let files = try await DiffParser.parse(diff)
    #expect(files.count == 1)
    let file = try #require(files.first)
    #expect(file.isBinary)
    #expect(file.hunks.count == 0)
  }

  @Test
  func testParseRename() async throws {
    let diff = makeRenameDiff()
    let files = try await DiffParser.parse(diff)
    #expect(files.count == 1)
    let file = try #require(files.first)
    #expect(file.isRenamed)
    #expect(file.oldPath == "old.txt")
    #expect(file.newPath == "new.txt")
  }

  @Test
  func testCancellationThrowsCancellationError() async throws {
    // Build a large diff to ensure the task doesn't finish instantly
    let diff = makeLargeMultiHunkDiff(hunks: 40, linesPerHunk: 30)
    let task = Task { () -> [DiffFile] in try await DiffParser.parse(diff) }
    // Yield and then cancel shortly after to trigger cooperative cancellation
    await Task.yield()
    task.cancel()
    await #expect(throws: CancellationError.self) {
      _ = try await task.value
    }
  }
}
