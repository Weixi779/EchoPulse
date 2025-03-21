//
//  MetronomeSoundSelectionView.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/21.
//

import SwiftUI

struct MetronomeSoundSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.schemeStyle) var schemeStyle
    
    var dataSource: SourceTypeDataSource
    
    private let sources = MetronomeSourceType.allCases
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 列表视图
                List {
                    Section(header: Text("节拍器音效").textCase(.uppercase)) {
                        ForEach(MetronomeSourceType.allCases) { source in
                            SoundOptionRow(
                                source: source,
                                isSelected: dataSource.value == source,
                                onSelect: {
                                    dataSource.applyValue(source)
                                    dataSource.commitValue()
                                }
                            )
                        }
                    }
                    
                    // 简单的帮助文本
                    Section(footer: Text("选择不同的声音会改变节拍器的音色。每种音效都有各自的特点和适用场景。").font(.footnote).foregroundColor(.secondary)) {
                        EmptyView()
                    }
                }
                .listStyle(.insetGrouped)
            }
            .padding(.top)
        }
    }
}

// 声音选项数据模型
struct SoundOption: Identifiable {
    let id: String
    let name: String
    let icon: String
}

// 声音选项行视图
struct SoundOptionRow: View {
    let source: MetronomeSourceType
    let isSelected: Bool
    let onSelect: () -> Void
    
    // 从颜色到字体的各种属性
    private var accentColor: Color {
        isSelected ? .accentColor : .primary
    }
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                Circle()
                    .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.secondary.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: source.systemIconName)
                            .font(.system(size: 18, weight: isSelected ? .semibold : .regular))
                            .foregroundColor(accentColor)
                    }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(source.fileName)
                        .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(.primary)
                    
                    Text(source.description)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 18, weight: .semibold))
                }
            }
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
