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
            config = DiffConfiguration(
                theme: theme,
                showLineNumbers: config.showLineNumbers,
                showFileHeaders: config.showFileHeaders,
                fontFamily: config.fontFamily,
                fontSize: config.fontSize,
                fontWeight: config.fontWeight,
                lineHeight: config.lineHeight,
                lineSpacing: config.lineSpacing,
                wordWrap: config.wordWrap,
                contentPadding: config.contentPadding
            )
        }
    }
    
    /// Shows or hides line numbers.
    /// - Parameter show: Whether to show line numbers
    func diffLineNumbers(_ show: Bool) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = DiffConfiguration(
                theme: config.theme,
                showLineNumbers: show,
                showFileHeaders: config.showFileHeaders,
                fontFamily: config.fontFamily,
                fontSize: config.fontSize,
                fontWeight: config.fontWeight,
                lineHeight: config.lineHeight,
                lineSpacing: config.lineSpacing,
                wordWrap: config.wordWrap,
                contentPadding: config.contentPadding
            )
        }
    }

    /// Shows or hides file headers.
    /// - Parameter show: Whether to show file headers
    func diffFileHeaders(_ show: Bool) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = DiffConfiguration(
                theme: config.theme,
                showLineNumbers: config.showLineNumbers,
                showFileHeaders: show,
                fontFamily: config.fontFamily,
                fontSize: config.fontSize,
                fontWeight: config.fontWeight,
                lineHeight: config.lineHeight,
                lineSpacing: config.lineSpacing,
                wordWrap: config.wordWrap,
                contentPadding: config.contentPadding
            )
        }
    }

    /// Configures font properties.
    /// - Parameters:
    ///   - size: Font size
    ///   - weight: Font weight
    ///   - design: Font design (e.g., monospaced)
    func diffFont(size: CGFloat? = nil, weight: Font.Weight? = nil, design: Font.Design? = nil) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = DiffConfiguration(
                theme: config.theme,
                showLineNumbers: config.showLineNumbers,
                showFileHeaders: config.showFileHeaders,
                fontFamily: design ?? config.fontFamily,
                fontSize: size ?? config.fontSize,
                fontWeight: weight ?? config.fontWeight,
                lineHeight: config.lineHeight,
                lineSpacing: config.lineSpacing,
                wordWrap: config.wordWrap,
                contentPadding: config.contentPadding
            )
        }
    }
    
    /// Sets line spacing.
    /// - Parameter spacing: The spacing mode
    func diffLineSpacing(_ spacing: DiffConfiguration.LineSpacing) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = DiffConfiguration(
                theme: config.theme,
                showLineNumbers: config.showLineNumbers,
                showFileHeaders: config.showFileHeaders,
                fontFamily: config.fontFamily,
                fontSize: config.fontSize,
                fontWeight: config.fontWeight,
                lineHeight: config.lineHeight,
                lineSpacing: spacing,
                wordWrap: config.wordWrap,
                contentPadding: config.contentPadding
            )
        }
    }
    
    /// Enables or disables word wrapping.
    /// - Parameter wrap: Whether to wrap long lines
    func diffWordWrap(_ wrap: Bool) -> some View {
        transformEnvironment(\.diffConfiguration) { config in
            config = DiffConfiguration(
                theme: config.theme,
                showLineNumbers: config.showLineNumbers,
                showFileHeaders: config.showFileHeaders,
                fontFamily: config.fontFamily,
                fontSize: config.fontSize,
                fontWeight: config.fontWeight,
                lineHeight: config.lineHeight,
                lineSpacing: config.lineSpacing,
                wordWrap: wrap,
                contentPadding: config.contentPadding
            )
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
                showFileHeaders: config.showFileHeaders,
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