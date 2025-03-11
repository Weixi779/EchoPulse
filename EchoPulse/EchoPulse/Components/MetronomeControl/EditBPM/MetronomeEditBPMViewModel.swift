//
//  MetronomeEditBPMViewModel.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/11.
//

import Foundation
import Combine

class MetronomeEditBPMViewModel: ObservableObject {
    @Published var inputText: String
    @Published var validatedBPM: Double? = nil
    
    private var cancellable = Set<AnyCancellable>()
    
    init(_ bpm: Double) {
        self.inputText = String(format: "%.f", bpm)
        
        // 订阅 filteredPublisher，用于更新 inputText（防止非法字符存在）
        filteredPublisher
            .sink { [weak self] filtered in
                guard let self = self else { return }
                // 如果能转换为数值，则校验范围
                if let value = Double(filtered), !filtered.isEmpty {
                    let clamped = min(max(value, 40), 240)
                    let clampedText = String(format: "%.f", clamped)
                    if self.inputText != clampedText {
                        self.inputText = clampedText
                    }
                } else {
                    if self.inputText != filtered {
                        self.inputText = filtered
                    }
                }
            }
            .store(in: &cancellable)
        
        // 订阅 validatedPublisher，用于更新 validatedBPM
        validatedPublisher
            .sink { [weak self] validated in
                self?.validatedBPM = validated
            }
            .store(in: &cancellable)
    }
    
    // 过滤 Publisher：只保留数字字符
    var filteredPublisher: AnyPublisher<String, Never> {
        $inputText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .map { input in
                input.filter { "0123456789".contains($0) }
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    // 校验 Publisher：将过滤后的字符串转换为数值，并限制在 40 ~ 240 范围内
    var validatedPublisher: AnyPublisher<Double?, Never> {
        filteredPublisher
            .map { filtered -> Double? in
                guard let value = Double(filtered), !filtered.isEmpty else { return nil }
                let clamped = min(max(value, 40), 240)
                return Double(Int(clamped))
            }
            .removeDuplicates { $0 == $1 }
            .eraseToAnyPublisher()
    }
}
