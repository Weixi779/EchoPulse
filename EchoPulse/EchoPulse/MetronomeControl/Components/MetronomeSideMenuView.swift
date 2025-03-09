//
//  MetronomeSideMenuView.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/9.
//

import SwiftUI

struct MetronomeSideMenuView: View {
    @Binding var isShowMenu: Bool
//    @Binding var selectedSound: MetronomeSourceType
    
    var body: some View {
        ZStack {
            if isShowMenu {
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowMenu.toggle()
                        }
                    }
                
                HStack {
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .foregroundStyle(.white)
                            .ignoresSafeArea()
                        
                        VStack {
                            ScrollView {
                                ForEach(MetronomeSourceType.allCases) { source in
                                    Text(source.fileName)
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    .frame(maxWidth: 250)
                }
                .transition(.move(edge: .trailing))
            }
        }
    }
}

#Preview {
    MetronomeSideMenuView(isShowMenu: .constant(true))
}
