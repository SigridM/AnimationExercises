//
//  ExampleRotateOffset.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/22/22.
//

import SwiftUI

struct LabelViewRotateOffset: View {
    let text: String
    var tiltAngle: CGFloat
    var moveAmount: CGFloat
    let backgroundColor: Color
    
    
    var body: some View {
        Text(text)
            .font(.headline)
            .padding(.vertical, 40)
            .padding(.horizontal, 5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(backgroundColor)
                    .shadow(radius: 1, x: 2.0, y: 2.0)
            )
            .foregroundColor(.black)
            .rotate3DX(degrees: tiltAngle, yOffset: moveAmount)
    }
}



struct ExampleRotateOffset: View {
    @State private var tilted = true
    
    var body: some View {
        VStack {
            LabelViewRotateOffset(
                text: "Hello World",
                tiltAngle: tilted ? 70: 0,
                moveAmount: tilted ? 90 : -200,
                backgroundColor: .red
            )
            .animation(.easeInOut(duration: 1.0), value: tilted)
            
            Button(
                action: {self.tilted.toggle()},
                label: {Text(tilted ? "Straighten" : "Tilt")}
            )
        }
        .onTapGesture {
            self.tilted.toggle()
        }
        
    }
}
