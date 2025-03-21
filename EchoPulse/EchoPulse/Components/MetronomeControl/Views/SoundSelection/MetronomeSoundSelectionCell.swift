//
//  MetronomeSoundSelectionCell.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/21.
//

import SwiftUI

struct MetronomeSoundSelectionCell: View {
    let source: MetronomeSourceType
    let isSelected: Bool
    let height: CGFloat
    let onSelect: () -> Void
    
    private var accentColor: Color {
        isSelected ? .accentColor : .primary
    }
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                // 图标部分
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.secondary.opacity(0.08))
                        .frame(width: height * 0.7, height: height * 0.7)
                    
                    Image(systemName: source.systemIconName)
                        .font(.system(size: height * 0.3))
                        .foregroundColor(isSelected ? .accentColor : .secondary)
                }
                .padding(.leading, 8)
                
                // 文字部分
                VStack(alignment: .leading, spacing: 4) {
                    Text(source.fileName)
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(isSelected ? .semibold : .regular)
                        .foregroundColor(.primary)
                    
                    Text(source.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 选中指示器
                Group {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: height * 0.3))
                            .foregroundColor(.accentColor)
                    } else {
                        Circle()
                            .strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1.5)
                            .frame(width: height * 0.3, height: height * 0.3)
                    }
                }
                .padding(.trailing, 16)
            }
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(isSelected ? Color.accentColor.opacity(0.08) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 0) {
        MetronomeSoundSelectionCell(source: .bassDrum, isSelected: false, height: 44) {
            
            
        }
        MetronomeSoundSelectionCell(source: .cowbell, isSelected: true, height: 44) {
            
            
        }
    }
    
}
