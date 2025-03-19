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

struct MetronomeControlSlider: View {
    let config = CircleSliderConfig()

    @State private var controlValue: CGFloat = 40
    @State private var angleValue: CGFloat = 0.0
    @State private var isDragging: Bool = false
    
    var onValueChanged: ((CGFloat) -> Void)?
    
    var body: some View {
        ZStack {
            outerCircle
            progressArc
            knob
            
            Text("\(Int(controlValue)) º")
                .font(.system(size: 60))
                .foregroundColor(.white)
        }
        .onAppear {
            controlValue = max(config.minValue, min(config.maxValue, controlValue))
            angleValue = config.valueToAngle(controlValue)
        }
    }
    
    private var outerCircle: some View {
        Circle()
            .trim(from: config.startRatio, to: config.endRatio)
            .stroke(Color.gray,
                    style: StrokeStyle(lineWidth: 3, lineCap: .butt, dash: [3, 23.18]))
            .frame(width: config.frameSize, height: config.frameSize)
            .rotationEffect(.degrees(-90))
    }
    
    private var progressArc: some View {
        Circle()
            .trim(from: config.startRatio,
                  to: config.startRatio + config.displayRatio(controlValue) * (config.angleRange / (2 * .pi)))
            .stroke(Color.blue, lineWidth: 4)
            .frame(width: config.frameSize, height: config.frameSize)
            .rotationEffect(.degrees(-90))
            .animation(isDragging ? nil : .easeOut(duration: 0.15), value: controlValue)
    }
    
    private var knob: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: config.knobSize, height: config.knobSize)
            .padding(config.gesturePadding)
            .offset(y: -config.frameRadius)
            .rotationEffect(Angle.radians(Double(config.valueToAngle(controlValue))))
            .animation(isDragging ? nil : .easeOut(duration: 0.15), value: controlValue)
            .gesture(
                DragGesture(minimumDistance: 0.0)
                    .onChanged { value in
                        if !isDragging {
                            isDragging = true
                        }
                        change(location: value.location)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
    }
    
    private func calculateAngle(from vector: CGVector) -> CGFloat {
        let deltaY = vector.dy - config.knobDeltaValue
        let deltaX = vector.dx - config.knobDeltaValue
        let angle = atan2(deltaY, deltaX)
        // 从y轴0°开始
        let adjustedAngle = angle + .pi / 2.0
        // 修正角度到0-2π范围
        return config.normalizeAngle(adjustedAngle)
    }
     
    private func change(location: CGPoint) {
        let vector = CGVector(dx: location.x, dy: location.y)
        let angle = calculateAngle(from: vector)
         
        let newValue = config.angleToValue(angle)
         
        if newValue >= config.minValue && newValue <= config.maxValue {
            controlValue = newValue
            angleValue = angle
            // 调用回调
            onValueChanged?(newValue)
        }
    }
}

#Preview {
    MetronomeControlSlider()
}
