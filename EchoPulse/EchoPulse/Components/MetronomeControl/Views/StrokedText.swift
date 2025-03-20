//
//  StrokedText.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/21.
//

import Foundation
import SwiftUI

struct StrokedText: UIViewRepresentable {
    let text: String
    let font: Font
    let textColor: Color
    let strokeColor: Color
    let strokeWidth: CGFloat
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        // 将SwiftUI的Font转换为UIFont
        let uiFont: UIFont
        
        // 对于当前特定需求，直接使用圆角粗体大标题
        if let descriptor = UIFont.systemFont(ofSize: 34, weight: .bold).fontDescriptor.withDesign(.rounded) {
            uiFont = UIFont(descriptor: descriptor, size: descriptor.pointSize)
        } else if let descriptor = font.toUIFontDescriptor() {
            uiFont = UIFont(descriptor: descriptor, size: descriptor.pointSize)
        } else {
            // 默认使用系统大标题字体
            uiFont = UIFont.systemFont(ofSize: 34, weight: .bold)
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: uiFont,
            .foregroundColor: UIColor(textColor),
            .strokeColor: UIColor(strokeColor),
            .strokeWidth: -strokeWidth
        ]
        
        uiView.attributedText = NSAttributedString(string: text, attributes: attributes)
        uiView.textAlignment = .center
        
        uiView.sizeToFit()
    }
}
