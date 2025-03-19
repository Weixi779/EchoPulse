//
//  ControlSliderConfig.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/19.
//

import Foundation

struct CircleSliderConfig {
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
}

// MARK: - Length Part
extension CircleSliderConfig {
    var frameSize: CGFloat { frameRadius * 2 }
    var knobSize: CGFloat { knobRadius * 2 }
    
    var valueRange: CGFloat { maxValue - minValue }
    var knobDeltaValue: CGFloat { knobRadius + gesturePadding }
    
    func displayRatio(_ current: CGFloat) -> CGFloat {
        return (current - minValue) / valueRange
    }
}

// MARK: - Angle Part
extension CircleSliderConfig {
    var startAngle: CGFloat { tiltAngle * .pi / 180 }
    var endAngle: CGFloat { (360 - tiltAngle) * .pi / 180 }
    var angleRange: CGFloat { endAngle - startAngle }
    
    var startRatio: CGFloat { startAngle / (2 * .pi) }
    var endRatio: CGFloat { endAngle / (2 * .pi) }
    
    // 将值转换为旋转角度（弧度）
    func valueToAngle(_ value: CGFloat) -> CGFloat {
        let clampedValue = max(minValue, min(maxValue, value))
        return startAngle + (displayRatio(clampedValue) * angleRange)
    }
    
    // 将角度转换为值
    func angleToValue(_ angle: CGFloat) -> CGFloat {
        let normalizedAngle = normalizeAngle(angle)
        if normalizedAngle < startAngle || normalizedAngle > endAngle {
            // 如果角度超出范围，返回最近的边界值
            return normalizedAngle < startAngle ? minValue : maxValue
        }
        
        let ratio = (normalizedAngle - startAngle) / angleRange
        return minValue + (ratio * valueRange)
    }
    
    // 标准化角度到0-2π
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
