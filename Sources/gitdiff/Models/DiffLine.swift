//
//  DiffLine.swift
//  gitdiff
//
//  Created by Tornike Gomareli on 18.06.25.
//


import Foundation

/// Represents a single line in a diff.
public struct DiffLine: Identifiable, Sendable {
  public let id: UUID
  public let type: LineType
  public let content: String
  public let oldLineNumber: Int?
  public let newLineNumber: Int?

  public init(
    id: UUID = UUID(),
    type: LineType,
    content: String,
    oldLineNumber: Int?,
    newLineNumber: Int?
  ) {
    self.id = id
    self.type = type
    self.content = content
    self.oldLineNumber = oldLineNumber
    self.newLineNumber = newLineNumber
  }

  /// Type of diff line.
  public enum LineType: Sendable {
    case added    /// Line was added (+)
    case removed  /// Line was removed (-)
    case context  /// Unchanged context line
    case header   /// Section header
  }
}
