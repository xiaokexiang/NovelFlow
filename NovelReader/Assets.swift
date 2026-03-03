//
//  Assets.swift
//  NovelReader
//
//  资源文件入口
//

import SwiftUI

// MARK: - 颜色资源

extension Color {
    // 主题色
    static let novelPrimary = Color.blue
    static let novelSecondary = Color.gray

    // 背景色
    static let novelBackground = Color(white: 0.98)
    static let novelCard = Color.white

    // 夜间模式
    static let novelDarkBackground = Color.black
    static let novelDarkCard = Color(white: 0.15)

    // 护眼模式
    static let novelSepia = Color(red: 0.96, green: 0.92, blue: 0.84)
    static let novelEyeProtection = Color(red: 0.76, green: 0.85, blue: 0.73)
}

// MARK: - 图片资源

extension Image {
    static let bookPlaceholder = Image(systemName: "book.fill")
    static let iCloudSymbol = Image(systemName: "icloud")
    static let settingSymbol = Image(systemName: "gear")
}
