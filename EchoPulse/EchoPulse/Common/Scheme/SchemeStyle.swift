//
//  ColorStyle.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/10.
//

import Foundation
import SwiftUI

struct SchemeStyleKey: EnvironmentKey {
    static let defaultValue = SchemeStyle()
}

extension EnvironmentValues {
    var schemeStyle: SchemeStyle {
        get { self[SchemeStyleKey.self] }
        set { self[SchemeStyleKey.self] = newValue }
    }
}

struct SchemeStyle {
    
    private let randomLights: [Color]
    private let randomDarks: [Color]
    
    init() {
        randomLights = ColorConfigs.lightColors.shuffled()
        randomDarks = ColorConfigs.darkColors.shuffled()
    }
    
    public func styleGradient(isDarkMode: Bool = false) -> MeshGradient {
        let baseColors = isDarkMode ? randomDarks : randomLights
        let colors = baseColors.flatMap { Array(repeating: $0, count: 2) }
        
        return MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.7], [0.6, 0.3], [1.0, 0.5],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
            ],
            colors: colors
        )
    }
    
    public func animatedStyleGradient(for date: Date, isDarkMode: Bool = false) -> MeshGradient {
        let t = CGFloat(date.timeIntervalSince1970)
        let factor1 = (sin(t) * 0.5 + cos(t * 1.7) * 0.5 + 1) * 0.35 + 0.2
        let factor2 = (sin(t * 1.2) * cos(t * 0.8) + 1) * 0.25 + 0.25
        let factor3 = (sin(t * 0.7) * cos(t * 1.3) + 1) * 0.25 + 0.25
        let factor4 = (cos(t * 1.3) * sin(t * 0.9) + 1) * 0.35
        
        let points: [[Double]] = [
            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
            [0.0, Double(factor1)], [Double(factor2), Double(factor3)], [1.0, Double(factor4)],
            [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
        ]
        
        let baseColors = isDarkMode ? randomDarks : randomLights
        let animatedColors: [Color] = baseColors.enumerated().flatMap { index, color in
            let hueShift = (sin(t + CGFloat(index) * 0.5) + cos(t + CGFloat(index) * 1.1)) * 0.05
            return Array(repeating: shiftHue(of: color, by: hueShift), count: 2)
        }
        
        return MeshGradient(
            width: 3,
            height: 3,
            points: points.map { SIMD2<Float>(Float($0[0]), Float($0[1])) },
            colors: animatedColors
        )
    }
    
    private func shiftHue(of color: Color, by amount: CGFloat) -> Color {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        UIColor(color).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        hue += amount
        hue = hue.truncatingRemainder(dividingBy: 1.0)
        if hue < 0 { hue += 1 }
        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness), opacity: Double(alpha))
    }
}
