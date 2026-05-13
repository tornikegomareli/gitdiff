//
//  DiffFile.swift
//  gitdiff
//
//  Created by Tornike Gomareli on 18.06.25.
//


import Foundation

/// Represents a file in a diff.
///
/// The library ships a `UnifiedDiffParser` for standard unified diffs, but
/// any type conforming to ``DiffParsing`` can construct `DiffFile` values
/// directly — that's how consumers plug in custom diff formats (annotated
/// diffs, JSON patches, server-side formats, etc.) without modifying the
/// renderer.
public struct DiffFile: Identifiable, Sendable {
  public let id: UUID
  public let oldPath: String
  public let newPath: String
  public let hunks: [DiffHunk]
  public let isBinary: Bool
  public let isRenamed: Bool

  public init(
    id: UUID = UUID(),
    oldPath: String,
    newPath: String,
    hunks: [DiffHunk],
    isBinary: Bool = false,
    isRenamed: Bool = false
  ) {
    self.id = id
    self.oldPath = oldPath
    self.newPath = newPath
    self.hunks = hunks
    self.isBinary = isBinary
    self.isRenamed = isRenamed
  }

  /// Formatted name for display, showing rename if applicable.
  public var displayName: String {
    if isRenamed {
      return "\(oldPath) → \(newPath)"
    }
    return newPath.isEmpty ? oldPath : newPath
  }
}
