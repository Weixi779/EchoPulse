//
//  MetronomeSoundPickerHeader.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/9.
//

import SwiftUI

struct MetronomeSoundPickerHeader: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.schemeStyle) var schemeStyle
    
    @Binding var isShowMenu: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    withAnimation {
                        self.isShowMenu = true
                    }
                } label: {
                    Image(systemName: "music.note.list")
                        .foregroundStyle(schemeStyle.styleGradient(isDarkMode: colorScheme.isDarkMode))
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
