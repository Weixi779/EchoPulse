//
//  MetronomeSideMenuScrollCell.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/10.
//

import SwiftUI

struct MetronomeSideMenuScrollCell: View {
    let sourceType: MetronomeSourceType
    @Binding var selectingType: MetronomeSourceType
    
    private static let font: Font = .system(.largeTitle, design: .rounded, weight: .bold)
    private static let strokeWidth: CGFloat = 1.5
    
    private var text: String {
        sourceType.fileName
    }
    
    private var isSelected: Bool {
        sourceType == selectingType
    }
    
    // 记忆化处理常用计算，避免重复计算
    private var indexDifference: Int {
        sourceType.indexDifference(to: selectingType)
    }
    
    private var rotationDegrees: Double {
        Double(indexDifference * -7)
    }
    
    private var offsetValue: Double {
        Double(abs(indexDifference) * 15)
    }
    
    var body: some View {
        StrokedText(
            text: text,
            font: Self.font,
            textColor: isSelected ? .yellow : .white,
            strokeColor: .gray,
            strokeWidth: 3.0
        )
        .opacity(isSelected ? 1 : 0.7)
        .animation(.easeInOut(duration: 0.25).delay(0.05), value: isSelected)
        .scaleEffect(isSelected ? 1.2 : 0.8)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
        .offset(x: offsetValue)
        .rotationEffect(.degrees(rotationDegrees), anchor: .bottomTrailing)
        .animation(.easeInOut(duration: 0.35).delay(0.05), value: isSelected)
    }
    
    // 使用AttributedString实现描边效果
    private var attributedText: AttributedString {
        var attributedString = AttributedString(text)
        
        // 设置文本属性
        attributedString.font = Self.font
        attributedString.foregroundColor = isSelected ? .yellow : .white
        
        // 添加描边效果
        attributedString.strokeColor = .gray
        attributedString.strokeWidth = -3.0 // 负值表示同时描边和填充
        
        return attributedString
    }
}
