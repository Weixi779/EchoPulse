//
//  MetronomeSideMenuView.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/9.
//

import SwiftUI

struct MetronomeSideMenuView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.schemeStyle) var schemeStyle
    
    @Binding var viewModel: MetronomeControlViewModel
    @Binding var isShowMenu: Bool
    
    var body: some View {
        ZStack {
            if isShowMenu {
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowMenu = false
                        }
                    }
                
                HStack {
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .foregroundStyle(schemeStyle.styleGradient(isDarkMode: colorScheme.isDarkMode))
                            .ignoresSafeArea()
                        
                        MetronomeSideMenuScrollView(
                            selectedSound: $viewModel.sourceTypeDataSource.value,
                            onValueApply: { newValue in
                                withAnimation {
                                    viewModel.sourceTypeDataSource.applyValue(newValue)
                                }
                            },
                            onValueCommit: {
                                viewModel.sourceTypeDataSource.commitValue()
                            }
                        )
                    }
                    .frame(maxWidth: 250)
                }
                .transition(.move(edge: .trailing))
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var selectedSound: MetronomeSourceType = .bassDrum
        @State var viewModel: MetronomeControlViewModel = .init()
        
        var body: some View {
            MetronomeSideMenuView(
                viewModel: $viewModel,
                isShowMenu: .constant(true)
            )
        }
    }
    return PreviewWrapper()
}
