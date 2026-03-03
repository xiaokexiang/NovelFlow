//
//  Settings.swift
//  NovelReader
//
//  阅读设置数据模型
//

import Foundation
import SwiftUI

struct ReadingSettings: Codable {
    var fontSize: CGFloat
    var lineHeight: CGFloat
    var theme: AppTheme
    var fontFamily: FontFamily
    var isAutoScroll: Bool
    var scrollSpeed: Double
    var pageTurningAnimation: PageTurningStyle

    static let `default` = ReadingSettings(
        fontSize: 18,
        lineHeight: 1.6,
        theme: .light,
        fontFamily: .system,
        isAutoScroll: false,
        scrollSpeed: 2.0,
        pageTurningAnimation: .slide
    )
}

enum AppTheme: String, Codable, CaseIterable {
    case light = "light"
    case dark = "dark"
    case sepia = "sepia"
    case eyeProtection = "eyeProtection"

    var backgroundColor: Color {
        switch self {
        case .light: return Color.white
        case .dark: return Color.black
        case .sepia: return Color(red: 0.96, green: 0.92, blue: 0.84)
        case .eyeProtection: return Color(red: 0.76, green: 0.85, blue: 0.73)
        }
    }

    var textColor: Color {
        switch self {
        case .light: return Color.black
        case .dark: return Color.white
        case .sepia: return Color(red: 0.39, green: 0.34, blue: 0.23)
        case .eyeProtection: return Color(red: 0.2, green: 0.2, blue: 0.2)
        }
    }
}

enum FontFamily: String, Codable, CaseIterable {
    case system = "system"
    case pingfang = "PingFang SC"
    case songti = "Songti SC"
    case kaiti = "Kaiti SC"

    var displayName: String {
        switch self {
        case .system: return "系统字体"
        case .pingfang: return "苹方"
        case .songti: return "宋体"
        case .kaiti: return "楷体"
        }
    }
}

enum PageTurningStyle: String, Codable, CaseIterable {
    case slide = "slide"
    case fade = "fade"
    case none = "none"

    var displayName: String {
        switch self {
        case .slide: return "滑动"
        case .fade: return "淡入淡出"
        case .none: return "无动画"
        }
    }
}
