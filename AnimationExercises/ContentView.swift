//
//  ContentView.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/7/22.
//

import SwiftUI

struct ContentView: View {
    
    @Namespace private var switchingNamespace
    @State private var useExample = false
    
    /// The set of cards that have currently been dealt onto the tableau
    @State private var tableau = Set<Int>()
    
    private func transition(if isDealt: Bool) -> AnyTransition {
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
    
    private func colorIf(_ animated: Bool) -> Color {
        if animated {
            return .red
        } else {
            return CardConstants.textColor
        }
    }
    
    @ViewBuilder
    /// Answers a simulation of a numbered card: i.e., a rounded rectangle with a number on it. This allows us to see
    /// where the cards are on the stack, and where they end up on the tableau. By setting each card's matchedGeometryEffect
    /// to its number, anycard in the deck can be affiliated with the same card on the tableau and their size and position will transform
    /// during transition animation.
    /// - Parameter index: Where the card is in the stack
    /// - Returns: a View encompasing both the rectangle background and the numbered-text foreground
    func card(numbered index: Int, dealt: Bool = false, change: @escaping ()->()) -> some View {
        VStack {
            if !dealt {
                Spacer()
            }
            VStack {
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
                }
                .zIndex(Double(index + 1) * -1)
                .animation(nil, value: UUID())
                .matchedGeometryEffect(id: "card\(index)", in: switchingNamespace)
                .onTapGesture {
                    change()
                }
            }
        }
        .transition(transition(if: dealt))
    }
    
    
    /// Create the main body of the view as a ZStack, sometimes showing the deck of undealt cards, sometimes showing
    /// the tableau of dealt cards. Any tap on this ZStack will toggle between the two states.
    var body: some View {
        if useExample {
            ExampleRotateOffsetTransitionMatchedGrid()
        } else {
            ZStack {
                VStack {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: CardConstants.cardWidth))]) {
                        ForEach(0..<CardConstants.totalCards, id: \.self) { index in
                            let dealt = isDealt(index)
                            // only show the card in the LazyVGrid if it has been dealt
                            if dealt {
                                VStack {
                                    card(numbered: index, dealt: true) {
                                        withAnimation() {
                                            reset()
                                        }
                                    }
                                }
                            } else {
                                Color.clear
                            }
                        }
                    }
                    Spacer()
                }
                VStack {
                    Spacer()
                    deck
                }
            }
            .padding() // push the whole ZStack slightly away from the edges of the screen
        }

    }
    
    /// Calculates a view of the cards as a deck, stacked vertically
    private var deck: some View {
        VStack {
            ZStack {
                ForEach(0..<CardConstants.totalCards, id: \.self) { index in
                    let dealt = isDealt(index)
                    if !dealt {
                        card(numbered: index, dealt: false) {
                            deal(min(index, lowestUndealtIndex()), inGroupOf: 3)
                        }
                        .verticallyStacked(at: Double(index), in: Double(CardConstants.totalCards))
                    }
                }
            }
        }
    }
    
    /// Answers an animation for an individual card, the delay of the animation varying, depending on where the card is in the deck
    /// - Parameters:
    ///   - cardIndex: the position of the card within the deck
    /// - Returns: a spring Animation, delayed according to the card's position.
    private func dealAnimation(for cardIndex: Int) -> Animation {
        let delay = (Double(cardIndex)) * CardConstants.cumulativeDealDelay
        return .spring(response: 1, dampingFraction: 0.8, blendDuration: 0.25).delay(delay)
//                return .easeInOut.delay(delay)

    }
    
    /// Record that the card numbered index has been moved from the deck to the tableau
    /// - Parameter index: the position of the card in the deck
    private func deal(_ index: Int) {
        tableau.insert(index)
    }
    
    /// Record that the card numbered index has been moved from the deck to the tableau
    /// - Parameter index: the position of the card in the deck
    private func deal(_ index: Int, inGroupOf dealSize: Int) {
        for i in index..<(index+dealSize) {
            if !isDealt(i) {
                let _ = withAnimation(dealAnimation(for: i % dealSize)) {
                    tableau.insert(i)
                }
            }
        }
    }
    
    /// Answers a Boolean: whether the card at the position index has been moved from the deck to the tableau
    /// - Parameter index: the position of the card in the deck
    /// - Returns: a Bool: true if the card with that index is on the tableau, not in the deck
    private func isDealt(_ index: Int) -> Bool {
        tableau.contains(index)
    }
    
    /// Answer the smallest index of the cards still in the deck (not on the tableau). This helps to keep us from
    /// dealing from the middle or bottom of the deck if a lower card is tapped.
    /// - Returns: an Int for the lowest card index
    private func lowestUndealtIndex() -> Int {
        if let max = tableau.max() {
            return max + 1
        }
        return 0
    }
    
    /// Moves all the cards back into the deck and off the tableau.
    private func reset() {
        tableau = []
    }
    
}

