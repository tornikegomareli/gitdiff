//
//  ExamplesView.swift
//  GitDiffExample
//
//  Created by Tornike Gomareli on 18.06.25.
//

import SwiftUI
import gitdiff

struct ExamplesView: View {
  @State private var selectedCategory = "All"
  @State private var selectedExample: DiffExample?
  
  let categories = ["All", "Basic", "Files", "Advanced"]
  
  var filteredExamples: [DiffExample] {
    if selectedCategory == "All" {
      return DiffExample.allExamples
    } else {
      return DiffExample.allExamples.filter { $0.category == selectedCategory }
    }
  }
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        // Category Picker
        Picker("Category", selection: $selectedCategory) {
          ForEach(categories, id: \.self) { category in
            Text(category).tag(category)
          }
        }
        .pickerStyle(.segmented)
        .padding()
        
        // Examples Grid
        ScrollView {
          LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(filteredExamples) { example in
              ExampleCard(example: example) {
                selectedExample = example
              }
            }
          }
          .padding()
        }
      }
      .navigationTitle("Diff Examples")
      .sheet(item: $selectedExample) { example in
        ExampleDetailView(example: example)
      }
    }
  }
}

struct DiffExample: Identifiable {
  let id = UUID()
  let title: String
  let description: String
  let category: String
  let icon: String
  let diffContent: String
  let tags: [String]
  
  static let allExamples = [
    // Basic Examples
    DiffExample(
      title: "Simple Changes",
      description: "Basic code modifications with additions and deletions",
      category: "Basic",
      icon: "pencil.circle.fill",
      diffContent: SampleDiffs.simpleChanges,
      tags: ["additions", "deletions", "modifications"]
    ),
    DiffExample(
      title: "Multiple Hunks",
      description: "Changes spread across different parts of a file",
      category: "Basic",
      icon: "square.stack.3d.up.fill",
      diffContent: SampleDiffs.multipleHunks,
      tags: ["hunks", "sections", "multiple"]
    ),
    
    // File Operations
    DiffExample(
      title: "File Rename",
      description: "Renaming a file with content changes",
      category: "Files",
      icon: "arrow.triangle.swap",
      diffContent: SampleDiffs.fileRename,
      tags: ["rename", "move", "refactor"]
    ),
    DiffExample(
      title: "New File",
      description: "Adding a completely new file",
      category: "Files",
      icon: "doc.badge.plus",
      diffContent: SampleDiffs.newFile,
      tags: ["new", "create", "add"]
    ),
    DiffExample(
      title: "Deleted File",
      description: "Removing an existing file",
      category: "Files",
      icon: "trash.circle.fill",
      diffContent: SampleDiffs.deletedFile,
      tags: ["delete", "remove", "cleanup"]
    ),
    DiffExample(
      title: "Binary File",
      description: "Changes to binary files like images",
      category: "Files",
      icon: "photo.circle.fill",
      diffContent: SampleDiffs.binaryFile,
      tags: ["binary", "image", "assets"]
    ),
    
    // Advanced Examples
    DiffExample(
      title: "Large Diff",
      description: "Extensive changes with many additions and deletions",
      category: "Advanced",
      icon: "doc.text.magnifyingglass",
      diffContent: SampleDiffs.largeDiff,
      tags: ["large", "complex", "refactor"]
    ),
    DiffExample(
      title: "Multiple Files",
      description: "Changes across multiple files in one diff",
      category: "Advanced",
      icon: "folder.circle.fill",
      diffContent: SampleDiffs.multipleFiles,
      tags: ["multiple", "files", "project"]
    ),
    DiffExample(
      title: "Whitespace Changes",
      description: "Handling whitespace and formatting changes",
      category: "Advanced",
      icon: "textformat.size",
      diffContent: SampleDiffs.whitespaceChanges,
      tags: ["whitespace", "formatting", "style"]
    )
  ]
}

struct ExampleCard: View {
  let example: DiffExample
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      VStack(alignment: .leading, spacing: 12) {
        HStack {
          Image(systemName: example.icon)
            .font(.largeTitle)
            .foregroundColor(.blue)
          
          Spacer()
          
          Text(example.category)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(4)
        }
        
        Text(example.title)
          .font(.headline)
          .foregroundColor(.primary)
        
        Text(example.description)
          .font(.caption)
          .foregroundColor(.secondary)
          .lineLimit(2)
        
        // Tags
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 6) {
            ForEach(example.tags, id: \.self) { tag in
              Text("#\(tag)")
                .font(.caption2)
                .foregroundColor(.blue)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(4)
            }
          }
        }
      }
      .padding()
      .frame(maxWidth: .infinity, minHeight: 150)
      .background(Color(.systemBackground))
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(Color.gray.opacity(0.2), lineWidth: 1)
      )
      .shadow(color: .black.opacity(0.05), radius: 5)
    }
    .buttonStyle(PlainButtonStyle())
  }
}

struct ExampleDetailView: View {
  let example: DiffExample
  @Environment(\.dismiss) var dismiss
  @State private var selectedTheme: DiffTheme = .light
  @State private var showLineNumbers = true
  @State private var showFileHeaders = true
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        // Theme selector
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 12) {
            ForEach([
              ("Light", DiffTheme.light),
              ("Dark", DiffTheme.dark),
              ("GitLab", DiffTheme.gitlab)
            ], id: \.0) { name, theme in
              Button(action: { selectedTheme = theme }) {
                Text(name)
                  .font(.caption)
                  .padding(.horizontal, 12)
                  .padding(.vertical, 6)
                  .background(selectedTheme == theme ? Color.blue : Color.gray.opacity(0.2))
                  .foregroundColor(selectedTheme == theme ? .white : .primary)
                  .cornerRadius(8)
              }
            }
          }
          .padding()
        }
        .background(Color(.systemGroupedBackground))
        
        // Controls
        HStack {
          Toggle("Line Numbers", isOn: $showLineNumbers)
          Toggle("File Headers", isOn: $showFileHeaders)
          Spacer()
          Button(action: shareExample) {
            Image(systemName: "square.and.arrow.up")
          }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        
        // Diff content
        ScrollView {
          DiffRenderer(diffText: example.diffContent)
            .diffTheme(selectedTheme)
            .diffLineNumbers(showLineNumbers)
            .diffFileHeaders(showFileHeaders)
            .padding()
        }
      }
      .navigationTitle(example.title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") { dismiss() }
        }
      }
    }
  }
  
  private func shareExample() {
    // Share functionality would go here
  }
}

#Preview {
  ExamplesView()
}
