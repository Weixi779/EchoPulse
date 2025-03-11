//
//  MetronomeControlSlider.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import SwiftUI

struct MetronomeControlSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var step: Double
    var multiplier: Double = 1.0
    var onValueChanged: () -> Void

    var body: some View {
        VStack {
            Slider(value: $value, in: range, step: step) { editing in
                if !editing {
                    onValueChanged()
                }
            }
            .padding(.horizontal)
        }
    }
}
