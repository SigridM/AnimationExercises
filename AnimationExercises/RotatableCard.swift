//
//  RotatableCard.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/22/22.
//

import SwiftUI

struct RotatableCard: View {
    let number: Int
    var tiltAngle: CGFloat
    var moveAmount: CGFloat
    var theNamespace: Namespace.ID
    
    var body: some View {
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
        .rotate3DX(degrees: tiltAngle, yOffset: moveAmount)
        .animation(.easeInOut, value: tiltAngle)
        .matchedGeometryEffect(id: "card\(number)", in: theNamespace)
        
    }
}
