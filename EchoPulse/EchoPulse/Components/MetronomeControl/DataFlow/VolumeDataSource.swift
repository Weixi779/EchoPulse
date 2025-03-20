//
//  VolumeDataSource.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/21.
//

import Foundation
import Observation
import Combine

@Observable
class VolumeDataSource: ValueSource {
    typealias ValueType = Double
    
    var value: Double
    var isChanging: Bool = false
    
    let valueApplied = PassthroughSubject<Double, Never>()
    let valueCommitted = PassthroughSubject<Double, Never>()
    
    init() {
        self.value = UserDefaultsUtils.getValue(for: .volume)
    }
    
    func applyValue(_ newValue: Double) {
        guard isWithinValidRange(newValue) else { return }
        
        value = newValue
        isChanging = true
        valueApplied.send(newValue)
    }
    
    func commitValue() {
        isChanging = false
        UserDefaultsUtils.setValue(value, for: .volume)
        valueCommitted.send(value)
    }
    
    private func isWithinValidRange(_ newValue: Double) -> Bool {
        if newValue < 0 || newValue > 1.0 {
            return false
        }
        return true
    }
}
