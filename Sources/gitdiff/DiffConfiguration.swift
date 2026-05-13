import SwiftUI

/// Configuration for customizing diff rendering.
///
/// ## Topics
/// ### Creating Configurations
/// - ``init(theme:showLineNumbers:lineNumberStyle:showFileHeaders:showHunkHeaders:fontFamily:fontSize:fontWeight:lineHeight:lineSpacing:wordWrap:contentPadding:)``
/// - ``default``
/// - ``compact``
/// - ``comfortable``
/// - ``darkMode``
public struct DiffConfiguration {
    /// The theme to use for colors
    public let theme: DiffTheme

    /// Whether to show line numbers (legacy API — for richer control over
    /// the gutter layout, prefer ``lineNumberStyle``).
    public let showLineNumbers: Bool

    /// How the line-number gutter is rendered. Defaults to ``LineNumberStyle/dual``
    /// (the side-by-side `old | new` columns standard for unified diffs).
    ///
    /// - ``LineNumberStyle/hidden``: no gutter at all (equivalent to
    ///   `showLineNumbers = false`).
    /// - ``LineNumberStyle/single``: a single column showing the new line
    ///   number for added/context lines and the old line number for removed
    ///   lines — compact and well-suited to narrow viewports (mobile).
    /// - ``LineNumberStyle/dual``: two columns, old then new — full context,
    ///   wider gutter, the desktop convention.
    public let lineNumberStyle: LineNumberStyle

    /// Whether to show file headers
    public let showFileHeaders: Bool

    /// Whether to show the per-hunk `@@ -x,y +x,y @@` separator line.
    /// Default `true`; turn off for minimal renderers where the hunk
    /// boundary is implied by the line backgrounds.
    public let showHunkHeaders: Bool

    /// Font family for code content
    public let fontFamily: Font.Design

    /// Font size for code content
    public let fontSize: CGFloat

    /// Font weight for code content
    public let fontWeight: Font.Weight

    /// Line height multiplier
    public let lineHeight: CGFloat

    /// Line spacing mode
    public let lineSpacing: LineSpacing

    /// Whether to wrap long lines
    public let wordWrap: Bool

    /// Padding for content
    public let contentPadding: EdgeInsets

    public enum LineSpacing {
        case compact
        case comfortable
        case spacious

        var value: CGFloat {
            switch self {
            case .compact: return 0
            case .comfortable: return 2
            case .spacious: return 4
            }
        }
    }

    /// How the line-number gutter is rendered. See ``lineNumberStyle``.
    public enum LineNumberStyle: Sendable, Hashable {
        case hidden
        case single
        case dual
    }

    public init(
        theme: DiffTheme = .github,
        showLineNumbers: Bool = true,
        lineNumberStyle: LineNumberStyle? = nil,
        showFileHeaders: Bool = true,
        showHunkHeaders: Bool = true,
        fontFamily: Font.Design = .monospaced,
        fontSize: CGFloat = 13,
        fontWeight: Font.Weight = .regular,
        lineHeight: CGFloat = 1.2,
        lineSpacing: LineSpacing = .compact,
        wordWrap: Bool = true,
        contentPadding: EdgeInsets = EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
    ) {
        self.theme = theme
        self.showLineNumbers = showLineNumbers
        // If the caller didn't ask for a specific style we infer one from
        // the legacy `showLineNumbers` flag so existing call sites keep
        // their current behaviour.
        self.lineNumberStyle = lineNumberStyle ?? (showLineNumbers ? .dual : .hidden)
        self.showFileHeaders = showFileHeaders
        self.showHunkHeaders = showHunkHeaders
        self.fontFamily = fontFamily
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.lineHeight = lineHeight
        self.lineSpacing = lineSpacing
        self.wordWrap = wordWrap
        self.contentPadding = contentPadding
    }
}

public extension DiffConfiguration {
    /// Default GitHub-style configuration
    static let `default` = DiffConfiguration()

    /// Compact configuration with minimal spacing
    static let compact = DiffConfiguration(
        fontSize: 12,
        lineSpacing: .compact,
        contentPadding: EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
    )

    /// Comfortable configuration with more spacing
    static let comfortable = DiffConfiguration(
        fontSize: 14,
        lineSpacing: .comfortable,
        contentPadding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
    )

    /// Dark mode configuration with VS Code theme
    static let darkMode = DiffConfiguration(
        theme: .vsCodeDark
    )
}
