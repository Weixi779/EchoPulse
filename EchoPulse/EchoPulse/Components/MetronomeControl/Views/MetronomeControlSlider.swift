//
//  MetronomeControlSlider.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import SwiftUI

//struct MetronomeControlSlider: View {
//    @Binding var value: Double
//    var range: ClosedRange<Double>
//    var step: Double
//    var multiplier: Double = 1.0
//    var onValueChanged: () -> Void
//
//    var body: some View {
//        VStack {
//            Slider(value: $value, in: range, step: step) { editing in
//                if !editing {
//                    onValueChanged()
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//}

struct ControlSliderConfig {
    let minimumValue: CGFloat
    let maximumValue: CGFloat
    
    let knobRadius: CGFloat
    let gesturePadding: CGFloat = 10
    let frameRadius: CGFloat
    
    var totalValue: CGFloat { maximumValue - minimumValue }
    
    var deltaKnobValue: CGFloat { knobRadius + gesturePadding }
}

struct MetronomeControlSlider: View {
    @State var controlValue: CGFloat = 40
    @State var angleValue: CGFloat = 0.0
    let config = ControlSliderConfig(minimumValue: 40,
                                     maximumValue: 240.0,
                                     knobRadius: 15.0,
                                     frameRadius: 125.0)
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray,
                        style: StrokeStyle(lineWidth: 3, lineCap: .butt, dash: [3, 23.18]))
                .frame(width: config.frameRadius * 2, height: config.frameRadius * 2)
            
            Circle()
                .trim(from: 0.0, to: (controlValue - config.minimumValue)/config.totalValue)
                .stroke(Color.blue, lineWidth: 4)
                .frame(width: config.frameRadius * 2, height: config.frameRadius * 2)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .fill(Color.blue)
                .frame(width: config.knobRadius * 2, height: config.knobRadius * 2)
                .padding(config.gesturePadding)
                .offset(y: -config.frameRadius)
                .rotationEffect(Angle.degrees(Double(angleValue)))
                .gesture(
                    DragGesture(minimumDistance: 0.0)
                        .onChanged { value in
                            change(location: value.location)
                        }
                )
            
            Text("\(String.init(format: "%.0f", controlValue)) º")
                .font(.system(size: 60))
                .foregroundColor(.white)
        }
    }
    
    private func change(location: CGPoint) {
        let vector = CGVector(dx: location.x, dy: location.y)
        
        let deltaY = vector.dy - config.deltaKnobValue
        let deltaX = vector.dx - config.deltaKnobValue
        let angle = atan2(deltaY, deltaX) + .pi / 2.0 // start at y-axis 0°
        
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
        
        let value = (fixedAngle / (2.0 * .pi) * config.totalValue) + config.minimumValue
        
        if value >= config.minimumValue && value <= config.maximumValue {
            controlValue = value
            angleValue = fixedAngle * 180 / .pi
        }
    }
}

#Preview {
    MetronomeControlSlider()
}
