//
//  Novel.swift
//  NovelReader
//
//  小说数据模型
//

import Foundation

struct Novel: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var author: String
    var coverColor: String
    var filePath: URL
    var lastReadDate: Date
    var currentChapterIndex: Int
    var currentProgress: Double
    var bookmarks: [Bookmark]

    init(id: UUID = UUID(), title: String, author: String = "未知作者",
         coverColor: String = "blue", filePath: URL,
         lastReadDate: Date = Date(), currentChapterIndex: Int = 0,
         currentProgress: Double = 0, bookmarks: [Bookmark] = []) {
        self.id = id
        self.title = title
        self.author = author
        self.coverColor = coverColor
        self.filePath = filePath
        self.lastReadDate = lastReadDate
        self.currentChapterIndex = currentChapterIndex
        self.currentProgress = currentProgress
        self.bookmarks = bookmarks
    }
}

struct Bookmark: Identifiable, Codable, Equatable {
    let id: UUID
    var chapterIndex: Int
    var position: Int
    var note: String
    var createdAt: Date

    init(id: UUID = UUID(), chapterIndex: Int, position: Int = 0,
         note: String = "", createdAt: Date = Date()) {
        self.id = id
        self.chapterIndex = chapterIndex
        self.position = position
        self.note = note
        self.createdAt = createdAt
    }
}
