//
//  MetronomeControlSlider.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import SwiftUI

// MARK: - MetronomeControlSlider
struct CircleSliderView<Content: View>: View {
    @Binding var value: Double
    @State private var viewModel: CircleSliderViewModel
    @ViewBuilder var content: (Double) -> Content
    
    init(
        value: Binding<Double>,
        sliderConfig: SliderConfig,
        tickMarksConfig: TickMarksConfig,
        onValueChanged: ((Double) -> Void)? = nil,
        onDragComplete: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Double) -> Content
    ) {
        self._value = value
        let model = CircleSliderViewModel(initialValue: value.wrappedValue, sliderConfig: sliderConfig, ticksConfig: tickMarksConfig, onValueChanged: onValueChanged, onDragComplete: onDragComplete)
        
        self._viewModel = State(initialValue: model)
        self.content = content
    }
    
    var body: some View {
        ZStack {
            TickMarksView(currentValue: value,
                          sliderConfig: viewModel.sliderConfig,
                          ticksConfig: viewModel.ticksConfig)
            
            ProgressArcView(currentValue: value,
                            isDragging: viewModel.isDragging,
                            sliderConfig: viewModel.sliderConfig)
            
            KnobView(currentValue: value,
                     isDragging: viewModel.isDragging,
                     sliderConfig: viewModel.sliderConfig,
                     onStartDrag: viewModel.startDrag,
                     onDragging: viewModel.handleDrag,
                     onEndDrag: viewModel.endDrag)
            
            content(value)
        }
    }
}

// MARK: - TickMarksView
fileprivate struct TickMarksView: View {
    let currentValue: Double
    let sliderConfig: SliderConfig
    let ticksConfig: TickMarksConfig
    
    var body: some View {
        ZStack {
            majorTickMarks
            
            minorTickMarks
        }
    }
    
    private var majorTickMarks: some View {
        ForEach(0...ticksConfig.majorTickCount, id: \.self) { index in
            let tickValue = ticksConfig.valueForMajorTick(index, sliderConfig: sliderConfig)
            let isActive = ticksConfig.isTickActive(tickValue, currentValue: currentValue)
            
            createTickMark(
                atAngle: ticksConfig.angleForMajorTick(index, sliderConfig: sliderConfig),
                size: ticksConfig.majorSize,
                color: isActive ? sliderConfig.style.primaryColor : Color.gray.opacity(0.7)
            )
        }
    }
    
    private var minorTickMarks: some View {
        ForEach(0..<ticksConfig.majorTickCount, id: \.self) { majorIndex in
            ForEach(0..<ticksConfig.minorTicksPerMajor, id: \.self) { minorIndex in
                let minorTickValue = ticksConfig.minorTickValue(majorIndex, minorIndex, sliderConfig: sliderConfig)
                let isActive = ticksConfig.isTickActive(minorTickValue, currentValue: currentValue)
                
                createTickMark(
                    atAngle: ticksConfig.angleForMinorTick(majorIndex, minorIndex, sliderConfig: sliderConfig),
                    size: ticksConfig.minorSize,
                    color: isActive ? sliderConfig.style.secondaryColor : Color.gray.opacity(0.4)
                )
            }
        }
    }
    
    private func createTickMark(atAngle angle: CGFloat, size: TickMarksSize, color: Color) -> some View {
        Rectangle()
            .fill(color)
            .frame(width: size.width, height: size.length)
            .offset(y: -sliderConfig.frameRadius + (size.length / 2))
            .rotationEffect(Angle(radians: Double(angle)))
    }
}

// MARK: - ProgressArcView
fileprivate struct ProgressArcView: View {
    let currentValue: Double
    let isDragging: Bool
    let sliderConfig: SliderConfig
    
    private var startRatio: CGFloat {
        sliderConfig.startRatio
    }
    
    private var endRatio: CGFloat {
        let progressRatio = CGFloat(sliderConfig.displayRatio(currentValue))
        let angleRatio = sliderConfig.angleRange / (2 * .pi)
        return startRatio + progressRatio * angleRatio
    }
    
    private var startAngleDegrees: Double {
        Double(sliderConfig.startAngle) * 180 / .pi - 90
    }
    
    private var endAngleDegrees: Double {
        Double(sliderConfig.valueToAngle(currentValue)) * 180 / .pi - 90
    }
    
    // MARK: 视图构建
    var body: some View {
        Circle()
            .trim(from: startRatio, to: endRatio)
            .stroke(
                AngularGradient(
                    gradient: sliderConfig.style.opacityGradient,
                    center: .center,
                    startAngle: .degrees(startAngleDegrees),
                    endAngle: .degrees(endAngleDegrees)
                ),
                style: StrokeStyle(lineWidth: 8, lineCap: .round)
            )
            .frame(width: sliderConfig.frameSize, height: sliderConfig.frameSize)
            .rotationEffect(.degrees(-90))
            .animation(isDragging ? nil : .easeOut(duration: 0.15), value: currentValue)
    }
}

// MARK: - KnobView
fileprivate struct KnobView: View {
    let currentValue: Double
    let isDragging: Bool
    let sliderConfig: SliderConfig
    var onStartDrag: (() -> Void)
    var onDragging: ((Double, CGPoint) -> Void)
    var onEndDrag: (() -> Void)
    
    var body: some View {
        ZStack {
            knobShadow
            
            knobBody
        }
        .animation(isDragging ? nil : .easeOut(duration: 0.15), value: currentValue)
        .gesture(createDragGesture())
    }
    
    private var knobShadow: some View {
        Circle()
            .fill(Color.black.opacity(0.2))
            .frame(width: sliderConfig.knobSize + 4, height: sliderConfig.knobSize + 4)
            .blur(radius: 3)
            .offset(y: -sliderConfig.frameRadius)
            .rotationEffect(Angle.radians(Double(sliderConfig.valueToAngle(currentValue))))
    }
    
    private var knobBody: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: sliderConfig.style.opacityGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Rectangle()
                .fill(Color.white)
                .frame(width: 2, height: sliderConfig.knobRadius)
                .offset(y: -sliderConfig.knobRadius / 2 + 1)
        }
        .frame(width: sliderConfig.knobSize, height: sliderConfig.knobSize)
        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
        .padding(sliderConfig.gesturePadding)
        .offset(y: -sliderConfig.frameRadius)
        .rotationEffect(Angle.radians(Double(sliderConfig.valueToAngle(currentValue))))
    }
    
    private func createDragGesture() -> some Gesture {
        DragGesture(minimumDistance: 0.0)
            .onChanged { dragPosition in
                if !isDragging {
                    onStartDrag()
                }
                onDragging(currentValue, dragPosition.location)
            }
            .onEnded { _ in
                onEndDrag()
            }
    }
}
