//
//  SettingsView.swift
//  NovelReader
//
//  应用设置界面
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section("关于") {
                    HStack {
                        Image(systemName: "books.vertical")
                            .font(.title2)
                            .foregroundColor(.blue)

                        VStack(alignment: .leading) {
                            Text("NovelReader")
                                .font(.headline)
                            Text("简洁优雅的 iOS 小说阅读器")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section("阅读") {
                    NavigationLink(destination: ReadingSettingsView()) {
                        Label("阅读设置", systemImage: "textformat.size")
                    }
                }

                Section("数据") {
                    Button(action: resetLibrary) {
                        Label("清空书架", systemImage: "trash")
                    }
                    .foregroundColor(.red)
                }

                Section("版本") {
                    Text("1.0.0")
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func resetLibrary() {
        UserDefaults.standard.removeObject(forKey: "LibraryManager.novels")
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsManager())
}
