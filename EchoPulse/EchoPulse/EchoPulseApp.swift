//
//  EchoPulseApp.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import SwiftUI

@main
struct EchoPulseApp: App {
    let schemeStyle = SchemeStyle()
    
    var body: some Scene {
        WindowGroup {
            EchoPulseView()
                .environment(\.schemeStyle, schemeStyle)
        }
    }
}
