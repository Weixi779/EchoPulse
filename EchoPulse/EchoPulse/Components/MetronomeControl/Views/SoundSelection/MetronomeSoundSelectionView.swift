//
//  MetronomeSoundSelectionView.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/21.
//

import SwiftUI

struct MetronomeSoundSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.schemeStyle) var schemeStyle
    
    var dataSource: SourceTypeDataSource
    
    private let sources = MetronomeSoundType.allCases
    
    var body: some View {
        ZStack {
            backgroundLayer
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 16) {
                        soundCategorySection(title: "传统声音",
                                            sources: [.mechHigh, .mechLow])
                        
                        soundCategorySection(title: "打击乐器",
                                            sources: [.bassDrum, .hiHat, .rimshot, .jackSlap])
                        
                        soundCategorySection(title: "特殊效果",
                                            sources: [.cowbell, .laugh])
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                
                footerView
            }
            .padding(.vertical)
        }
        .navigationTitle("节拍器音效")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("完成") {
                    dismiss()
                }
            }
        }
    }
    
    private var backgroundLayer: some View {
        ZStack {
            TimelineView(.animation) { timeline in
                Rectangle()
                    .fill(
                        schemeStyle.animatedStyleGradient(
                            for: timeline.date,
                            isDarkMode: colorScheme.isDarkMode
                        )
                    )
            }
            
            Rectangle()
                .fill(.ultraThinMaterial)
        }
        .ignoresSafeArea()
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("节拍器音效")
                .font(.title2.bold())
                .padding(.top, 8)
            
            Text("选择适合您演奏风格的音效")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.bottom, 16)
    }
    
    private func soundCategorySection(title: String, sources: [MetronomeSoundType]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.leading, 8)
                .padding(.top, 4)
            
            VStack(spacing: 2) {
                ForEach(sources) { source in
                    MetronomeSoundSelectionCell(
                        source: source,
                        isSelected: dataSource.value == source,
                        height: 60
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            dataSource.applyValue(source)
                            dataSource.commitValue()
                        }
                    }
                }
            }
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        }
    }
    
    private var footerView: some View {
        Text("选择不同的声音会改变节拍器的音色。每种音效都有各自的特点和适用场景。")
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
    }
}
