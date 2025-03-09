//
//  MetronomeSoundPickerHeader.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/9.
//

import SwiftUI

struct MetronomeSoundPickerHeader: View {
    @Binding var isShowMenu: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    withAnimation {
                        self.isShowMenu.toggle()
                    }
                } label: {
                    Image(systemName: "music.note.list")
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.red, .blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .font(.title)
                }
            }
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    MetronomeSoundPickerHeader(isShowMenu: .constant(false))
}
