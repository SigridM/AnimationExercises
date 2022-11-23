//
//  ExampleRotateOffsetTransitionMatched1.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/23/22.
//

import SwiftUI

struct CardSimulator1: View {
    let text: String
    let backgroundColor: Color
    let namespace: Namespace.ID
    let isDealt: Bool
    let change: () -> ()

    var transition: AnyTransition {
        if isDealt {
            return
                .unrotate3DXTransition(fullRotation: CardConstants.initialRotation)
                .combined(with: .move(edge: .bottom))
        } else {
            return
                .rotate3DXTransition(fullRotation: CardConstants.initialRotation)
                .combined(with: .move(edge: .top))
        }
    }
    
    var body: some View {
        VStack {
            if !isDealt {
                Spacer()
            }
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
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 2.0)) {
                        change()
                    }
                }
                .matchedGeometryEffect(id: text, in: namespace)
            if isDealt {
                Spacer()
            }
        }
        .transition(transition)
    }
}


/// Shows how adding and removing a LabelViewRotateTransition with a custom .rotate3DXTransition works.
struct ExampleRotateOffsetTransitionMatched1: View {
    @State private var dealt = false
    @Namespace private var dealingNamepace
    
    var body: some View {
        ZStack {
            VStack {
                if dealt {
                    CardSimulator1(text: "Hello World", backgroundColor: .cyan, namespace: dealingNamepace, isDealt: true) {
                        dealt = false
                    }
                }
            }
//            .frame(maxWidth: .infinity)
//            .background(.pink)
            VStack {
                if !dealt {
                    CardSimulator1(text: "Hello World", backgroundColor: .purple, namespace: dealingNamepace, isDealt: false) {
                        dealt = true
                    }
                }
            }
//            .frame(maxWidth: .infinity)
//            .background(.orange)
        }
    }
}

