//
//  NovelReaderApp.swift
//  NovelReader
//
//  小说阅读器 - 简洁优雅的 iOS 阅读应用
//

import SwiftUI

@main
struct NovelReaderApp: App {
    @StateObject private var libraryManager = LibraryManager()
    @StateObject private var settingsManager = SettingsManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(libraryManager)
                .environmentObject(settingsManager)
        }
    }
}
