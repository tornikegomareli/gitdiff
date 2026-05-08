import SwiftUI

/// Builder pattern extensions for DiffConfiguration
public extension DiffConfiguration {
    /// Creates a new configuration with the specified theme
    func with(theme: DiffTheme) -> DiffConfiguration {
        DiffConfiguration(
            theme: theme,
            showLineNumbers: showLineNumbers,
            showFileHeaders: showFileHeaders,
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight,
            lineHeight: lineHeight,
            lineSpacing: lineSpacing,
            wordWrap: wordWrap,
            contentPadding: contentPadding
        )
    }
    
    /// Creates a new configuration with line numbers toggled
    func withLineNumbers(_ show: Bool) -> DiffConfiguration {
        DiffConfiguration(
            theme: theme,
            showLineNumbers: show,
            showFileHeaders: showFileHeaders,
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight,
            lineHeight: lineHeight,
            lineSpacing: lineSpacing,
            wordWrap: wordWrap,
            contentPadding: contentPadding
        )
    }
    
    /// Creates a new configuration with the specified font settings
    func withFont(size: CGFloat? = nil, weight: Font.Weight? = nil, design: Font.Design? = nil) -> DiffConfiguration {
        DiffConfiguration(
            theme: theme,
            showLineNumbers: showLineNumbers,
            showFileHeaders: showFileHeaders,
            fontFamily: design ?? fontFamily,
            fontSize: size ?? fontSize,
            fontWeight: weight ?? fontWeight,
            lineHeight: lineHeight,
            lineSpacing: lineSpacing,
            wordWrap: wordWrap,
            contentPadding: contentPadding
        )
    }
    
    /// Creates a new configuration with the specified line spacing
    func withLineSpacing(_ spacing: LineSpacing) -> DiffConfiguration {
        DiffConfiguration(
            theme: theme,
            showLineNumbers: showLineNumbers,
            showFileHeaders: showFileHeaders,
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight,
            lineHeight: lineHeight,
            lineSpacing: spacing,
            wordWrap: wordWrap,
            contentPadding: contentPadding
        )
    }
    
    /// Creates a new configuration with file headers toggled
    func withFileHeaders(_ show: Bool) -> DiffConfiguration {
        DiffConfiguration(
            theme: theme,
            showLineNumbers: showLineNumbers,
            showFileHeaders: show,
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight,
            lineHeight: lineHeight,
            lineSpacing: lineSpacing,
            wordWrap: wordWrap,
            contentPadding: contentPadding
        )
    }

    /// Creates a new configuration with word wrap toggled
    func withWordWrap(_ wrap: Bool) -> DiffConfiguration {
        DiffConfiguration(
            theme: theme,
            showLineNumbers: showLineNumbers,
            showFileHeaders: showFileHeaders,
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight,
            lineHeight: lineHeight,
            lineSpacing: lineSpacing,
            wordWrap: wrap,
            contentPadding: contentPadding
        )
    }
}

// MARK: - Preset Configurations

/// Preset configurations for common use cases.
public extension DiffConfiguration {
    /// Configuration optimized for code review with comfortable spacing.
    static let codeReview = DiffConfiguration.default
        .withLineNumbers(true)
        .withFont(size: 13)
        .withLineSpacing(.comfortable)
    
    /// Configuration optimized for mobile with smaller fonts.
    static let mobile = DiffConfiguration.default
        .withFont(size: 12)
        .withLineSpacing(.compact)
        .withWordWrap(true)
    
    /// Configuration for presentations with larger fonts.
    static let presentation = DiffConfiguration.default
        .withFont(size: 16, weight: .medium)
        .withLineSpacing(.spacious)
        .withLineNumbers(false)
}