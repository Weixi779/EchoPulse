//
//  CircleSliderViewModel.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/19.
//

import Foundation
import SwiftUI
import Observation

// MARK: - CircleSliderViewModel
@Observable
class CircleSliderViewModel {
    // Configuration
    let sliderConfig: SliderConfig
    let ticksConfig: TickMarksConfig
    
    // State
    var currentAngle: CGFloat = 0.0
    var isDragging: Bool = false
    
    // Callbacks
    var onValueChanged: ((Double) -> Void)?
    var onDragComplete: (() -> Void)?
    
    // Haptic feedback generator
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    init(
        initialValue: Double,
        sliderConfig: SliderConfig,
        ticksConfig: TickMarksConfig,
        onValueChanged: ((Double) -> Void)? = nil,
        onDragComplete: (() -> Void)? = nil
    ) {
        self.sliderConfig = sliderConfig
        self.ticksConfig = ticksConfig
        self.onValueChanged = onValueChanged
        self.onDragComplete = onDragComplete
        self.currentAngle = sliderConfig.valueToAngle(initialValue)
        
        // Prepare haptic feedback
        self.hapticFeedback.prepare()
    }
    
    // Calculate angle from gesture location
    func calculateAngle(from vector: CGVector) -> CGFloat {
        let deltaY = vector.dy - sliderConfig.knobDeltaValue
        let deltaX = vector.dx - sliderConfig.knobDeltaValue
        let angle = atan2(deltaY, deltaX)
        // Start from y-axis 0°
        let adjustedAngle = angle + .pi / 2.0
        // Normalize angle to 0-2π range
        return sliderConfig.normalizeAngle(adjustedAngle)
    }
    
    // Check if angle is in the forbidden zone
    func isAngleInForbiddenZone(_ angle: CGFloat) -> Bool {
        let normalizedAngle = sliderConfig.normalizeAngle(angle)
        return normalizedAngle > sliderConfig.endAngle || normalizedAngle < sliderConfig.startAngle
    }
    
    // Handle drag start
    func startDrag() {
        isDragging = true
    }
    
    // Handle drag gesture
    func handleDrag(currentValue: Double, location: CGPoint) {
        let vector = CGVector(dx: location.x, dy: location.y)
        let angle = calculateAngle(from: vector)
        
        // Check if in forbidden zone
        if isAngleInForbiddenZone(angle) {
            return // No response in forbidden zone
        }
        
        let newValue = sliderConfig.angleToValue(angle)
        
        // Only update if the value is in range and has actually changed
        if newValue >= sliderConfig.minValue && newValue <= sliderConfig.maxValue {
            // Check if we've crossed a major tick
            let oldMajorIndex = Int((currentValue - sliderConfig.minValue) / (sliderConfig.valueRange / Double(ticksConfig.majorTickCount)))
            let newMajorIndex = Int((newValue - sliderConfig.minValue) / (sliderConfig.valueRange / Double(ticksConfig.majorTickCount)))
            
            // Provide haptic feedback when crossing major ticks
            if oldMajorIndex != newMajorIndex {
                hapticFeedback.impactOccurred()
            }
            
            currentAngle = angle
            onValueChanged?(newValue)
        }
    }
    
    // Handle drag end
    func endDrag() {
        isDragging = false
        onDragComplete?()
    }
}
