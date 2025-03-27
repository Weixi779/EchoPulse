//
//  SourceTypeDataSource.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/21.
//

import Foundation
import Observation
import Combine

@Observable
class SoundTypeDataSource: ValueSource {
    typealias ValueType = MetronomeSoundType
    
    var value: MetronomeSoundType
    var isChanging: Bool = false
    
    let valueApplied = PassthroughSubject<MetronomeSoundType, Never>()
    let valueCommitted = PassthroughSubject<MetronomeSoundType, Never>()
    
    init() {
        self.value = UserDefaultsUtils.getValue(for: .sourceType)
    }
    
    func applyValue(_ newValue: MetronomeSoundType) {
        value = newValue
        isChanging = true
        valueApplied.send(newValue)
    }
    
    func commitValue() {
        isChanging = false
        UserDefaultsUtils.setValue(value, for: .sourceType)
        valueCommitted.send(value)
    }
}
