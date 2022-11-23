//
//  ExampleRotateOffsetTransition.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/22/22.
//

import SwiftUI

//
//  ExampleRotateOffset.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/22/22.
//

import SwiftUI

struct LabelViewRotateTransition: View {
    let text: String
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
            .transition(.rotate3DXTransition(fullRotation: 70).combined(with: .move(edge: .top)))
    }
}



/// Shows how adding and removing a LabelViewRotateTransition with a custom .rotate3DXTransition works.
struct ExampleRotateOffsetTransition: View {
    @State private var undealt = true
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                if undealt {
                    LabelViewRotateTransition(
                        text: "Hello World",
                        backgroundColor: .purple
                    )
                }
                Button(
                    action: {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            undealt.toggle()
                        }
                    })
                {
                    Text(undealt ? "Deal Card" : "Reset")
                }
            }
            Spacer()
        }
    }
}

