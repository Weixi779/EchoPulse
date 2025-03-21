//
//  CircleStepper.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/21.
//

import Foundation
import SwiftUI

enum CircleStepperType {
    case increment
    case decrement
}

struct CircleStepper: View {
    @State private var isPressed: Bool = false
    @State private var longPressTimer = 0
    
    @Binding var value: Double
    
    let range: ClosedRange<Double>
    let step: Double
    let type: CircleStepperType
    let radius: CGFloat
    let onApply: ((Double) -> Void)
    let onCommit: (() -> Void)
    
    init(value: Binding<Double>, type: CircleStepperType, range: ClosedRange<Double>, step: Double = 1, size: CGFloat = 30, onApply: @escaping ((Double) -> Void), onCommit: @escaping (() -> Void)) {
        _value = value
        self.range = range
        self.type = type
        self.step = step
        self.radius = size
        self.onApply = onApply
        self.onCommit = onCommit
    }
    
    var body: some View {
        ZStack {
            CircleStepperTickMarksView(radius: radius)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.snappy(duration: 0.1), value: isPressed)
            
            Image(systemName: iconName)
                .font(.system(size: radius * 0.75, weight: .medium))
                .foregroundColor(Color.primary.opacity(0.3))
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
        }
        .disabled(!isValid)
        .opacity(isValid ? 1.0 : 0.5)
        .gesture(
            LongPressGesture(minimumDuration: 0.5, maximumDistance: 50)
                .simultaneously(with:
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !isValid { return }
                            if !isPressed {
                                isPressed = true
                                onApply(performStep())
                            }
                        }
                        .onEnded { _ in
                            isPressed = false
                            longPressTimer = 0
                            onCommit()
                        }
                )
        )
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            if isPressed {
                longPressTimer += 1
                
                // tigger = 0.5s
                if longPressTimer > 5 {
                    onApply(performStep())
                }
            }
        }
    }
    
    var iconName: String {
        switch self.type {
        case .increment: return "plus"
        case .decrement: return "minus"
        }
    }
    
    var isValid: Bool {
        switch self.type {
        case .increment: return value < range.upperBound
        case .decrement: return value > range.lowerBound
        }
    }
    
    private func performStep() -> Double {
        switch self.type {
        case .increment:
            return min(value + step, range.upperBound)
        case .decrement:
            return max(value - step, range.lowerBound)
        }
    }
}

#Preview {
    struct TestView: View {
        @State var value: Double = 40
        var body: some View {
            VStack {
                Text("\(value)")
                
                HStack {
                    CircleStepper(
                        value: $value,
                        type: .increment,
                        range: 40...240,
                        onApply: { newValue in
                            value = newValue
                        },
                        onCommit: {
                            
                        }
                    )
                    
                    CircleStepper(
                        value: $value,
                        type: .decrement,
                        range: 40...240,
                        onApply: { newValue in
                            print("onApply")
                            value = newValue
                        },
                        onCommit: {
                            
                        }
                    )
                }
            }
            .padding()
        }
    }
    return TestView()
}
