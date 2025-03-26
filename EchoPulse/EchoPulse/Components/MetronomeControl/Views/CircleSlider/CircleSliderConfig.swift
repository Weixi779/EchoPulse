//
//  ControlSliderConfig.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/19.
//

import Foundation
import SwiftUI

// MARK: - CircleSliderStyle enum
enum CircleSliderStyle {
    case blue
    case green
    case orange
    
    var primaryColor: Color {
        switch self {
        case .blue: return Color.blue
        case .green: return Color(red: 0.2, green: 0.75, blue: 0.5)
        case .orange: return Color(red: 0.95, green: 0.5, blue: 0.1)
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .blue: return Color.blue.opacity(0.7)
        case .green: return Color(red: 0.1, green: 0.65, blue: 0.45).opacity(0.7)
        case .orange: return Color(red: 0.95, green: 0.5, blue: 0.1).opacity(0.7)
        }
    }
    
    var progressGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [secondaryColor, primaryColor]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    var opacityGradient: Gradient {
        Gradient(colors: [primaryColor, primaryColor.opacity(0.7)])
    }
    
}

// MARK: - SliderConfig
/// Main configuration for the slider including value range and physical dimensions
struct SliderConfig {
    // Value range
    let minValue: Double
    let maxValue: Double
    // Knob setting
    let knobRadius: CGFloat
    let gesturePadding: CGFloat
    // Slider size
    let frameRadius: CGFloat
    // Origin point (degrees)
    let tiltAngle: CGFloat
    // Style
    var style: CircleSliderStyle = .blue
    
    init(
        minValue: Double = 40,
        maxValue: Double = 240,
        knobRadius: CGFloat = 15,
        gesturePadding: CGFloat = 10,
        frameRadius: CGFloat = 125,
        tiltAngle: CGFloat = 20,
        style: CircleSliderStyle = .blue
    ) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.knobRadius = knobRadius
        self.gesturePadding = gesturePadding
        self.frameRadius = frameRadius
        self.tiltAngle = tiltAngle
        self.style = style
    }
    
    // Computed properties
    var frameSize: CGFloat { frameRadius * 2 }
    var knobSize: CGFloat { knobRadius * 2 }
    var valueRange: Double { maxValue - minValue }
    var knobDeltaValue: CGFloat { knobRadius + gesturePadding }
    
    // Convert between value and ratio
    func displayRatio(_ current: Double) -> Double {
        return (current - minValue) / valueRange
    }
    
    // Angle calculations
    var startAngle: CGFloat { tiltAngle * .pi / 180 }
    var endAngle: CGFloat { (360 - tiltAngle) * .pi / 180 }
    var angleRange: CGFloat { endAngle - startAngle }
    var startRatio: CGFloat { startAngle / (2 * .pi) }
    var endRatio: CGFloat { endAngle / (2 * .pi) }
    
    // Convert value to rotation angle (radians)
    func valueToAngle(_ value: Double) -> CGFloat {
        let clampedValue = max(minValue, min(maxValue, value))
        return startAngle + CGFloat(displayRatio(clampedValue) * Double(angleRange))
    }
    
    // Convert angle to value
    func angleToValue(_ angle: CGFloat) -> Double {
        let normalizedAngle = normalizeAngle(angle)
        if normalizedAngle < startAngle || normalizedAngle > endAngle {
            return normalizedAngle < startAngle ? minValue : maxValue
        }
        
        let ratio = Double((normalizedAngle - startAngle) / angleRange)
        return minValue + (ratio * valueRange)
    }
    
    // Normalize angle to 0-2π
    func normalizeAngle(_ angle: CGFloat) -> CGFloat {
        var result = angle
        while result < 0 {
            result += 2 * .pi
        }
        while result >= 2 * .pi {
            result -= 2 * .pi
        }
        return result
    }
}

// MARK: - TickMarksConfig

struct TickMarksSize {
    let length: CGFloat
    let width: CGFloat
}

/// Configuration specifically for tick marks
struct TickMarksConfig {
    let majorTickCount: Int
    let minorTicksPerMajor: Int
    let majorSize: TickMarksSize
    let minorSize: TickMarksSize
    
    init(
        majorTickCount: Int = 10,
        minorTicksPerMajor: Int = 9,
        majorSize: TickMarksSize = .init(length: 10, width: 2),
        minorSize: TickMarksSize = .init(length: 4, width: 1)
    ) {
        self.majorTickCount = majorTickCount
        self.minorTicksPerMajor = minorTicksPerMajor
        self.majorSize = majorSize
        self.minorSize = minorSize
    }
    
    // Calculate value for a major tick based on the slider config
    func valueForMajorTick(_ index: Int, sliderConfig: SliderConfig) -> Double {
        return sliderConfig.minValue + (Double(index) / Double(majorTickCount)) * sliderConfig.valueRange
    }
    
    // Calculate angle for a major tick
    func angleForMajorTick(_ index: Int, sliderConfig: SliderConfig) -> CGFloat {
        let value = valueForMajorTick(index, sliderConfig: sliderConfig)
        return sliderConfig.valueToAngle(value)
    }
    
    // Calculate angle for a minor tick
    func angleForMinorTick(_ majorIndex: Int, _ minorIndex: Int, sliderConfig: SliderConfig) -> CGFloat {
        let majorValue = valueForMajorTick(majorIndex, sliderConfig: sliderConfig)
        let nextMajorValue = valueForMajorTick(majorIndex + 1, sliderConfig: sliderConfig)
        let minorStep = (nextMajorValue - majorValue) / Double(minorTicksPerMajor + 1)
        let minorValue = majorValue + Double(minorIndex + 1) * minorStep
        return sliderConfig.valueToAngle(minorValue)
    }
    
    // Check if tick is active (passed by the current value)
    func isTickActive(_ tickValue: Double, currentValue: Double) -> Bool {
        return tickValue <= currentValue
    }
    
    // Get minor tick value
    func minorTickValue(_ majorIndex: Int, _ minorIndex: Int, sliderConfig: SliderConfig) -> Double {
        let majorValue = valueForMajorTick(majorIndex, sliderConfig: sliderConfig)
        let nextMajorValue = valueForMajorTick(majorIndex + 1, sliderConfig: sliderConfig)
        let minorStep = (nextMajorValue - majorValue) / Double(minorTicksPerMajor + 1)
        return majorValue + Double(minorIndex + 1) * minorStep
    }
}
