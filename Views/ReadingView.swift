//
//  ReadingView.swift
//  NovelReader
//
//  阅读界面 - 核心阅读体验
//

import SwiftUI

struct ReadingView: View {
    @EnvironmentObject var libraryManager: LibraryManager
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) var dismiss

    let novel: Novel
    @State private var currentChapterIndex: Int
    @State private var showingTableOfContents = false
    @State private var showingSettings = false
    @State private var showingBookmarks = false
    @State private var searchText = ""

    init(novel: Novel) {
        self.novel = novel
        _currentChapterIndex = State(initialValue: novel.currentChapterIndex)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景
                settingsManager.settings.theme.backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // 阅读内容
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 20) {
                            ForEach(chapters, id: \.self) { chapter in
                                Text(chapter)
                                    .font(.system(size: settingsManager.settings.fontSize))
                                    .lineSpacing(settingsManager.settings.lineHeight)
                                    .foregroundColor(settingsManager.settings.theme.textColor)
                                    .padding()
                            }
                        }
                        .padding()
                    }
                    .coordinateSpace(name: "scroll")
                }

                // 顶部工具栏
                VStack {
                    toolbarView
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingTableOfContents) {
            TableOfContentsView(novel: novel, currentChapterIndex: $currentChapterIndex)
        }
        .sheet(isPresented: $showingSettings) {
            ReadingSettingsView()
        }
        .sheet(isPresented: $showingBookmarks) {
            BookmarksView(novel: novel)
        }
    }

    // MARK: - 工具栏

    private var toolbarView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
            }

            Spacer()

            Button(action: { showingBookmarks = true }) {
                Image(systemName: "bookmark")
            }

            Button(action: { showingTableOfContents = true }) {
                Image(systemName: "list.bullet")
            }

            Button(action: { showingSettings = true }) {
                Image(systemName: "textformat.size")
            }
        }
        .padding()
        .background(settingsManager.settings.theme.backgroundColor.opacity(0.95))
    }

    // MARK: - 章节内容

    private var chapters: [String] {
        // 这里应该从 novel.filePath 读取并解析章节
        // 简化版本：返回示例内容
        return ["示例章节内容...\n\n这是一个小说阅读器演示。\n\n实际使用中会从文件加载真实内容。"]
    }
}

// MARK: - 目录视图

struct TableOfContentsView: View {
    @Environment(\.dismiss) var dismiss
    let novel: Novel
    @Binding var currentChapterIndex: Int

    var body: some View {
        NavigationView {
            List(0..<5) { index in
                Button(action: {
                    currentChapterIndex = index
                    dismiss()
                }) {
                    VStack(alignment: .leading) {
                        Text("第 \(index + 1) 章")
                            .font(.headline)
                        Text("示例章节标题")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("目录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - 阅读设置视图

struct ReadingSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section("字体大小") {
                    HStack {
                        Text("小")
                        Slider(value: $settingsManager.settings.fontSize, in: 12...40, step: 2)
                        Text("大")
                    }

                    Text("\(Int(settingsManager.settings.fontSize))pt")
                        .foregroundColor(.secondary)
                }

                Section("行间距") {
                    Slider(value: $settingsManager.settings.lineHeight, in: 1.0...2.5, step: 0.1)
                    Text(String(format: "%.1f", settingsManager.settings.lineHeight))
                        .foregroundColor(.secondary)
                }

                Section("主题") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Button(action: {
                                settingsManager.settings.theme = theme
                            }) {
                                VStack {
                                    Rectangle()
                                        .fill(theme.backgroundColor)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(settingsManager.settings.theme == theme ? Color.blue : Color.clear, lineWidth: 3)
                                        )
                                        .frame(height: 50)
                                        .cornerRadius(8)

                                    Text(themeName(theme))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section("字体") {
                    Picker("字体", selection: $settingsManager.settings.fontFamily) {
                        ForEach(FontFamily.allCases, id: \.self) { font in
                            Text(font.displayName).tag(font)
                        }
                    }
                }
            }
            .navigationTitle("阅读设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func themeName(_ theme: AppTheme) -> String {
        switch theme {
        case .light: return "浅色"
        case .dark: return "深色"
        case .sepia: return "护眼"
        case .eyeProtection: return "绿色"
        }
    }
}

// MARK: - 书签视图

struct BookmarksView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var libraryManager: LibraryManager
    let novel: Novel
    @State private var showingAddBookmark = false

    var body: some View {
        NavigationView {
            Group {
                if novel.bookmarks.isEmpty {
                    VStack {
                        Image(systemName: "bookmark")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)

                        Text("暂无书签")
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(novel.bookmarks) { bookmark in
                            BookmarkRowView(bookmark: bookmark)
                        }
                    }
                }
            }
            .navigationTitle("书签")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddBookmark = true }) {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct BookmarkRowView: View {
    let bookmark: Bookmark

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("第 \(bookmark.chapterIndex + 1) 章")
                .font(.headline)

            if !bookmark.note.isEmpty {
                Text(bookmark.note)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Text(bookmark.createdAt, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ReadingView(novel: Novel(
        title: "测试小说",
        filePath: URL(fileURLWithPath: "/tmp/test.txt")
    ))
    .environmentObject(LibraryManager())
    .environmentObject(SettingsManager())
}
