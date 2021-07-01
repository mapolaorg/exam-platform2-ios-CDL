//
//  HorizontalRateView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import SwiftUI

struct HorizontalRateView: View {
    var progress: CGFloat
    var title: String
    var color: Color
    
    var body: some View {
        HStack {
            VStack {
                Text(title)
                    .font(.system(size: 16.scale))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                Text(String(format: "%.0f%%", min(self.progress, 1.0) * 100.0))
                    .font(.system(size: 40.scale))
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            Spacer()
            SUICircleView(progress: progress, color: color)
                .frame(width: 59.scale, height: 59.scale, alignment: .trailing)
        }
    }
}
