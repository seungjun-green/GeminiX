//
//  OtherViews.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import Foundation
import SwiftUI


struct RoundedBorderModifier: ViewModifier {
    var color: Color
    var lineWidth: CGFloat
    var cornerRadius: CGFloat
    
    init(color: Color, lineWidth: CGFloat, cornerRadius: CGFloat) {
        self.color = color
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
}

extension View {
    func roundedBorder(color: Color, lineWidth: CGFloat, cornerRadius: CGFloat) -> some View {
        modifier(RoundedBorderModifier(color: color, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
}


struct TitleView: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
        }
        .padding(.horizontal)
    }
}


struct GeminiMessage: Codable, Identifiable, Hashable {
    var id = UUID()
    var date = Date()
    var user: String
    var message: String
}

