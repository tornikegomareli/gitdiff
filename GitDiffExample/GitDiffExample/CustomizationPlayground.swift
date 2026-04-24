//
//  CustomizationPlayground.swift
//  GitDiffExample
//
//  Created by Tornike Gomareli on 18.06.25.
//

import SwiftUI
import gitdiff

struct CustomizationPlayground: View {
  @State private var showLineNumbers = true
  @State private var showFileHeaders = true
  @State private var fontSize: CGFloat = 13
  @State private var lineSpacing: DiffConfiguration.LineSpacing = .compact
  @State private var wordWrap = true
  @State private var fontWeight: Font.Weight = .regular
  @State private var selectedTheme: DiffTheme = .light
  @State private var showCustomizationSheet = false
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          Text("Live Preview")
            .font(.title2.bold())
            .padding(.horizontal)
            .padding(.top)
          
          DiffRenderer(diffText: SampleDiffs.configPlaygroundDiff)
            .diffTheme(selectedTheme)
            .diffLineNumbers(showLineNumbers)
            .diffFileHeaders(showFileHeaders)
            .diffFont(size: fontSize, weight: fontWeight)
            .diffLineSpacing(lineSpacing)
            .diffWordWrap(wordWrap)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5)
            .padding(.horizontal)
          
          ConfigurationSummary(
            theme: themeName,
            fontSize: fontSize,
            fontWeight: fontWeight,
            lineNumbers: showLineNumbers,
            fileHeaders: showFileHeaders,
            wordWrap: wordWrap,
            lineSpacing: lineSpacing
          )
          .padding()
        }
      }
      .navigationTitle("Customization Playground")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { showCustomizationSheet = true }) {
            Label("Customize", systemImage: "slider.horizontal.3")
          }
        }
      }
      .sheet(isPresented: $showCustomizationSheet) {
        CustomizationSheet(
          showLineNumbers: $showLineNumbers,
          showFileHeaders: $showFileHeaders,
          fontSize: $fontSize,
          lineSpacing: $lineSpacing,
          wordWrap: $wordWrap,
          fontWeight: $fontWeight,
          selectedTheme: $selectedTheme
        )
      }
    }
  }
  
  private var themeName: String {
    switch selectedTheme {
    case .light: return "Light"
    case .dark: return "Dark"
    case .gitlab: return "GitLab"
    default: return "Custom"
    }
  }
}

struct CustomizationSheet: View {
  @Binding var showLineNumbers: Bool
  @Binding var showFileHeaders: Bool
  @Binding var fontSize: CGFloat
  @Binding var lineSpacing: DiffConfiguration.LineSpacing
  @Binding var wordWrap: Bool
  @Binding var fontWeight: Font.Weight
  @Binding var selectedTheme: DiffTheme
  
  @Environment(\.dismiss) var dismiss
  @State private var showSavedConfigs = false
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          VStack(alignment: .leading, spacing: 12) {
            Label("Theme", systemImage: "paintbrush.fill")
              .font(.headline)
            
            Picker("Theme", selection: $selectedTheme) {
              Text("Light").tag(DiffTheme.light)
              Text("Dark").tag(DiffTheme.dark)
              Text("GitLab").tag(DiffTheme.gitlab)
            }
            .pickerStyle(.segmented)
          }
          
          Divider()
          
          VStack(alignment: .leading, spacing: 12) {
            Label("Font Settings", systemImage: "textformat")
              .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
              HStack {
                Text("Size")
                Spacer()
                Text("\(Int(fontSize))pt")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
              
              Slider(value: $fontSize, in: 10...20, step: 1)
                .accentColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 8) {
              Text("Weight")
              
              Picker("Weight", selection: $fontWeight) {
                Text("Regular").tag(Font.Weight.regular)
                Text("Medium").tag(Font.Weight.medium)
                Text("Semibold").tag(Font.Weight.semibold)
                Text("Bold").tag(Font.Weight.bold)
              }
              .pickerStyle(.segmented)
            }
          }
          
          Divider()
          
          VStack(alignment: .leading, spacing: 12) {
            Label("Layout", systemImage: "square.grid.3x3")
              .font(.headline)
            
            Toggle("Show Line Numbers", isOn: $showLineNumbers)

            Toggle("Show File Headers", isOn: $showFileHeaders)

            Toggle("Word Wrap", isOn: $wordWrap)
            
            VStack(alignment: .leading, spacing: 8) {
              Text("Line Spacing")
              
              Picker("Spacing", selection: $lineSpacing) {
                Text("Compact").tag(DiffConfiguration.LineSpacing.compact)
                Text("Comfortable").tag(DiffConfiguration.LineSpacing.comfortable)
                Text("Spacious").tag(DiffConfiguration.LineSpacing.spacious)
              }
              .pickerStyle(.segmented)
            }
          }
          
          Divider()
          
          VStack(alignment: .leading, spacing: 12) {
            Label("Presets", systemImage: "star.fill")
              .font(.headline)
            
            VStack(spacing: 8) {
              PresetButton(title: "Default", icon: "house") {
                applyPreset(.default)
              }
              
              PresetButton(title: "Code Review", icon: "eye") {
                applyPreset(.codeReview)
              }
              
              PresetButton(title: "Mobile", icon: "iphone") {
                applyPreset(.mobile)
              }
              
              PresetButton(title: "Presentation", icon: "tv") {
                applyPreset(.presentation)
              }
            }
          }
          
          Divider()
          
          VStack(spacing: 12) {
            Button(action: resetToDefaults) {
              Label("Reset to Defaults", systemImage: "arrow.counterclockwise")
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            
            Button(action: { showSavedConfigs = true }) {
              Label("Save Configuration", systemImage: "square.and.arrow.down")
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
          }
        }
        .padding()
      }
      .navigationTitle("Customize Diff View")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") {
            dismiss()
          }
        }
      }
      .sheet(isPresented: $showSavedConfigs) {
        SavedConfigurationsView()
      }
    }
  }
  
  private func applyPreset(_ config: DiffConfiguration) {
    withAnimation {
      selectedTheme = config.theme
      showLineNumbers = config.showLineNumbers
      showFileHeaders = config.showFileHeaders
      fontSize = config.fontSize
      fontWeight = config.fontWeight
      lineSpacing = config.lineSpacing
      wordWrap = config.wordWrap
    }
  }
  
  private func resetToDefaults() {
    withAnimation {
      showLineNumbers = true
      showFileHeaders = true
      fontSize = 13
      lineSpacing = .compact
      wordWrap = true
      fontWeight = .regular
      selectedTheme = .light
    }
  }
}

struct PresetButton: View {
  let title: String
  let icon: String
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack {
        Image(systemName: icon)
        Text(title)
        Spacer()
        Image(systemName: "chevron.right")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .padding()
      .background(Color(.systemBackground))
      .cornerRadius(8)
    }
    .buttonStyle(PlainButtonStyle())
  }
}

struct ConfigurationSummary: View {
  let theme: String
  let fontSize: CGFloat
  let fontWeight: Font.Weight
  let lineNumbers: Bool
  let fileHeaders: Bool
  let wordWrap: Bool
  let lineSpacing: DiffConfiguration.LineSpacing
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Current Configuration")
        .font(.headline)
      
      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        ConfigItem(label: "Theme", value: theme)
        ConfigItem(label: "Font Size", value: "\(Int(fontSize))pt")
        ConfigItem(label: "Font Weight", value: fontWeightName)
        ConfigItem(label: "Line Numbers", value: lineNumbers ? "On" : "Off")
        ConfigItem(label: "File Headers", value: fileHeaders ? "On" : "Off")
        ConfigItem(label: "Word Wrap", value: wordWrap ? "On" : "Off")
        ConfigItem(label: "Line Spacing", value: lineSpacingName)
      }
    }
    .padding()
    .background(Color(.secondarySystemBackground))
    .cornerRadius(12)
  }
  
  private var fontWeightName: String {
    switch fontWeight {
    case .regular: return "Regular"
    case .medium: return "Medium"
    case .semibold: return "Semibold"
    case .bold: return "Bold"
    default: return "Regular"
    }
  }
  
  private var lineSpacingName: String {
    switch lineSpacing {
    case .compact: return "Compact"
    case .comfortable: return "Comfortable"
    case .spacious: return "Spacious"
    }
  }
}

struct ConfigItem: View {
  let label: String
  let value: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(label)
        .font(.caption)
        .foregroundColor(.secondary)
      Text(value)
        .font(.footnote.bold())
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

struct SavedConfigurationsView: View {
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    NavigationView {
      VStack {
        Text("Saved Configurations")
          .font(.largeTitle)
        Text("Coming Soon")
          .foregroundColor(.secondary)
      }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") { dismiss() }
        }
      }
    }
  }
}

extension DiffConfiguration {
  static let codeReview = DiffConfiguration(
    theme: .light,
    showLineNumbers: true,
    fontFamily: .monospaced, fontSize: 12,
    fontWeight: .regular,
    lineSpacing: .comfortable,
    wordWrap: false,
    contentPadding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
  )
  
  static let mobile = DiffConfiguration(
    theme: .light,
    showLineNumbers: false,
    fontFamily: .monospaced, fontSize: 11,
    fontWeight: .regular,
    lineSpacing: .compact,
    wordWrap: true,
    contentPadding: EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
  )
  
  static let presentation = DiffConfiguration(
    theme: .dark,
    showLineNumbers: true,
    fontFamily: .monospaced, fontSize: 16,
    fontWeight: .semibold,
    lineSpacing: .spacious,
    wordWrap: true,
    contentPadding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
  )
}

#Preview {
  CustomizationPlayground()
}
