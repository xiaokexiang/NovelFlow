//
//  ContentView.swift
//  NovelReader
//
//  主界面 - 书库列表
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject var libraryManager: LibraryManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showingImporter = false
    @State private var selectedNovel: Novel?

    var body: some View {
        NavigationView {
            Group {
                if libraryManager.novels.isEmpty {
                    EmptyLibraryView(showingImporter: $showingImporter)
                } else {
                    LibraryListView(selectedNovel: $selectedNovel)
                }
            }
            .navigationTitle("我的书架")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingImporter = true }) {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
        .fileImporter(
            isPresented: $showingImporter,
            allowedContentTypes: [.plainText, .utf8Text, .utf16ExternalPlainText],
            allowsMultipleSelection: false
        ) { result in
            Task {
                do {
                    guard let url = try result.get().first else { return }
                    _ = try await libraryManager.importNovel(from: url)
                } catch {
                    libraryManager.errorMessage = error.localizedDescription
                }
            }
        }
        .sheet(item: $selectedNovel) { novel in
            ReadingView(novel: novel)
        }
    }
}

// MARK: - 空书库视图

struct EmptyLibraryView: View {
    @Binding var showingImporter: Bool

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "books.vertical")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("书架空空如也")
                .font(.title2)
                .foregroundColor(.secondary)

            Text("从 iCloud 或本地导入小说文件")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Button(action: { showingImporter = true }) {
                Label("导入小说", systemImage: "square.and.arrow.down")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

// MARK: - 书库列表视图

struct LibraryListView: View {
    @EnvironmentObject var libraryManager: LibraryManager
    @Binding var selectedNovel: Novel?
    @State private var deleteCandidate: Novel?

    var body: some View {
        List {
            ForEach(libraryManager.novels.sorted(by: { $0.lastReadDate > $1.lastReadDate })) { novel in
                NovelRowView(novel: novel)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedNovel = novel
                    }
                    .contextMenu {
                        Button(action: { deleteCandidate = novel }) {
                            Label("删除", systemImage: "trash")
                        }
                    }
            }
            .onMove { source, destination in
                libraryManager.novels.move(fromOffsets: source, toOffset: destination)
            }
        }
        .listStyle(.insetGrouped)
        .alert("确认删除", isPresented: .constant(deleteCandidate != nil), presenting: deleteCandidate) { novel in
            Button("取消", role: .cancel) {
                deleteCandidate = nil
            }
            Button("删除", role: .destructive) {
                libraryManager.deleteNovel(novel)
                deleteCandidate = nil
            }
        } message: { novel in
            Text("确定要删除《\(novel.title)》吗？")
        }
    }
}

// MARK: - 小说行视图

struct NovelRowView: View {
    let novel: Novel

    var body: some View {
        HStack(spacing: 15) {
            // 封面
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(coverColor)
                    .frame(width: 50, height: 70)

                Image(systemName: "book.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(novel.title)
                    .font(.headline)
                    .lineLimit(1)

                Text(novel.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack {
                    Text("\(Int(novel.currentProgress * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    Text(formattedDate(novel.lastReadDate))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // 进度条
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 3)

                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: geometry.size.width * novel.currentProgress, height: 3)
                    }
                }
                .frame(height: 3)
            }
        }
        .padding(.vertical, 4)
    }

    private var coverColor: Color {
        switch novel.coverColor {
        case "blue": return Color.blue
        case "green": return Color.green
        case "orange": return Color.orange
        case "pink": return Color.pink
        case "purple": return Color.purple
        case "red": return Color.red
        case "teal": return Color.teal
        default: return Color.blue
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
        .environmentObject(LibraryManager())
        .environmentObject(SettingsManager())
}
