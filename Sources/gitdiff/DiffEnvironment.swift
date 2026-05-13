import SwiftUI

/// Environment key for diff configuration
struct DiffConfigurationKey: EnvironmentKey {
    static let defaultValue = DiffConfiguration.default
}

/// Environment key for the active diff parser. Defaults to
/// ``UnifiedDiffParser`` so existing callers see no change.
struct DiffParserKey: EnvironmentKey {
    static let defaultValue: any DiffParsing = UnifiedDiffParser()
}

/// Environment extensions for diff configuration
extension EnvironmentValues {
    public var diffConfiguration: DiffConfiguration {
        get { self[DiffConfigurationKey.self] }
        set { self[DiffConfigurationKey.self] = newValue }
    }

    public var diffParser: any DiffParsing {
        get { self[DiffParserKey.self] }
        set { self[DiffParserKey.self] = newValue }
    }
}

// MARK: - View Modifiers

/// View modifiers for configuring diff rendering
public extension View {
    /// Applies a complete diff configuration.
    /// - Parameter configuration: The configuration to apply
    func diffConfiguration(_ configuration: DiffConfiguration) -> some View {
        environment(\.diffConfiguration, configuration)
    }
    
    /// Sets the color theme.
    /// - Parameter theme: The theme to apply
    func diffTheme(_ theme: DiffTheme) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = config.with(theme: theme)
        }
    }
    
    /// Shows or hides line numbers (legacy API — for finer control prefer
    /// ``diffLineNumberStyle(_:)``). Maps `true` → ``DiffConfiguration/LineNumberStyle/dual``,
    /// `false` → ``DiffConfiguration/LineNumberStyle/hidden``.
    func diffLineNumbers(_ show: Bool) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = config.withLineNumbers(show)
        }
    }

    /// Selects how the line-number gutter is rendered:
    /// `.hidden` (no gutter), `.single` (compact single column — ideal for
    /// mobile / narrow viewports), or `.dual` (side-by-side old/new
    /// columns — the desktop default).
    func diffLineNumberStyle(_ style: DiffConfiguration.LineNumberStyle) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = config.withLineNumberStyle(style)
        }
    }

    /// Shows or hides file headers (the `diff --git` / `---` / `+++` header
    /// block at the top of each file).
    func diffFileHeaders(_ show: Bool) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = config.withFileHeaders(show)
        }
    }

    /// Shows or hides per-hunk `@@ -a,b +c,d @@` separator lines. Hide
    /// these in minimal renderers where hunk boundaries are already
    /// implied by line backgrounds — the prose around the diff (a chip
    /// showing filename + stats, a sheet title, etc.) carries the location.
    func diffHunkHeaders(_ show: Bool) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = config.withHunkHeaders(show)
        }
    }

    /// Configures font properties.
    /// - Parameters:
    ///   - size: Font size
    ///   - weight: Font weight
    ///   - design: Font design (e.g., monospaced)
    func diffFont(size: CGFloat? = nil, weight: Font.Weight? = nil, design: Font.Design? = nil) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = config.withFont(size: size, weight: weight, design: design)
        }
    }
    
    /// Sets line spacing.
    /// - Parameter spacing: The spacing mode
    func diffLineSpacing(_ spacing: DiffConfiguration.LineSpacing) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = config.withLineSpacing(spacing)
        }
    }

    /// Enables or disables word wrapping.
    /// - Parameter wrap: Whether to wrap long lines
    func diffWordWrap(_ wrap: Bool) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = config.withWordWrap(wrap)
        }
    }
    
    /// Injects a custom ``DiffParsing`` implementation so the renderer can
    /// consume formats other than standard unified diff (annotated diffs,
    /// server-side payloads, JSON patches, …). The default parser is
    /// ``UnifiedDiffParser``.
    ///
    /// - Parameter parser: Any value conforming to ``DiffParsing``.
    func diffParser(_ parser: any DiffParsing) -> some View {
        environment(\.diffParser, parser)
    }

    /// Sets content padding
    func diffPadding(_ padding: EdgeInsets) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = DiffConfiguration(
                theme: config.theme,
                showLineNumbers: config.showLineNumbers,
                lineNumberStyle: config.lineNumberStyle,
                showFileHeaders: config.showFileHeaders,
                showHunkHeaders: config.showHunkHeaders,
                fontFamily: config.fontFamily,
                fontSize: config.fontSize,
                fontWeight: config.fontWeight,
                lineHeight: config.lineHeight,
                lineSpacing: config.lineSpacing,
                wordWrap: config.wordWrap,
                contentPadding: padding
            )
        }
    }
}