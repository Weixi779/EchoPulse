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
    // value range
    let minValue: CGFloat = 40
    let maxValue: CGFloat = 240
    // knob setting
    let knobRadius: CGFloat = 15
    let gesturePadding: CGFloat = 10
    // slider size
    let frameRadius: CGFloat = 125
    // origin point
    let tiltAngle: CGFloat = 15
    
    var deltaRange: CGFloat { maxValue - minValue }
    var deltaKnobValue: CGFloat { knobRadius + gesturePadding }
    
    func displayRatio(_ current: CGFloat) -> CGFloat {
        return (current - minValue) / deltaRange
    }
}

struct MetronomeControlSlider: View {
    let config = ControlSliderConfig()

    @State var controlValue: CGFloat = 40
    @State var angleValue: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            outerCircle
            progressCircle
            knobCircle
            
            Text("\(Int(controlValue)) º")
                .font(.system(size: 60))
                .foregroundColor(.white)
        }
    }
    
    private var outerCircle: some View {
        Circle()
            .stroke(Color.gray,
                    style: StrokeStyle(lineWidth: 3, lineCap: .butt, dash: [3, 23.18]))
            .frame(width: config.frameRadius * 2, height: config.frameRadius * 2)
    }
    
    private var progressCircle: some View {
        Circle()
            .trim(from: 0.0, to: config.displayRatio(controlValue))
            .stroke(Color.blue, lineWidth: 4)
            .frame(width: config.frameRadius * 2, height: config.frameRadius * 2)
            .rotationEffect(.degrees(-90))
    }
    
    private var knobCircle: some View {
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
    }
    
     private func calculateAngle(from vector: CGVector) -> CGFloat {
         let deltaY = vector.dy - config.deltaKnobValue
         let deltaX = vector.dx - config.deltaKnobValue
         let angle = atan2(deltaY, deltaX) + .pi / 2.0 // 从y轴0°开始
         
         // 修正角度到0-2π范围
         return angle < 0.0 ? angle + 2.0 * .pi : angle
     }
     
     private func change(location: CGPoint) {
         let vector = CGVector(dx: location.x, dy: location.y)
         let fixedAngle = calculateAngle(from: vector)
         
         let value = (fixedAngle / (2.0 * .pi) * config.deltaRange) + config.minValue
         
         if value >= config.minValue && value <= config.maxValue {
             controlValue = value
             angleValue = fixedAngle * 180 / .pi
         }
     }
}

#Preview {
    MetronomeControlSlider()
}
