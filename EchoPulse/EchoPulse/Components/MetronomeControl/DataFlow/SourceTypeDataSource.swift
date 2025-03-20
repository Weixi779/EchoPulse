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
class SourceTypeDataSource: ValueSource {
    typealias ValueType = MetronomeSourceType
    
    var value: MetronomeSourceType
    var isChanging: Bool = false
    
    let valueApplied = PassthroughSubject<MetronomeSourceType, Never>()
    let valueCommitted = PassthroughSubject<MetronomeSourceType, Never>()
    
    init() {
        self.value = UserDefaultsUtils.getValue(for: .sourceType)
    }
    
    func applyValue(_ newValue: MetronomeSourceType) {
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
