//
//  Project.swift
//  NovelReader
//
//  Swift Package Manager 项目配置
//
//  注意：这是 iOS 项目，主要使用 Xcode 编译。
//  此文件用于 Swift 包管理参考。
//
//  编译方式：
//  1. 在 Mac 上使用 Xcode 打开 NovelReader.xcodeproj
//  2. 选择目标设备 (iPhone/iPad)
//  3. 点击运行或 Cmd+B 编译
//
//  在 Linux 上开发:
//  1. 使用 VS Code 编辑 Swift 源文件
//  2. 使用 GitHub Codespaces (配置 macOS 环境)
//  3. 代码完成后在 Mac 上编译测试
//

import PackageDescription

let package = Package(
    name: "NovelReader",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "NovelReader",
            targets: ["NovelReader"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NovelReader",
            dependencies: [],
            path: "NovelReader"
        )
    ]
)
