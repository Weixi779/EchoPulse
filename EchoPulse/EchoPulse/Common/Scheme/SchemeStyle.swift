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
    
    public func styleGradient(_ factor: Float = 0.6, isDarkMode: Bool = false) -> MeshGradient {
        return MeshGradient(
            width: 3, height: 3,
            points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.7], [factor, 0.3], [1.0, 0.5],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
            ], colors: isDarkMode ? randomDarks : randomLights
                .flatMap { Array(repeating: $0, count: 2) }
        )
    }
}
