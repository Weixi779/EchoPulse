//
//  Font++.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/21.
//

import Foundation
import UIKit
import SwiftUI

extension Font {
    func toUIFontDescriptor() -> UIFontDescriptor? {
        // 这是一个简易转换实现
        // 注意：实际项目中应该根据具体的Font类型进行更全面的转换
        
        let systemFont: UIFont
        
        // 简单处理一些常见的font cases
        switch self {
        case .largeTitle:
            systemFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title:
            systemFont = UIFont.preferredFont(forTextStyle: .title1)
        case .headline:
            systemFont = UIFont.preferredFont(forTextStyle: .headline)
        case .body:
            systemFont = UIFont.preferredFont(forTextStyle: .body)
        case .callout:
            systemFont = UIFont.preferredFont(forTextStyle: .callout)
        case .caption:
            systemFont = UIFont.preferredFont(forTextStyle: .caption1)
        default:
            // 对于系统字体(尤其是rounded设计的粗体)的支持
            systemFont = UIFont.systemFont(ofSize: 34, weight: .bold)
            
            // 尝试使用.rounded设计
            let fontDescriptor = systemFont.fontDescriptor
            if let roundedDescriptor = fontDescriptor.withDesign(.rounded) {
                return roundedDescriptor
            }
        }
        
        return systemFont.fontDescriptor
    }
}
