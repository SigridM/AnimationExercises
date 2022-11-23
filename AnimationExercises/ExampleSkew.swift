//
//  ExampleSkew.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/22/22.
//

import SwiftUI

struct LabelViewSkew: View {
    let text: String
    var offset: CGFloat
    var percent: CGFloat
    let backgroundColor: Color
    
    var body: some View {
        Text(text)
            .font(.headline)
            .padding(.vertical, 40)
            .padding(.horizontal, 5)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(backgroundColor)
            )
            .foregroundColor(.black)
            .modifier(SkewedOffsetEffect(offset: offset, percent: percent, goingRight: offset > 0))
    }
}

struct ExampleSkew: View {
    @State private var moveIt = true
    
    var body: some View {
        VStack {
            LabelViewSkew(
                text: "Hello World",
                offset: moveIt ? 120: -120,
                percent: moveIt ? 1 : 0,
                backgroundColor: .red
            )
            .animation(.easeInOut(duration: 1.0), value: moveIt)
            
            Button(
                action: {self.moveIt.toggle()},
                label: {Text("Animate")}
            )
        }
        .onTapGesture {
            self.moveIt.toggle()
        }
        
    }
}
