import Testing
import SwiftUI

@testable import gitdiff

/// Contract tests for the new ``DiffConfiguration/LineNumberStyle`` and
/// ``DiffConfiguration/showHunkHeaders`` knobs.
struct DiffConfigurationTests {

  // MARK: - Legacy → new field inference

  @Test
  func defaultsToDualLineNumberStyle() {
    let config = DiffConfiguration()
    #expect(config.lineNumberStyle == .dual)
    #expect(config.showLineNumbers == true)
    #expect(config.showHunkHeaders == true)
  }

  @Test
  func legacyShowLineNumbersFalseImpliesHiddenStyle() {
    let config = DiffConfiguration(showLineNumbers: false)
    #expect(config.lineNumberStyle == .hidden)
    #expect(config.showLineNumbers == false)
  }

  @Test
  func explicitLineNumberStyleOverridesLegacyFlag() {
    let config = DiffConfiguration(showLineNumbers: false, lineNumberStyle: .single)
    /// Explicit `.single` wins over the legacy boolean — useful for callers
    /// that haven't migrated their boilerplate but want the new gutter mode.
    #expect(config.lineNumberStyle == .single)
  }

  @Test
  func diffLineNumbersFalseSwitchesToHidden() {
    let config = DiffConfiguration().withLineNumbers(false)
    #expect(config.lineNumberStyle == .hidden)
    #expect(config.showLineNumbers == false)
  }

  @Test
  func diffLineNumbersTrueRestoresDual() {
    let config = DiffConfiguration().withLineNumbers(false).withLineNumbers(true)
    #expect(config.lineNumberStyle == .dual)
    #expect(config.showLineNumbers == true)
  }

  @Test
  func withLineNumberStyleSetsBothFields() {
    let config = DiffConfiguration().withLineNumberStyle(.single)
    #expect(config.lineNumberStyle == .single)
    #expect(config.showLineNumbers == true)

    let hidden = DiffConfiguration().withLineNumberStyle(.hidden)
    #expect(hidden.lineNumberStyle == .hidden)
    #expect(hidden.showLineNumbers == false)
  }

  // MARK: - Hunk headers

  @Test
  func defaultsToHunkHeadersOn() {
    #expect(DiffConfiguration().showHunkHeaders == true)
  }

  @Test
  func withHunkHeadersCanDisable() {
    let config = DiffConfiguration().withHunkHeaders(false)
    #expect(config.showHunkHeaders == false)
  }

  // MARK: - Chaining preserves new fields

  @Test
  func chainingOtherModifiersPreservesNewFields() {
    let config = DiffConfiguration()
      .withLineNumberStyle(.single)
      .withHunkHeaders(false)
      .withFont(size: 14)
      .withLineSpacing(.comfortable)
      .with(theme: .dark)
      .withWordWrap(true)

    #expect(config.lineNumberStyle == .single)
    #expect(config.showHunkHeaders == false)
    #expect(config.fontSize == 14)
  }

  // MARK: - Preset

  @Test
  func mobilePresetUsesSingleColumnAndHidesHunkHeaders() {
    let mobile = DiffConfiguration.mobile
    #expect(mobile.lineNumberStyle == .single)
    #expect(mobile.showHunkHeaders == false)
  }
}
