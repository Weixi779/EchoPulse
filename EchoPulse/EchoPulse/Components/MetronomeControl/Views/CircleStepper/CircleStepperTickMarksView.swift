//
//  CircleStepperTickMarksView.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/21.
//

import Foundation
import SwiftUI

struct CircleStepperTickMarksView: View {
    var radius: CGFloat
    var tickMarkLength: CGFloat = 5
    var tickMarkWidth: CGFloat = 1.5
    var tickMarkNumber: Int = 50
    
    let primaryColor: Color = Color.primary
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(primaryColor.opacity(0.35), lineWidth: 1)
                .shadow(color: primaryColor.opacity(0.15), radius: 3, x: 0, y: 0)
            
            ForEach(0..<tickMarkNumber, id: \.self) { index in
                let angle = Double(index) * (360.0 / Double(tickMarkNumber))
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: ColorConfigs.freshGreens),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: tickMarkWidth, height: tickMarkLength)
                    .offset(y: -(radius - 2) + tickMarkLength / 2)
                    .rotationEffect(.degrees(angle))
            }
            
            let innerRadius = radius - tickMarkLength - 4
            
            Circle()
                .stroke(primaryColor.opacity(0.2), lineWidth: 1)
                .shadow(color: primaryColor.opacity(0.15), radius: 3, x: 0, y: 0)
                .frame(width: innerRadius * 2, height: innerRadius * 2)
        }
        .frame(width: radius * 2, height: radius * 2)
    }
}

#Preview {
    CircleStepperTickMarksView(radius: 25)
}
