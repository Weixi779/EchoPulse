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
    
    @Binding var isShowMenu: Bool
    @Binding var selectedSound: MetronomeSourceType
    
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
                        
                        MetronomeSideMenuScrollView(selectedSound: $selectedSound)
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
        
        var body: some View {
            MetronomeSideMenuView(
                isShowMenu: .constant(true),
                selectedSound: $selectedSound
            )
        }
    }
    return PreviewWrapper()
}
