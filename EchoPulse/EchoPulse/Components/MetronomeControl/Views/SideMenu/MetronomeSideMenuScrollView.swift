//
//  MetronomeSideMenuScrollView.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/10.
//

import SwiftUI

struct MetronomeSideMenuScrollView: View {
    @Binding var selectedSound: MetronomeSourceType
    
    // scroller 初始化时会默认顶部开始滚 这里跳过这一次修改 本应为nil
    @State private var lastSelectedSound: MetronomeSourceType = .bassDrum
    
    private let cellHeight: CGFloat = 100
    private let spacing: CGFloat = 25
    
    private let sources = MetronomeSourceType.allCases
    
    let onValueApply: ((MetronomeSourceType) -> Void)
    let onValueCommit: (() -> Void)
    
    init(selectedSound: Binding<MetronomeSourceType>,
         onValueApply: @escaping (MetronomeSourceType) -> Void,
         onValueCommit: @escaping () -> Void) {
        self._selectedSound = selectedSound
        self.onValueApply = onValueApply
        self.onValueCommit = onValueCommit
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: spacing) {
                        ForEach(sources) { source in
                            MetronomeSideMenuScrollCell(sourceType: source, selectingType: $selectedSound)
                                .frame(height: cellHeight)
                                .scrollTargetLayout()
                                .scrollTransition(axis: .vertical) { content, phase in
                                    content
                                        .rotationEffect(.degrees(phase.value * -15), anchor: .bottomTrailing)
                                        .offset(x: phase.isIdentity ? 0 : 45)
                                        .opacity(phase.isIdentity ? 1 : 0)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.5)
                                }
                        }
                    }
                    .padding(.vertical, (geo.size.height - cellHeight) / 2)
                }
                .scrollIndicators(.hidden)
                .onScrollGeometryChange(for: CGPoint.self) { geometry in
                    geometry.contentOffset
                } action: { _, newOffset in
                    handleScrollOffsetChange(newOffset: newOffset, geoFrame: geo)
                }
                .onScrollPhaseChange { oldPhase, newPhase in
                    handleScrollPhaseChange(oldPhase: oldPhase, newPhase: newPhase, proxy: proxy)
                }
                .onChange(of: selectedSound) { oldValue, newValue in
                    if lastSelectedSound != newValue {
                        lastSelectedSound = newValue
                    }
                }
            }
        }
    }
    
    private func handleScrollOffsetChange(newOffset: CGPoint, geoFrame: GeometryProxy) {
        let baseOffset = geoFrame.safeAreaInsets.top
        let totalHeight = cellHeight + spacing
        
        let index = Int(round((newOffset.y + (totalHeight / 2) - baseOffset) / totalHeight))
        
        if index >= 0 && index < sources.count {
            let newItem = sources[index]
            if newItem != lastSelectedSound {
                onValueApply(newItem)
            }
        }
    }
    
    private func handleScrollPhaseChange(oldPhase: ScrollPhase, newPhase: ScrollPhase, proxy: ScrollViewProxy) {
        // 用户手动触发时执行判断
        if (oldPhase != .idle && oldPhase != .animating) && newPhase == .idle {
            withAnimation(.easeInOut) {
                proxy.scrollTo(selectedSound, anchor: .center)
                onValueCommit()
            }
        }
        // 相当于onAppear 初始化滚动目标区域
        if oldPhase == .idle && newPhase == .idle {
            proxy.scrollTo(selectedSound, anchor: .center)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var selectedSound: MetronomeSourceType = .bassDrum
        
        var body: some View {
            
            MetronomeSideMenuScrollView(
                selectedSound: $selectedSound,
                onValueApply: { sourceType in
                    selectedSound = sourceType
                    print("onValueApply:\(sourceType)")
                },
                onValueCommit: {
                    print("onValueCommit:")
                }
            )

        }
    }
    return PreviewWrapper()
}
