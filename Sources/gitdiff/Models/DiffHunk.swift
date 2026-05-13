//
//  DiffHunk.swift
//  gitdiff
//
//  Created by Tornike Gomareli on 18.06.25.
//


import Foundation

/// Represents a change section (hunk) in a diff file.
public struct DiffHunk: Identifiable, Sendable {
  public let id: UUID
  public let oldStart: Int
  public let oldCount: Int
  public let newStart: Int
  public let newCount: Int
  public let header: String
  public let lines: [DiffLine]

  public init(
    id: UUID = UUID(),
    oldStart: Int,
    oldCount: Int,
    newStart: Int,
    newCount: Int,
    header: String,
    lines: [DiffLine]
  ) {
    self.id = id
    self.oldStart = oldStart
    self.oldCount = oldCount
    self.newStart = newStart
    self.newCount = newCount
    self.header = header
    self.lines = lines
  }
}
