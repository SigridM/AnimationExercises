//
//  ContentView.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/7/22.
//

import SwiftUI

struct ContentView: View {
    
    @Namespace private var switchingNamespace
    @State private var useExample = true
    
    /// The set of cards that have currently been dealt onto the tableau
    @State private var tableau = Set<Int>()
    
    @ViewBuilder
    /// Answers a simulation of a numbered card: i.e., a rounded rectangle with a number on it. This allows us to see
    /// where the cards are on the stack, and where they end up on the tableau. By setting each card's matchedGeometryEffect
    /// to its number, anycard in the deck can be affiliated with the same card on the tableau and their size and position will transform
    /// during transition animation.
    /// - Parameter index: Where the card is in the stack
    /// - Returns: a View encompasing both the rectangle background and the numbered-text foreground
    func card(numbered index: Int, tiltAngle degrees: CGFloat, moveAmount: CGFloat, isSource: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
                .foregroundColor(CardConstants.cardColor)
                .frame(width: CardConstants.cardWidth, height: CardConstants.cardHeight)
                .shadow(radius: CardConstants.shadowRadius,
                        x: CardConstants.shadowOffset,
                        y: CardConstants.shadowOffset)
            Text("\(index + 1)")
                .font(CardConstants.cardFont)
                .foregroundColor(CardConstants.textColor)
                .frame(width: CardConstants.cardWidth,
                       height: CardConstants.cardHeight,
                       alignment: CardConstants.textAlignment)

        }
        .zIndex(Double(index) * -1)
        .matchedGeometryEffect(id: index, in: switchingNamespace)

    }
    
    
    /// Create the main body of the view as a ZStack, sometimes showing the deck of undealt cards, sometimes showing
    /// the tableau of dealt cards. Any tap on this ZStack will toggle between the two states.
    var body: some View {
        if useExample {
            ExampleRotateOffsetTransitionMatchedGrid()
        } else {
            ZStack {
                //            if tableau.count > 0 {
                // show the dealt cards as a LazyVGrid, pushed to the top of the available space
                // with a Spacer at the bottom
                VStack {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: CardConstants.cardWidth))]) {
                        ForEach(0..<CardConstants.totalCards, id: \.self) { index in
                            // only show the card in the LazyVGrid if it has been dealt
                            if isDealt(index) {
                                card(numbered: index, tiltAngle: 0.0, moveAmount: 0.0, isSource: true)
                                    .transition(.rotate3DXTransition(fullRotation: 70).combined(with: .move(edge: .bottom)))
                            } else {
                                Color.clear
                            }
                        }
                    }
                    Spacer()
                }
                //            } else {
                // show the deck of undealt cards, pushed to the bottom of the available space
                // with a Spacer at the top. Make sure it takes up all the available width, or
                // the cards will "float" sideways during the deal
                VStack {
                    Spacer()
                    deck
                }
                //                .frame(maxWidth: .infinity)
                //            }
            }
            .padding() // push the whole ZStack slightly away from the edges of the screen
            .onTapGesture {
                if tableau.count < CardConstants.totalCards { //all are not yet dealt; deal one, with animation
                    withAnimation(dealAnimation(for: tableau.count))  {
                        deal(tableau.count)
                    }
                    
                } else { // one or more are dealt; put the cards back into the deck,
                         // taking them off the tableau
                    withAnimation {
                        reset()
                    }
                }
            }
            //                .background(.pink) // show the background (for debugging purposes)
        }

    }
    
    /// Calculates the current 3-D rotation of the entire view, based on the number of cards dealt. If none have been dealt, the entire
    /// view is roatated to its initial 3-D rotation. If all are dealt, the rotation will be zero (unrotated). If we're somewhere in between
    /// those two extremes, the rotation will also be between the two extremes.
    private var currentRotation: Double {
        CardConstants.initialRotation -
        (CardConstants.initialRotation / Double(CardConstants.totalCards) * Double(tableau.count))
    }
    
    /// Calculates a view of the cards as a deck, stacked vertically
    private var deck: some View {
        ZStack {
            ForEach(0..<CardConstants.totalCards, id: \.self) { index in
                let tilt = isDealt(index) ? 0.0 : 70.0
                let offset = isDealt(index) ? -400.0 : 0.0
                card(numbered: index, tiltAngle: tilt, moveAmount: offset, isSource: true)
                    .verticallyStacked(at: Double(index), in: Double(CardConstants.totalCards))
                    .transition(.rotate3DXTransition(fullRotation: 70).combined(with: .move(edge: .bottom)))

            }
        }
    }
    
    /// Answers an animation for an individual card, the delay of the animation varying, depending on where the card is in the deck
    /// - Parameters:
    ///   - cardIndex: the position of the card within the deck
    /// - Returns: a spring Animation, delayed according to the card's position.
    private func dealAnimation(for cardIndex: Int) -> Animation {
//        let delay = Double(cardIndex) * CardConstants.cumulativeDealDelay
        var delay: Double
        
        if cardIndex % 2 == 0 {
            delay = 2.0
        } else {
            delay = 0.0
        }
        return Animation.spring(response: 1, dampingFraction: 1, blendDuration: 1).delay(delay)
    }
    
    /// Record that the card numbered index has been moved from the deck to the tableau
    /// - Parameter index: the position of the card in the deck
    private func deal(_ index: Int) {
        tableau.insert(index)
    }
    
    /// Answers a Boolean: whether the card at the position index has been moved from the deck to the tableau
    /// - Parameter index: the position of the card in the deck
    /// - Returns: a Bool: true if the card with that index is on the tableau, not in the deck
    private func isDealt(_ index: Int) -> Bool {
        tableau.contains(index)
    }
    
    /// Moves all the cards back into the deck and off the tableau.
    private func reset() {
        tableau = []
    }
    
}

