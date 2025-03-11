//
//  MetronomeEditBPMView.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/11.
//

import SwiftUI

struct MetronomeEditBPMView: View {
    @StateObject var viewModel: MetronomeEditBPMViewModel
    @Binding var showSheet: Bool
    var onFinishCallback: (Double?) -> ()
    
    init(bpm: Double, showSheet: Binding<Bool>, onFinishCallback: @escaping ((Double?) -> ())) {
        _viewModel = StateObject(wrappedValue: MetronomeEditBPMViewModel(bpm))
        self._showSheet = showSheet
        self.onFinishCallback = onFinishCallback
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    
                    Button("确定") {
                        showSheet = false
                        onFinishCallback(viewModel.validatedBPM)
                    }
                }
                .padding()
                
                Spacer()
            }
            
            VStack(spacing: 15) {
                Text("请输入指定BPM (40~240)")
                    .font(.headline)
                
                TextField("数字", text: $viewModel.inputText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                
                .padding(.top)
            }
            .padding()
        }
    }
}
