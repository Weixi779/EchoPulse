//
//  MetronomeSideMenuScrollView.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/10.
//

import SwiftUI

struct MetronomeSideMenuScrollView: View {
    @Binding var selectedSound: MetronomeSourceType
    
    private let cellHeight: CGFloat = 150
    private let spacing: CGFloat = 50
    
    private let sources = MetronomeSourceType.allCases
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: spacing) {
                        ForEach(sources) { source in
                            Text(source.fileName)
                                .font(.largeTitle)
                                .frame(height: cellHeight)
                                .background(Color.gray)
                                .scrollTargetLayout()
                                .scrollTransition(
                                    axis: .vertical
                                ) { content, phase in
                                    content
                                        .rotationEffect(.degrees(phase.value * -10), anchor: .bottomTrailing)
                                        .offset(x: phase.isIdentity ? 0 : 15)
                                        .opacity(phase.isIdentity ? 1 : 0)
                                }
                        }
                    }
                    .padding(.vertical, (geo.size.height - cellHeight) / 2)
                }
                .scrollIndicators(.hidden)
                .onScrollGeometryChange(for: CGPoint.self) { geometry in
                    geometry.contentOffset
                } action: { oldOffset, newOffset in
                    let baseOffset = geo.safeAreaInsets.top
                    let totalHeight = cellHeight + spacing
                    
                    let index = Int(round((newOffset.y + (totalHeight / 2) - baseOffset) / totalHeight))
                    
                    if index >= 0 && index < sources.count {
                        let newItem = sources[index]
                        if selectedSound != newItem {
                            selectedSound = newItem
                        }
                    }
                }
                .onScrollPhaseChange { oldPhase, newPhase in
                    if oldPhase != .idle && newPhase == .idle {
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(selectedSound, anchor: .center)
                        }
                    }
                    if oldPhase == .idle && newPhase == .idle {
                        proxy.scrollTo(selectedSound, anchor: .center)
                    }
                }
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var selectedSound: MetronomeSourceType = .bassDrum
        
        var body: some View {
            MetronomeSideMenuScrollView(
                selectedSound: $selectedSound
            )
        }
    }
    return PreviewWrapper()
}
