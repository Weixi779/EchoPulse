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
    @State private var isShowSheet: Bool = false
    
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
                    
                    Button {
                        isShowSheet.toggle()
                    } label: {
                        Image(systemName: "pencil.line")
                    }
                }
                     
                MetronomeControlSlider(value: $viewModel.bpm, range: 40...240, step: 1) {
                    viewModel.updateBPM(viewModel.bpm)
                }
                
                Text("Volume: \(String(format: "%.f", viewModel.volume * 100)) %")
                    .font(.headline)
                
                MetronomeControlSlider(value: $viewModel.volume, range: 0.0...1.0, step: 0.1, multiplier: 100) {
                    viewModel.updateVolume(viewModel.volume)
                }
            }
            .padding()
            .sheet(isPresented: $isShowSheet) {
                MetronomeEditBPMView(bpm: viewModel.bpm, showSheet: $isShowSheet) { newValue in
                    if let newValue = newValue {
                        viewModel.updateBPM(newValue)
                    }
                }
                .presentationDetents([.medium])
            }
            
            MetronomeSideMenuView(isShowMenu: $isShowMenu, selectedSound: $viewModel.sourceType)
        }
    }
}

#Preview {
    MetronomeControlView()
}
