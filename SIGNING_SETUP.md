# iOS 代码签名配置指南

## 概述

本 workflow 支持两种打包模式：

1. **自动签名模式**（默认）- 无需配置，生成未签名的 IPA
2. **手动签名模式** - 配置证书后，生成可安装的已签名 IPA

## 配置步骤

### 方式一：自动签名（无需配置）

如果你没有 Apple Developer 账号或仅用于测试，workflow 会自动使用未签名模式打包。

**输出**: 未签名的 IPA，仅用于测试，无法在真机安装

### 方式二：手动签名（需要 Apple Developer 账号）

#### 步骤 1: 准备证书和描述文件

1. **导出证书为 P12 格式**
   - 打开「钥匙串访问」
   - 找到你的发布证书（Apple Distribution 或 iPhone Distribution）
   - 右键 → 导出，选择 `.p12` 格式
   - 设置密码

2. **获取描述文件**
   - 登录 [Apple Developer](https://developer.apple.com)
   - 创建 Ad Hoc 或 App Store 描述文件
   - 下载 `.mobileprovision` 文件

#### 步骤 2: Base64 编码

在终端执行以下命令：

```bash
# 编码证书
base64 -i certificate.p12 -o certificate.txt

# 编码描述文件
base64 -i profile.mobileprovision -o profile.txt
```

#### 步骤 3: 配置 GitHub Secrets

进入 GitHub 仓库 → Settings → Secrets and variables → Actions，添加以下 secrets：

| Secret 名称 | 说明 | 示例值 |
|------------|------|--------|
| `APPLE_CERTIFICATE_P12` | P12 证书内容（base64 编码） | MIIG...（certificate.txt 内容） |
| `APPLE_CERTIFICATE_PASSWORD` | P12 证书密码 | your_password |
| `APPLE_ID` | Apple ID 账号 | your@email.com |
| `APPLE_TEAM_ID` | 团队 ID | XXXXXXXXXX |
| `CODE_SIGN_IDENTITY_NAME` | 证书名称 | Apple Distribution |
| `PROVISIONING_PROFILE_NAME` | 描述文件名称（UUID） | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx |
| `PROVISIONING_PROFILE` | 描述文件内容（base64 编码） | MIIG...（profile.txt 内容） |

#### 步骤 4: 更新 Bundle ID

编辑 `NovelReader.xcodeproj/project.pbxproj`，将：
```
PRODUCT_BUNDLE_IDENTIFIER = "com.yourcompany.novelreader";
```
改为你的实际 Bundle ID，并在导出配置中同步更新。

## 发布流程

1. 创建 Release：
   - 进入 Releases → Draft a new release
   - 输入版本号（如 v1.0.0）
   - 点击 Publish

2. 自动触发：
   - workflow 会自动检测是否配置了签名证书
   - 已配置 → 使用签名模式打包
   - 未配置 → 使用未签名模式打包

3. 下载 IPA：
   - 打包完成后，IPA 文件会自动附加到 Release
   - 在 Release 页面下载即可

## 安装方式

### 已签名的 IPA

- **Ad Hoc** - 需要 UDID 注册，可直接安装
- **App Store** - 需通过 TestFlight 或 App Store

### 未签名的 IPA

无法在真机安装，仅用于：
- 模拟器测试
- 进一步处理（如使用其他工具签名）

## 故障排除

### 构建失败

查看 Actions 日志，常见问题：
- 证书过期 → 重新生成证书
- 描述文件不匹配 → 确认 Bundle ID 一致
- 团队 ID 错误 → 在 Apple Developer 后台确认

### 证书相关错误

```
error: No signing certificate found
```
检查 `APPLE_CERTIFICATE_P12` 和 `APPLE_CERTIFICATE_PASSWORD` 是否正确

### 描述文件相关错误

```
error: No provisioning profiles found
```
检查 `PROVISIONING_PROFILE_NAME` 是否与描述文件 UUID 一致

## 其他工具

推荐使用以下工具简化流程：

- [gym](https://docs.fastlane.tools/actions/gym/) - Fastlane 打包工具
- [match](https://docs.fastlane.tools/actions/match/) - 证书管理工具
- [codemagic-cli-tools](https://github.com/codemagic-ci-cd/codemagic-cli-tools) - CI/CD 工具

## 链接

- [GitHub Actions for iOS](https://docs.github.com/en/actions/guides/building-and-testing-xcode)
- [Apple 证书管理](https://help.apple.com/xcode/mac/current/#/dev1548da2695)
- [Fastlane](https://fastlane.tools/)
