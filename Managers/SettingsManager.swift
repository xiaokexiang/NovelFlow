//
//  SettingsManager.swift
//  NovelReader
//
//  设置管理器 - 管理阅读偏好设置
//

import Foundation
import Combine

class SettingsManager: ObservableObject {
    @Published var settings: ReadingSettings {
        didSet {
            saveSettings()
        }
    }

    private let saveKey = "SettingsManager.readingSettings"

    init() {
        // 加载保存的设置
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode(ReadingSettings.self, from: data) {
            settings = decoded
        } else {
            settings = .default
        }
    }

    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    // MARK: - 快捷方法

    func increaseFontSize() {
        settings.fontSize = min(settings.fontSize + 2, 40)
    }

    func decreaseFontSize() {
        settings.fontSize = max(settings.fontSize - 2, 12)
    }

    func toggleTheme() {
        let currentIndex = AppTheme.allCases.firstIndex(of: settings.theme) ?? 0
        let nextIndex = (currentIndex + 1) % AppTheme.allCases.count
        settings.theme = AppTheme.allCases[nextIndex]
    }

    func resetSettings() {
        settings = .default
    }
}
