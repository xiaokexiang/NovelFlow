# iOS 小说阅读器开发指南

## 项目概览

这是一个使用 SwiftUI 构建的 iOS 小说阅读器应用，支持：
- 📖 TXT 文件阅读
- ☁️ iCloud 文件加载
- 🎨 多主题切换
- 🔖 书签功能
- 📚 书架管理

## 在 Linux 上开发

### 当前限制

由于 iOS 应用需要 macOS 环境和 Xcode 才能编译运行，在 Linux 上你无法：
- 编译 iOS 应用
- 运行 iOS 模拟器
- 签名和部署到设备

### 推荐工作流程

#### 方案 1: 代码编辑 + Mac 编译（推荐）

1. **在 Linux 上编辑代码**
   - 使用 VS Code 或其他编辑器
   - 本项目的 Swift 源文件位于 `NovelReader/` 目录
   - 可以利用 Swift 的语法检查功能

2. **传输到 Mac 编译**
   ```bash
   # 使用 scp 或 rsync 传输
   rsync -avz NovelReader/ user@mac:/path/to/NovelReader/
   ```

3. **在 Mac 上打开 Xcode 编译**
   ```bash
   open NovelReader/NovelReader.xcodeproj
   ```

#### 方案 2: GitHub Codespaces

1. 将代码推送到 GitHub 仓库
2. 创建 Codespace
3. 虽然 Codespaces 也是 Linux 环境，但可以：
   - 使用 VS Code Web 界面
   - 进行代码审查和编辑
   - 配合远程 Mac 进行编译

#### 方案 3: 云端 Mac 服务

- **MacinCloud**: https://www.macincloud.com/
- **MacStadium**: https://www.macstadium.com/
- 租用云端 Mac，远程桌面连接使用完整 Xcode

## 项目文件说明

```
NovelReader/
├── NovelReaderApp.swift          # 应用入口
├── Models/                       # 数据模型
│   ├── Novel.swift               # 小说模型
│   └── Settings.swift            # 设置模型
├── Managers/                     # 业务逻辑
│   ├── LibraryManager.swift      # 书库管理
│   └── SettingsManager.swift     # 设置管理
├── Views/                        # UI 界面
│   ├── ContentView.swift         # 主界面
│   ├── ReadingView.swift         # 阅读界面
│   └── SettingsView.swift        # 设置界面
├── NovelReader/                  # Xcode 资源
│   ├── Assets.xcassets/          # 图片资源
│   ├── Base.lproj/               # 启动屏
│   ├── Info.plist                # 应用配置
│   └── NovelReader.entitlements  # iCloud 权限
├── NovelReader.xcodeproj/        # Xcode 项目
│   └── project.pbxproj
├── Package.swift                 # Swift 包配置
└── README.md                     # 项目说明
```

## 在 Mac 上编译运行

### 系统要求

- macOS 13.0+
- Xcode 15.0+
- iOS 16.0+ SDK

### 编译步骤

1. **打开项目**
   ```bash
   cd /opt/data/projects/go/ios/NovelReader
   open NovelReader.xcodeproj
   ```

2. **配置开发团队**
   - 在 Xcode 中选择 Target → NovelReader
   - 在 "Signing & Capabilities" 中选择你的开发团队
   - 如果没有，添加 Apple ID 自动创建

3. **配置 iCloud**
   - 在 "Signing & Capabilities" 中添加 "iCloud"
   - 勾选 "Cloud Documents"
   - 设置 Container ID: `iCloud.com.yourcompany.novelreader`
   - 注意：需要修改 `NovelReader.entitlements` 中的 ID

4. **编译运行**
   - 选择模拟器或真机
   - 按 `Cmd + R` 运行

## 代码自定义

### 修改应用名称

编辑 `NovelReader/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>你的应用名称</string>
```

### 修改 iCloud Container

编辑 `NovelReader/NovelReader.entitlements`:
```xml
<key>com.apple.developer.icloud-container-identifiers</key>
<array>
    <string>iCloud.com.yourcompany.你的应用名</string>
</array>
```

然后在 `LibraryManager.swift` 中更新：
```swift
let containerURL = FileManager.default.url(
    forUbiquityContainerIdentifier: "iCloud.com.yourcompany.你的应用名"
)
```

### 自定义主题颜色

编辑 `Models/Settings.swift` 中的 `AppTheme` 枚举。

### 修改章节分割逻辑

编辑 `LibraryManager.swift` 中的 `parseNovel` 方法。

## 下一步开发建议

### 功能增强

1. **EPUB 支持**
   - 添加 EPUB 解析库
   - 实现章节导航

2. **阅读体验**
   - 添加翻页动画
   - 实现自动滚动
   - 添加 TTS 朗读

3. **数据同步**
   - 完善 iCloud 同步机制
   - 添加冲突处理

4. **UI 优化**
   - 添加更多主题
   - 实现自定义封面
   - 添加动画效果

### 发布准备

1. 准备应用图标 (1024x1024)
2. 准备应用截图
3. 编写应用描述
4. 在 App Store Connect 创建应用
5. 提交审核

## 常见问题

### Q: 为什么在 Linux 上无法编译 iOS 应用？
A: iOS 应用需要 Apple 的专有工具链 (Swift Compiler for iOS, iOS SDK)，这些只随 Xcode 提供，而 Xcode 只能在 macOS 上运行。

### Q: 能否使用 Cross-Compilation？
A: 理论上可以，但需要 macOS 的 SDK 和签名工具，实际上还是需要 Mac 环境。

### Q: SwiftUI 代码能在 Linux 上测试吗？
A: 不能直接运行 UI，但可以：
- 编写单元测试 (使用 XCTest)
- 测试数据模型和业务逻辑
- 使用 Swift Package Manager 编译非 UI 代码

## 资源链接

- [SwiftUI 官方文档](https://developer.apple.com/documentation/swiftui)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [iCloud Cloud Kit 文档](https://developer.apple.com/documentation/cloudkit)
- [Swift.org](https://swift.org/)
