import Foundation
import Testing

@testable import gitdiff

struct DiffParserBenchmarks {
  @Test
  func benchmarkLargeMultiHunkParse() async throws {
    // Adjust these to stress the parser; keep runtime reasonable for CI
    let hunks = 1000
    let linesPerHunk = 400
    let iterations = 3

    let diff = makeLargeMultiHunkDiff(hunks: hunks, linesPerHunk: linesPerHunk)

    // Warm-up
    _ = try await DiffParser.parse(diff)

    let clock = ContinuousClock()
    var totals: [Duration] = []

    for _ in 0..<iterations {
      let duration = try await clock.measure {
        let files = try await DiffParser.parse(diff)
        #expect(!files.isEmpty)
      }
      totals.append(duration)
    }

    // Report results
    let nanos = totals.map { $0.components.attoseconds / 1_000_000_000 }  // Duration printing hack
    // Fallback formatting using Double seconds from Duration
    func seconds(_ d: Duration) -> Double {
      Double(d.components.seconds) + Double(d.components.attoseconds) / 1e18
    }
    let secs = totals.map(seconds)
    let avg = secs.reduce(0, +) / Double(secs.count)
    let minT = secs.min() ?? avg
    let maxT = secs.max() ?? avg

    print(
      "DiffParser benchmark (hunks=\(hunks), linesPerHunk=\(linesPerHunk), iters=\(iterations))")
    print(
      String(
        format: "  times: %@", secs.map { String(format: "%.4fs", $0) }.joined(separator: ", ")))
    print(String(format: "  avg: %.4fs  min: %.4fs  max: %.4fs", avg, minT, maxT))
  }
}
