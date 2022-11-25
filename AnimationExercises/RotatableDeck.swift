//
//  RotatableDeck.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/25/22.
//

import SwiftUI

struct RotatableDeck {
    let cards: Array<RotatableCard>
    let dealNumber: Int
    
    
    /// Answers an animation for an individual card, the delay of the animation varying, depending on where the card is in the deck
    /// - Parameters:
    ///   - cardIndex: the position of the card within the deck
    /// - Returns: a spring Animation, delayed according to the card's position.
    private func dealAnimation(for cardIndex: Int) -> Animation {
        // TODO: - Fix Delay
        // It's not the cardIndex that should determine the delay, but where the card
        // is within the number to be dealt at a time
        
        let delay = Double(cardIndex) * CardConstants.cumulativeDealDelay
        return Animation.spring(response: 1, dampingFraction: 1, blendDuration: 1).delay(delay)
    }
    
    mutating func deal() {
        
    }
}
