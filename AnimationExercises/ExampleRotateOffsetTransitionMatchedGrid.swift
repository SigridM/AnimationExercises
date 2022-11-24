//
//  ExampleRotateOffsetTransitionMatchedGrid.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/24/22.
//

import SwiftUI

struct CardSimulatorGrid: View {
    let text: String
    let backgroundColor: Color
    let namespace: Namespace.ID
    let isDealt: Bool
    let change: () -> ()
    
    var transition: AnyTransition {
        if isDealt {
            return
                .unrotate3DXTransition(fullRotation: CardConstants.initialRotation)

        } else {
            return
                .rotate3DXTransition(fullRotation: CardConstants.initialRotation)
//                .combined(
//                    with:.move(edge: .top)
//                )
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
                    withAnimation(.spring(response: 1, dampingFraction: 1, blendDuration: 1)) {
                        change()
                    }
                }
                .matchedGeometryEffect(id: text, in: namespace)
//            if isDealt {
//                Spacer()
//            }
        }
        //        .background(.yellow)
        .transition(transition)
    }
}

struct ExampleRotateOffsetTransitionMatchedGrid: View {
    @State private var dealt = false
    @Namespace private var dealingNamepace
    @State private var cardNum = 0
    
    var body: some View {
        ZStack {
            VStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: CardConstants.cardWidth))]) {
                    ForEach(0..<CardConstants.totalCards, id: \.self) { index in
                        if index == cardNum {
                            if dealt {
                                VStack {
                                    CardSimulatorGrid(
                                        text: "Hello World",
                                        backgroundColor: .purple,
                                        namespace: dealingNamepace,
                                        isDealt: true
                                    ) {
                                        dealt = false
                                    }
                                }
                            } else {
                                Color.clear
                            }
                        } else {
                            Color.yellow
                        }
                    }
                }
                .padding()
                Spacer()
            }
            VStack {
                if !dealt {
                    CardSimulatorGrid(
                        text: "Hello World",
                        backgroundColor: .purple,
                        namespace: dealingNamepace,
                        isDealt: false
                    ) {
                        dealt = true
                        cardNum = (cardNum + 1) % CardConstants.totalCards
                    }
                }
            }
//                        .frame(maxWidth: .infinity)
//                        .background(.orange)
        }
    }
}

