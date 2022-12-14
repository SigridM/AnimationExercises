//
//  ExampleRotateOffsetTransitionMatched.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/23/22.
//

import SwiftUI

struct LabelViewRotateTransitionMatched: View {
    let text: String
    let backgroundColor: Color
    var namespace: Namespace.ID
    
    
    var body: some View {
        VStack {
            Spacer()  // this allows the card to move farther up, with the transition on the
                      // entire VStack
            
            CardSimulator(text: text, backgroundColor: backgroundColor)
                .matchedGeometryEffect(id: "card", in: namespace)

        }
        .transition(.rotate3DXTransition(fullRotation: 70).combined(with: .move(edge: .top)))
    }
}

struct LabelViewUnrotateTransitionMatched: View {
    let text: String
    let backgroundColor: Color
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            CardSimulator(text: text, backgroundColor: backgroundColor)
                .matchedGeometryEffect(id: "card", in: namespace)
            Spacer()  // this allows the card to move farther down, with the transition on the
                      // entire VStack
            
        }
        .transition(.unrotate3DXTransition(fullRotation: 70).combined(with: .move(edge: .bottom)))
    }
}

struct CardSimulator: View {
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
    }
}


/// Shows how adding and removing a LabelViewRotateTransition with a custom .rotate3DXTransition works.
struct ExampleRotateOffsetTransitionMatched: View {
    @State private var dealt = false
    @Namespace private var dealingNamepace
    
    var body: some View {
        ZStack {
            VStack {
                if dealt {
                    LabelViewUnrotateTransitionMatched(
                        text: "Hello World",
                        backgroundColor: .cyan,
                        namespace: dealingNamepace
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 2.0)) {
                            dealt = false
                        }
                        
                    }
                }
            }
            VStack {
                if !dealt {
                    LabelViewRotateTransitionMatched(
                        text: "Hello World",
                        backgroundColor: .purple,
                        namespace: dealingNamepace
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 2.0)) {
                            dealt = true
                        }
                    }
                }
            }

        }
    }
}

