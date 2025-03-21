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
            CircleSliderTickMarksView(currentValue: value,
                                      sliderConfig: viewModel.sliderConfig,
                                      ticksConfig: viewModel.ticksConfig)
            
            CircleSliderProgressArcView(currentValue: value,
                                        isDragging: viewModel.isDragging,
                                        sliderConfig: viewModel.sliderConfig)
            
            CircleSliderKnobView(currentValue: value,
                                 isDragging: viewModel.isDragging,
                                 sliderConfig: viewModel.sliderConfig,
                                 onStartDrag: viewModel.startDrag,
                                 onDragging: viewModel.handleDrag,
                                 onEndDrag: viewModel.endDrag)
            
            content(value)
        }
    }
}

// MARK: - CircleSliderTickMarksView
fileprivate struct CircleSliderTickMarksView: View {
    let currentValue: Double
    let sliderConfig: SliderConfig
    let ticksConfig: TickMarksConfig
    
    var body: some View {
        ZStack {
            // Major tick marks
            ForEach(0...ticksConfig.majorTickCount, id: \.self) { index in
                let tickValue = ticksConfig.valueForMajorTick(index, sliderConfig: sliderConfig)
                let isActive = ticksConfig.isTickActive(tickValue, currentValue: currentValue)
                
                tickMark(
                    atAngle: ticksConfig.angleForMajorTick(index, sliderConfig: sliderConfig),
                    length: ticksConfig.majorTickLength,
                    width: ticksConfig.majorTickWidth,
                    color: isActive ? sliderConfig.style.primaryColor : Color.gray.opacity(0.7)
                )
            }
            
            // Minor tick marks
            ForEach(0..<ticksConfig.majorTickCount, id: \.self) { majorIndex in
                ForEach(0..<ticksConfig.minorTicksPerMajor, id: \.self) { minorIndex in
                    let minorTickValue = ticksConfig.minorTickValue(majorIndex, minorIndex, sliderConfig: sliderConfig)
                    let isActive = ticksConfig.isTickActive(minorTickValue, currentValue: currentValue)
                    
                    tickMark(
                        atAngle: ticksConfig.angleForMinorTick(majorIndex, minorIndex, sliderConfig: sliderConfig),
                        length: ticksConfig.minorTickLength,
                        width: ticksConfig.minorTickWidth,
                        color: isActive ? sliderConfig.style.secondaryColor : Color.gray.opacity(0.4)
                    )
                }
            }
        }
    }
    
    // Individual tick mark
    private func tickMark(atAngle angle: CGFloat, length: CGFloat, width: CGFloat, color: Color) -> some View {
        Rectangle()
            .fill(color)
            .frame(width: width, height: length)
            // Position the tick mark centered on the circle radius
            .offset(y: -sliderConfig.frameRadius + length/2)
            .rotationEffect(Angle(radians: Double(angle)))
    }
}

// MARK: - CircleSliderProgressArcView
fileprivate struct CircleSliderProgressArcView: View {
    let currentValue: Double
    let isDragging: Bool
    let sliderConfig: SliderConfig
    
    var body: some View {
        Circle()
            .trim(from: sliderConfig.startRatio,
                  to: sliderConfig.startRatio + CGFloat(sliderConfig.displayRatio(currentValue)) * (sliderConfig.angleRange / (2 * .pi)))
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: [sliderConfig.style.primaryColor.opacity(0.7), sliderConfig.style.primaryColor]),
                    center: .center,
                    startAngle: .degrees(Double(sliderConfig.startAngle) * 180 / .pi - 90),
                    endAngle: .degrees(Double(sliderConfig.valueToAngle(currentValue)) * 180 / .pi - 90)
                ),
                style: StrokeStyle(lineWidth: 8, lineCap: .round)
            )
            .frame(width: sliderConfig.frameSize, height: sliderConfig.frameSize)
            .rotationEffect(.degrees(-90))
            .animation(isDragging ? nil : .easeOut(duration: 0.15), value: currentValue)
    }
}

// MARK: - CircleSliderKnobView
fileprivate struct CircleSliderKnobView: View {
    let currentValue: Double
    let isDragging: Bool
    let sliderConfig: SliderConfig
    var onStartDrag: (() -> Void)
    var onDragging: ((Double, CGPoint) -> Void)
    var onEndDrag: (() -> Void)
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.2))
                .frame(width: sliderConfig.knobSize + 4, height: sliderConfig.knobSize + 4)
                .blur(radius: 3)
                .offset(y: -sliderConfig.frameRadius)
                .rotationEffect(Angle.radians(Double(sliderConfig.valueToAngle(currentValue))))
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [sliderConfig.style.primaryColor, sliderConfig.style.primaryColor.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 2, height: sliderConfig.knobRadius)
                    .offset(y: -sliderConfig.knobRadius/2 + 1)
            }
            .frame(width: sliderConfig.knobSize, height: sliderConfig.knobSize)
            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
            .padding(sliderConfig.gesturePadding)
            .offset(y: -sliderConfig.frameRadius)
            .rotationEffect(Angle.radians(Double(sliderConfig.valueToAngle(currentValue))))
        }
        .animation(isDragging ? nil : .easeOut(duration: 0.15), value: currentValue)
        .gesture(
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
        )
    }
}
