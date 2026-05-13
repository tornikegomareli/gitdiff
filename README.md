# gitdiff

Render git diff output, simple as that.

## Overview

gitdiff is a native Swift renderer and SwiftUI component for rendering Git diffs on iOS. It offers accurate, efficient and customized diff visualization with the look and feel of tools like GitHub or GitLab.

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.9+-orange.svg" />
  <img src="https://img.shields.io/badge/iOS-15.0+-blue.svg" />
  <img src="https://img.shields.io/badge/SwiftUI-Native-green.svg" />
</p>

## Showcase


<p align="center">
  <img src="https://github.com/user-attachments/assets/59f9d428-0e53-4084-b555-d90f5de7288f" width="30%" />
  <img src="https://github.com/user-attachments/assets/13a52f90-d0e3-4041-8fc9-a6d5f7cff46c" width="30%" />
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/ee6fbe6a-d3b9-48f9-9e57-0cc313dca031" width="30%" />
  <img src="https://github.com/user-attachments/assets/c8da701d-f952-4fea-a7bd-45cef2c40f2d" width="30%" />
  <img src="https://github.com/user-attachments/assets/0391a6c3-169b-4d78-92ad-7b64ed5be90c" width="30%" />
</p>

## Installation


### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/tornikegomareli/gitdiff.git", from: "0.0.5")
]
```

Or add through Xcode: **File → Add Package Dependencies**

## Quick Start

```swift
import SwiftUI
import gitdiff

struct ContentView: View {
    let diffText = """
        @@ -1,3 +1,3 @@
        -let oldValue = "Hello"
        +let newValue = "World"
         let unchanged = true
        """

    var body: some View {
        DiffRenderer(diffText: diffText)
            .diffTheme(.dark)
    }
}
```

## Themes

gitdiff comes with three crafted themes:

| Light (GitHub Style) | Dark | GitLab |
|---------------------|------|--------|
| Clean and familiar | Easy on the eyes | Simple and clean |

### Using Built-in Themes

```swift
DiffRenderer(diffText: diffContent)
    .diffTheme(.light)    // GitHub-style
    .diffTheme(.dark)     // Modern dark theme
    .diffTheme(.gitlab)   // GitLab's style
```

### Creating Custom Themes

```swift
let customTheme = DiffTheme(
    addedBackground: Color.green.opacity(0.2),
    addedText: Color.green,
    removedBackground: Color.red.opacity(0.2),
    removedText: Color.red,
    contextBackground: Color(UIColor.systemBackground),
    contextText: Color.primary,
    lineNumberBackground: Color.gray.opacity(0.1),
    lineNumberText: Color.secondary,
    headerBackground: Color.blue.opacity(0.1),
    headerText: Color.blue,
    fileHeaderBackground: Color.gray.opacity(0.05),
    fileHeaderText: Color.primary
)

DiffRenderer(diffText: diffContent)
    .diffTheme(customTheme)
```

## Configuration

### View Modifiers

Chain modifiers for quick configuration:

```swift
DiffRenderer(diffText: diffContent)
    .diffTheme(.dark)
    .diffLineNumbers(true)
    .diffFont(size: 14, weight: .medium)
    .diffLineSpacing(.comfortable)
    .diffWordWrap(true)
```

### Configuration Object

For reusable configurations:

```swift
let codeReviewConfig = DiffConfiguration(
    theme: .light,
    showLineNumbers: true,
    showFileHeaders: true,
    fontSize: 13,
    fontWeight: .regular,
    lineSpacing: .comfortable,
    wordWrap: false
)

DiffRenderer(diffText: diffContent)
    .environment(\.diffConfiguration, codeReviewConfig)
```

### Preset Configurations

Ready-to-use configurations for common scenarios:

```swift
// For code reviews - compact and efficient
.environment(\.diffConfiguration, .codeReview)

// For presentations - large and readable
.environment(\.diffConfiguration, .presentation)
```

## Advanced Usage

### Working with the Parser

For custom rendering needs:

```swift
let parser = DiffParser()
let files = parser.parse(diffText)

ForEach(files) { file in
    VStack(alignment: .leading) {
        Text(file.displayName)
            .font(.headline)

        ForEach(file.hunks) { hunk in
            Text(hunk.header)
                .font(.caption)
                .foregroundColor(.secondary)

            ForEach(hunk.lines) { line in
                // Custom line rendering
            }
        }
    }
}
```

### Integration Examples

**With Git Commands:**
```swift
let gitOutput = shell("git diff HEAD~1")
DiffRenderer(diffText: gitOutput)
```

**In a Code Review App:**
```swift
struct PullRequestView: View {
    let pullRequest: PullRequest
    @State private var showLineNumbers = true

    var body: some View {
        ScrollView {
            DiffRenderer(diffText: pullRequest.diff)
                .diffTheme(.light)
                .diffLineNumbers(showLineNumbers)
        }
        .toolbar {
            Toggle("Line Numbers", isOn: $showLineNumbers)
        }
    }
}
```
### View Modifiers

- `.diffTheme(_ theme: DiffTheme)` - Apply a color theme
- `.diffLineNumbers(_ show: Bool)` - Toggle line numbers (legacy; prefer `.diffLineNumberStyle(_:)`)
- `.diffLineNumberStyle(_ style: LineNumberStyle)` - Gutter style: `.hidden`, `.single` (mobile-friendly compact column), `.dual` (desktop old/new)
- `.diffFileHeaders(_ show: Bool)` - Toggle file headers (the `diff --git` / `---` / `+++` block)
- `.diffHunkHeaders(_ show: Bool)` - Toggle the per-hunk `@@ -a,b +c,d @@` separator
- `.diffFont(size: CGFloat?, weight: Font.Weight?, design: Font.Design?)` - Configure font
- `.diffLineSpacing(_ spacing: LineSpacing)` - Set line spacing
- `.diffWordWrap(_ wrap: Bool)` - Enable word wrapping
- `.diffConfiguration(_ config: DiffConfiguration)` - Apply complete configuration
- `.diffParser(_ parser: any DiffParsing)` - Plug in a custom parser (see below)

### Mobile-friendly defaults

For phones and other narrow viewports the `.dual` gutter is cramped and the `@@` hunk header is rarely useful. A typical mobile renderer looks like:

```swift
DiffRenderer(diffText: text)
    .diffLineNumberStyle(.single)   // one column, new# for + / old# for -
    .diffHunkHeaders(false)         // hide @@ -a,b +c,d @@
    .diffTheme(.dark)
```

There's also a `.mobile` preset that bundles these:

```swift
DiffRenderer(diffText: text)
    .diffConfiguration(.mobile)
```

## Custom Diff Formats

`DiffRenderer` accepts unified-diff text by default. To consume any other format — annotated diffs, server-side payloads, JSON patches, language-server output — implement `DiffParsing` and inject it via the `.diffParser(_:)` modifier:

```swift
import gitdiff

struct MyAnnotatedDiffParser: DiffParsing {
    let filePath: String

    func parse(_ diffText: String) async throws -> [DiffFile] {
        // Map your custom format → [DiffFile] using the public initializers
        // on DiffFile / DiffHunk / DiffLine. The renderer doesn't care how
        // you produced the model.
        [
            DiffFile(
                oldPath: filePath,
                newPath: filePath,
                hunks: [
                    DiffHunk(
                        oldStart: 1, oldCount: 1, newStart: 1, newCount: 1,
                        header: "",
                        lines: [
                            DiffLine(type: .removed, content: "old", oldLineNumber: 1, newLineNumber: nil),
                            DiffLine(type: .added, content: "new", oldLineNumber: nil, newLineNumber: 1),
                        ]
                    )
                ]
            )
        ]
    }
}

// Inject — default stays `UnifiedDiffParser` if no override.
DiffRenderer(diffText: myRawText)
    .diffParser(MyAnnotatedDiffParser(filePath: "foo.swift"))
    .diffTheme(.dark)
```

## Example App

Explore all features with the included example app:

1. Open `GitDiffExample/GitDiffExample.xcodeproj`
2. Run the app to see:
   - Live theme switching
   - Interactive customization
   - Various diff examples
   - Code snippets

## Performance

- Efficient parsing of large diffs
- Smooth scrolling performance
- Minimal memory footprint
- No external dependencies

## Requirements

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+

## Contributing

Any ideas or improvements? Create pull requests.

## License

MIT License - see [LICENSE](https://github.com/tornikegomareli/gitdiff/blob/main/LICENSE) for details.
