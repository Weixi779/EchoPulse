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
                    Text("BPM: \(String(format: "%.f", viewModel.bpmDataSource.value))")
                        .font(.headline)
                    
//                    Stepper(value: $viewModel.bpm, step: 1) {
//                        
//                    } onEditingChanged: { editing in
//                        if !editing {
//                            viewModel.updateBPM(viewModel.bpm)
//                        }
//                    }
                }
                .padding()
                     
                bpmCircleSlider
                
                volumeCircleSlider
            }
            .padding()
            
            MetronomeSideMenuView(isShowMenu: $isShowMenu, selectedSound: $viewModel.sourceType)
        }
    }
}

extension MetronomeControlView {
    static let bpmSliderConfig: SliderConfig = .init(minValue: 40, maxValue: 240, knobRadius: 15, gesturePadding: 10, frameRadius: 125, tiltAngle: 20, style: .blue)
    static let bpmTickMarksConfig: TickMarksConfig = .init(majorTickCount: 10, minorTicksPerMajor: 9, majorTickLength: 10, minorTickLength: 4, majorTickWidth: 2, minorTickWidth: 1)
    
    var bpmCircleSlider: some View {
        CircleSliderView(
            value: $viewModel.bpmDataSource.value,
            sliderConfig: MetronomeControlView.bpmSliderConfig,
            tickMarksConfig: MetronomeControlView.bpmTickMarksConfig,
            onValueChanged: { value in
                viewModel.bpmDataSource.applyValue(value)
            },
            onDragComplete: {
                viewModel.bpmDataSource.commitValue()
            }
        ) { value in
            HStack(alignment: .lastTextBaseline) {
                Text("\(String(format: "%.f", value))")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                
                Text("BPM")
                    .font(.system(size: 10))
            }
        }
    }
}

extension MetronomeControlView {

    static let volumeSliderConfig: SliderConfig = .init(minValue: 0, maxValue: 1, knobRadius: 7.5, gesturePadding: 5, frameRadius: 45, tiltAngle: 40, style: .orange)
    static let volumeTickMarksConfig: TickMarksConfig = .init(majorTickCount: 10, minorTicksPerMajor: 4, majorTickLength: 5, minorTickLength: 2, majorTickWidth: 1, minorTickWidth: 0.5)
    
    var volumeCircleSlider: some View {
        CircleSliderView(
            value: $viewModel.volumeDataSource.value,
            sliderConfig: MetronomeControlView.volumeSliderConfig,
            tickMarksConfig: MetronomeControlView.volumeTickMarksConfig,
            onValueChanged: { value in
                viewModel.volumeDataSource.applyValue(value)
            },
            onDragComplete: {
                viewModel.volumeDataSource.commitValue()
            }
        ) { value in
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text("\(String(format: "%.f", value * 100))")
                    .font(.system(size: 20, design: .rounded))
                Text("%")
                    .font(.system(size: 10))
            }
            .rotationEffect(.degrees(-180))
        }
        .rotationEffect(.degrees(-180))
    }
}

#Preview {
    MetronomeControlView()
}
