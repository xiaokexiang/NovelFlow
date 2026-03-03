//
//  LibraryManager.swift
//  NovelReader
//
//  书库管理器 - 管理本地和 iCloud 中的小说文件
//

import Foundation
import Combine
import SwiftUI

class LibraryManager: ObservableObject {
    @Published var novels: [Novel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let saveKey = "LibraryManager.novels"

    init() {
        loadNovels()
        setupiCloudSync()
    }

    // MARK: - iCloud 配置

    private func setupiCloudSync() {
        // 监听 iCloud 通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(iCloudDidUpdate),
            name: NSUbiquityKeyValueDidChangeNotification,
            object: nil
        )
    }

    @objc private func iCloudDidUpdate() {
        DispatchQueue.main.async {
            self.syncFromiCloud()
        }
    }

    // MARK: - 文件操作

    func importNovel(from url: URL) async throws -> Novel {
        isLoading = true
        defer { isLoading = false }

        // 获取 iCloud 文档目录
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)

        // 复制文件到应用目录
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }
        try FileManager.default.copyItem(at: url, to: destinationURL)

        // 解析小说信息
        let novel = try await parseNovel(from: destinationURL)

        // 添加到书库
        novels.append(novel)
        saveNovels()
        syncToiCloud()

        return novel
    }

    func deleteNovel(_ novel: Novel) {
        novels.removeAll { $0.id == novel.id }
        saveNovels()
        syncToiCloud()

        // 删除文件
        try? FileManager.default.removeItem(at: novel.filePath)
    }

    func updateNovelProgress(novelId: UUID, chapterIndex: Int, progress: Double) {
        guard let index = novels.firstIndex(where: { $0.id == novelId }) else { return }
        novels[index].currentChapterIndex = chapterIndex
        novels[index].currentProgress = progress
        novels[index].lastReadDate = Date()
        saveNovels()
        syncToiCloud()
    }

    func addBookmark(novelId: UUID, bookmark: Bookmark) {
        guard let index = novels.firstIndex(where: { $0.id == novelId }) else { return }
        novels[index].bookmarks.append(bookmark)
        saveNovels()
        syncToiCloud()
    }

    func removeBookmark(novelId: UUID, bookmarkId: UUID) {
        guard let index = novels.firstIndex(where: { $0.id == novelId }) else { return }
        novels[index].bookmarks.removeAll { $0.id == bookmarkId }
        saveNovels()
        syncToiCloud()
    }

    // MARK: - 持久化

    private func loadNovels() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Novel].self, from: data) {
            novels = decoded
        } else if UserDefaults.standard.array(forKey: saveKey) == nil {
            // 首次加载 iCloud
            syncFromiCloud()
        }
    }

    private func saveNovels() {
        if let encoded = try? JSONEncoder().encode(novels) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    // MARK: - iCloud 同步

    private func syncToiCloud() {
        guard let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil) else { return }

        let libraryFile = containerURL.appendingPathComponent("Documents/library.json")

        // 确保目录存在
        try? FileManager.default.createDirectory(at: libraryFile.deletingLastPathComponent(),
                                                  withIntermediateDirectories: true)

        if let encoded = try? JSONEncoder().encode(novels) {
            try? encoded.write(to: libraryFile)
        }
    }

    private func syncFromiCloud() {
        guard let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil) else { return }

        let libraryFile = containerURL.appendingPathComponent("Documents/library.json")

        if FileManager.default.fileExists(atPath: libraryFile.path),
           let data = try? Data(contentsOf: libraryFile),
           let decoded = try? JSONDecoder().decode([Novel].self, from: data) {
            novels = decoded
        }
    }

    // MARK: - 文件解析

    private func parseNovel(from url: URL) async throws -> Novel {
        let content = try String(contentsOf: url, encoding: .utf8)

        // 简单的 TXT 解析逻辑
        var title = url.deletingPathExtension().lastPathComponent
        var author = "未知作者"
        var chapters: [String] = []

        // 尝试从内容中提取标题和章节
        let lines = content.components(separatedBy: .newlines)

        // 查找标题（通常是第一行非空行）
        for line in lines.prefix(10) {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if !trimmed.isEmpty {
                title = trimmed
                break
            }
        }

        // 简单章节分割：空行或包含"第 X 章"的行
        var currentChapter = ""
        var chapterStart = false

        for line in lines {
            if line.contains("第") && line.contains("章") {
                if !currentChapter.isEmpty {
                    chapters.append(currentChapter)
                }
                currentChapter = line + "\n"
                chapterStart = true
            } else if chapterStart || !line.trimmingCharacters(in: .whitespaces).isEmpty {
                currentChapter += line + "\n"
            }
        }

        if !currentChapter.isEmpty {
            chapters.append(currentChapter)
        }

        // 如果没有检测到章节，按文件大小分割
        if chapters.isEmpty {
            let chunkSize = 5000
            let chars = Array(content)
            for i in stride(from: 0, to: chars.count, by: chunkSize) {
                let end = min(i + chunkSize, chars.count)
                chapters.append(String(chars[i..<end]))
            }
        }

        // 生成封面颜色
        let colors = ["blue", "green", "orange", "pink", "purple", "red", "teal"]
        let randomColor = colors[Int.random(in: 0..<colors.count)]

        return Novel(
            title: title,
            author: author,
            coverColor: randomColor,
            filePath: url,
            currentChapterIndex: 0,
            currentProgress: 0,
            bookmarks: []
        )
    }
}
