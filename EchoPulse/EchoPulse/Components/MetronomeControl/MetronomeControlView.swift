//
//  MetronomeControlView.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import SwiftUI

struct MetronomeControlView: View {
    @State private var viewModel = MetronomeControlViewModel()
    @State private var isShowMenu: Bool = false
    
    var body: some View {
        ZStack {
            MetronomeSoundPickerHeader(isShowMenu: $isShowMenu)
            
            VStack(spacing: 20) {
                MetronomeControlToggleButton(
                    isPlaying: $viewModel.isPlaying,
                    onToggle: { viewModel.togglePlay() },
                    width: 244,
                    height: 120,
                    iconSize: 45,
                    cornerRadius: 20
                )
                
                HStack {
                    Text("BPM: \(String(format: "%.f", viewModel.bpm))")
                        .font(.headline)
                    
                    Stepper(value: $viewModel.bpm, step: 1) {
                        
                    } onEditingChanged: { editing in
                        if !editing {
                            viewModel.updateBPM(viewModel.bpm)
                        }
                    }
                }
                .padding()
                     
                Text("Volume: \(String(format: "%.f", viewModel.volume * 100)) %")
                    .font(.headline)
                
                CircleSliderView(value: $viewModel.bpm, range: 40...240, style: .blue, onDragComplete: { value in
                    viewModel.updateBPM(value)
                }) { value in
                    HStack(alignment: .lastTextBaseline) {
                        Text("\(String(format: "%.f", value))")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                        
                        Text("BPM")
                            .font(.system(size: 10))
                    }
                }
            }
            .padding()
            
            MetronomeSideMenuView(isShowMenu: $isShowMenu, selectedSound: $viewModel.sourceType)
        }
    }
}

#Preview {
    MetronomeControlView()
}
