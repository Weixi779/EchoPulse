//
//  ColorConfigs.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/10.
//

import Foundation
import SwiftUI

struct ColorConfigs {
    
    static let lightColors: [Color] = [
        .init(hex: "F8E4DB"),
        .init(hex: "FCD6B3"),
        .init(hex: "95C5D4"),
        .init(hex: "B7DAE4"),
        .init(hex: "D3E6EC"),
        .init(hex: "E6ECF2")
    ]
    
    static let darkColors: [Color] = [
        .init(hex: "3B4F52"),
        .init(hex: "5C786E"),
        .init(hex: "738E57"),
        .init(hex: "577146"),
        .init(hex: "3B4E3F"),
        .init(hex: "553F33")
    ]
    
    static let x56C596: Color = .init(hex: "56C596")
    static let x7BE495: Color = .init(hex: "7BE495")
    static let xCFF4D2: Color = .init(hex: "CFF4D2")
    
    static let freshGreens: [Color] = [x56C596, x7BE495, xCFF4D2]
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    struct TestView: View {
        var body: some View {
            VStack {
                ForEach(ColorConfigs.lightColors, id: \.self) { color in
                    Rectangle()
                        .foregroundStyle(color)
                }
                
                ForEach(ColorConfigs.darkColors, id: \.self) { color in
                    Rectangle()
                        .foregroundStyle(color)
                }
            }
        }
    }
    return TestView()
    
}
