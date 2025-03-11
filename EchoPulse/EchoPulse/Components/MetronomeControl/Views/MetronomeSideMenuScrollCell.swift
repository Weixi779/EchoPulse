//
//  MetronomeSideMenuScrollCell.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/10.
//

import SwiftUI

struct MetronomeSideMenuScrollCell: View {
    let sourceType: MetronomeSourceType
    let selectingType: MetronomeSourceType
    

    private let font: Font = .system(.largeTitle, design: .rounded, weight: .bold)
    private let strokeWidth: CGFloat = 1.5

    init(sourceType: MetronomeSourceType, selectingType: MetronomeSourceType) {
        self.sourceType = sourceType
        self.selectingType = selectingType
    }
    
    var text: String {
        self.sourceType.fileName
    }
    
    var isSelected: Bool {
        self.sourceType == self.selectingType
    }
    
    var body: some View {
        ZStack {
            // 利用四个方向的偏移创建描边效果
            ForEach(strokes, id: \.self) { offset in
                Text(text)
                    .font(font)
                    .foregroundColor(.clear)
                    .overlay(
                        Color.gray.mask(Text(text).font(font))
                    )
                    .offset(offset)
            }
            Text(text)
                .font(font)
                .foregroundColor(isSelected ? .yellow : .primary)
        }
        .opacity(isSelected ? 1 : 0.7)
        .scaleEffect(isSelected ? 1.2 : 0.8)
        .rotationEffect(.degrees(rotationDegrees), anchor: .bottomTrailing)
        .animation(.easeInOut, value: isSelected)
    }
    
    var rotationDegrees: Double {
        Double(sourceType.compare(to: selectingType) * -7)
    }
    
    var strokes: [CGSize] {
        [CGSize(width: strokeWidth, height: strokeWidth),
         CGSize(width: -strokeWidth, height: -strokeWidth),
         CGSize(width: strokeWidth, height: -strokeWidth),
         CGSize(width: -strokeWidth, height: strokeWidth)]
    }
}

#Preview {
    MetronomeSideMenuScrollCell(sourceType: .bassDrum, selectingType: .bassDrum)
}
