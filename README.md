# NovelReader - iOS 小说阅读器

一个简洁优雅的 iOS 小说阅读器应用，使用 SwiftUI 构建。

## 功能特性

### 📖 阅读功能
- 支持 TXT 格式小说文件
- 自动章节分割和识别
- 阅读进度自动保存
- 快速章节跳转

### 🎨 个性化设置
- **字体大小**: 12pt - 40pt 可调
- **行间距**: 1.0 - 2.5 可调
- **主题模式**: 浅色/深色/护眼/绿色
- **字体选择**: 系统/苹方/宋体/楷体

### 🔖 书签功能
- 添加和管理书签
- 书签备注功能
- 快速跳转到书签位置

### ☁️ iCloud 集成
- 从 iCloud 云盘加载小说文件
- 书架数据 iCloud 同步
- 支持文件 App 导入

### 📚 书架管理
- 封面颜色自动生成
- 阅读进度显示
- 最近阅读时间排序
- 删除管理

## 项目结构

```
NovelReader/
├── NovelReaderApp.swift      # 应用入口
├── Models/
│   ├── Novel.swift           # 小说数据模型
│   └── Settings.swift        # 设置数据模型
├── Managers/
│   ├── LibraryManager.swift  # 书库管理器
│   └── SettingsManager.swift # 设置管理器
├── Views/
│   ├── ContentView.swift     # 主界面 (书架)
│   ├── ReadingView.swift     # 阅读界面
│   └── SettingsView.swift    # 设置界面
└── NovelReader/
    ├── Info.plist            # 应用配置
    └── NovelReader.entitlements # iCloud 权限
```

## 系统要求

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## 在 Linux 上开发

由于 iOS 应用需要 macOS 环境编译，在 Linux 上可以采用以下开发方式：

### 方案一：在线开发环境 (推荐)

1. **GitHub Codespaces**
   - 创建 GitHub 仓库
   - 启用 Codespaces
   - 使用浏览器开发

2. **MacinCloud / MacStadium**
   - 租用云端 Mac
   - 远程桌面连接
   - 完整 Xcode 环境

### 方案二：代码编辑 + 本地编译

1. 在 Linux 上使用 VS Code 编辑 Swift 源代码
2. 代码完成后，传输到 Mac 设备
3. 使用 Xcode 编译和测试

### 方案三：Docker (有限支持)

```bash
# 可以验证 Swift 语法，但无法运行 iOS 模拟器
docker run --rm -v "$(pwd)":/src swift:5.9 swift build
```

## 编译和运行

1. 在 Mac 上打开项目：
   ```bash
   open NovelReader/NovelReader.xcodeproj
   ```

2. 在 Xcode 中：
   - 选择目标设备 (iPhone/iPad Simulator)
   - 点击 ▶️ 运行 或按 `Cmd + R`

## iCloud 配置

1. 在 Xcode 中打开项目
2. 选择 Target → Signing & Capabilities
3. 添加 "iCloud" 能力
4. 勾选 "Cloud Documents"
5. 设置 Container ID (如：iCloud.com.yourcompany.novelreader)

## 使用指南

### 导入小说
1. 打开应用，点击 "+" 按钮
2. 从 iCloud 云盘或文件 App 选择 TXT 文件
3. 小说自动添加到书架

### 阅读小说
1. 在书架点击小说封面
2. 进入阅读界面
3. 点击屏幕显示/隐藏工具栏
4. 使用顶部工具栏调整设置

### 添加书签
1. 阅读时点击书签图标
2. 点击 "+" 添加当前页面为书签
3. 可添加备注信息

## 技术栈

- **UI 框架**: SwiftUI
- **数据存储**: UserDefaults + iCloud
- **架构模式**: MVVM
- **最低版本**: iOS 16.0

## 后续计划

- [ ] EPUB 格式支持
- [ ] 在线书源导入
- [ ] 朗读功能 (TTS)
- [ ] 阅读统计
- [ ] Wi-Fi 传书

## License

MIT License
