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
            VStack(spacing: 25) {
                bpmCircleSlider
                
                VStack(spacing: -50) {
                    HStack {
                        CircleStepper(
                            value: $viewModel.bpmDataSource.value,
                            type: .decrement,
                            range: 40...240,
                            onApply: { newValue in
                                viewModel.bpmDataSource.applyValue(newValue)
                            },
                            onCommit: {
                                viewModel.bpmDataSource.commitValue()
                            }
                        )
                        
                        Spacer()
                        
                        CircleStepper(
                            value: $viewModel.bpmDataSource.value,
                            type: .increment,
                            range: 40...240,
                            onApply: { newValue in
                                viewModel.bpmDataSource.applyValue(newValue)
                            },
                            onCommit: {
                                viewModel.bpmDataSource.commitValue()
                            }
                        )
                    }
                    .padding()
                    
                    volumeCircleSlider
                }
             
                MetronomeSoundControlBar(
                    isPlaying: $viewModel.isPlaying,
                    sourceDataSource: viewModel.sourceTypeDataSource,
                    onToggle: { viewModel.togglePlay() },
                    height: 60
                )
                .padding()
            }
            .padding()
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
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .contentTransition(.identity)
                    .animation(.easeInOut, value: value)
                
                Text("BPM")
                    .font(.system(size: 12))
                    .offset(y: 5)
            }
        }
    }
}

extension MetronomeControlView {

    static let volumeSliderConfig: SliderConfig = .init(minValue: 0, maxValue: 1, knobRadius: 7.5, gesturePadding: 5, frameRadius: 80, tiltAngle: 80, style: .orange)
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
            VStack {
                Text("\(String(format: "%.f", value * 100))%")
                    .font(.system(size: 25, design: .rounded))
                
                Text("Volume")
                    .font(.system(size: 10))
            }
            .rotationEffect(.degrees(-180))
            .offset(y: -10)
        }
        .rotationEffect(.degrees(-180))
    }
}

#Preview {
    MetronomeControlView()
}
