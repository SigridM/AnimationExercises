//
//  RotatableCard.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/22/22.
//

import SwiftUI

struct RotatableCard: View {
    let number: Int
    private(set) var theNamespace: Namespace.ID
    var isDealt: Bool
    let change: () -> ()
    
    var transition: AnyTransition {
        if isDealt {
            return
                .unrotate3DXTransition(fullRotation: CardConstants.initialRotation)
            
        } else {
            return
                .rotate3DXTransition(fullRotation: CardConstants.initialRotation)
        }
    }
    
    var body: some View {
        VStack {
            if !isDealt {
                Spacer()
            }
            ZStack {
                RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
                    .foregroundColor(CardConstants.cardColor)
                    .frame(width: CardConstants.cardWidth, height: CardConstants.cardHeight)
                    .shadow(radius: CardConstants.shadowRadius,
                            x: CardConstants.shadowOffset,
                            y: CardConstants.shadowOffset)
                Text("\(number + 1)")
                    .font(CardConstants.cardFont)
                    .foregroundColor(CardConstants.textColor)
                    .frame(width: CardConstants.cardWidth,
                           height: CardConstants.cardHeight,
                           alignment: CardConstants.textAlignment)
                
            }
            .zIndex(Double(number) * -1)
            .onTapGesture {
                withAnimation(.spring(response: 1, dampingFraction: 1, blendDuration: 1)) {
                    change()
                }
            }
            .matchedGeometryEffect(id: "card\(number)", in: theNamespace)
        }
        .transition(transition)
        
    }
}
