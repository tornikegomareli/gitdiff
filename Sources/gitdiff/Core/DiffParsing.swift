//
//  DiffParsing.swift
//  gitdiff
//

import Foundation

/// Strategy for turning a diff text into the renderer's domain model.
///
/// `DiffRenderer` reads the active parser from the environment so callers
/// can plug in formats other than standard unified diff — annotated diffs,
/// pre-tokenised server output, JSON patches, anything that can produce a
/// `[DiffFile]`. Inject via the ``SwiftUI/View/diffParser(_:)`` modifier.
///
/// ```swift
/// DiffRenderer(diffText: rawDiff)
///   .diffParser(MyAnnotatedDiffParser(filePath: "foo.swift"))
/// ```
public protocol DiffParsing: Sendable {
  /// Parse the given diff text into the renderer's domain model.
  ///
  /// - Parameter diffText: Raw input in whatever format this parser understands.
  /// - Returns: One `DiffFile` per file represented in the input. Returning
  ///   an empty array causes `DiffRenderer` to show the "no content" state.
  /// - Throws: Re-thrown by the renderer's `.task` — usually
  ///   `CancellationError` if the view disappears mid-parse, but custom
  ///   parsers may surface format errors here.
  func parse(_ diffText: String) async throws -> [DiffFile]
}

/// Default parser — accepts standard unified-diff text (the output of
/// `git diff`, `diff -u`, `Diff.createTwoFilesPatch` from jsdiff, etc.).
public struct UnifiedDiffParser: DiffParsing {
  public init() {}

  public func parse(_ diffText: String) async throws -> [DiffFile] {
    try await DiffParser.parse(diffText)
  }
}
