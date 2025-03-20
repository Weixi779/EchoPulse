//
//  ValueSource.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/21.
//

import Foundation

protocol ValueSource {
    associatedtype ValueType: Equatable
    
    var value: ValueType { get set }
    var isChanging: Bool { get }
    
    func applyValue(_ newValue: ValueType)
    func commitValue()
}
