//
//  ContentView.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/7/22.
//

import SwiftUI

extension View {
    /// Wraps offsets around the content so that it appears vertically stacked. Includes a zIndex so that the view at the "top" of the
    /// stack -- the lowest position -- will continue to appear at the top of the stack if the entire stack is embedded in a ZStack
    /// - Parameters:
    ///   - position: the location of the view within the stack. Lower numbers are at the top of the stack.
    ///   - total: the size of the entire stack of views,
    ///   - spacing: the distance between the views in the stack; defaulting to 5
    /// - Returns: a View, modified with offsets and zIndex set
    func verticallyStacked(at position: Double, in total: Double, spacing: Double = 5) -> some View {
        modifier(VerticallyStacked(position: position, total: total, spacing: spacing))
    }
}

/// A ViewModifier that sets the offset and zIndex of a view within a total number of views so as to make them appear vertically stacked
/// in physical space.
struct VerticallyStacked: ViewModifier {
    /// The location of the view within the stack. Lower numbers are closer to the top of the stack.
    var position: Double
    /// The total number of views in the stack. This allows a calculation to make sure that the offset goes *up*; i.e., views do not go
    /// farther and farther down the screen the more you have in the stack. Also used, *negated* for the zIndex so the zIndex gets
    /// farther from the user the higher the position.
    var total: Double
    /// The distance between the views in the stack; defaulting to 5.
    var spacing: Double = 5
    
    /// Modifies the content view to be offset and stacked within a total number of views in the stack
    /// - Parameter content: the single View being stacked
    /// - Returns: the modified View, offset to appear stacked within a group of views.
    func body(content: Content) -> some View {
        //        let offset = Double(total - position)

        let offset = Double(position - total)
        content
            .offset(x: 0, y: offset * spacing)
            .zIndex(position * -1)
    }
}

struct Rotation3DModifier: AnimatableModifier {
    var value: Double
    let direction: Double
    
    var animatableData: Double {
        get {value}
        set {value = newValue}
    }
    
    func body(content: Content) -> some View {
        let degrees = Angle(degrees: 70 * value * direction)
        return content
            .rotation3DEffect(degrees, axis: (x: 1, y: 0, z: 0))
    }
}

extension AnyTransition {
    static func horizontalRotation(direction: Double) -> AnyTransition {
        AnyTransition.modifier(
            active: Rotation3DModifier(value: 1, direction: direction),
            identity: Rotation3DModifier(value: 0, direction: direction)
        )
    }
}

/// A struct for encapsulating the constants in this Animation
struct CardConstants {
    static let aspectRatio = 2.0/3.0
    static let cardHeight = 90.0
    static let cardWidth = cardHeight*aspectRatio
    
    static let shadowRadius = 1.0
    static let shadowOffset = 2.0
    
    static let cardColor = Color(.yellow)
    static let textColor = Color(.black)
    
    static let cornerRadius = 10.0
    static let cardFont = Font.title
    static let textAlignment = Alignment.center
    
    static let totalCards = 10
    
    static let initialRotation = 70.0
    
    static private let totalDealTime = 2.0
    static let cumulativeDealDelay = totalDealTime / Double(totalCards)
}

struct RotatableCard: View {
    let number: Int
    var tiltAngle: CGFloat
    var moveAmount: CGFloat
    @Namespace var theNamespace
    
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
        .cardRotationOffset(degrees: tiltAngle, offset: moveAmount)
        .animation(.easeInOut, value: tiltAngle)
//        .matchedGeometryEffect(id: "card\(number)", in: theNamespace)

    }
}

struct ContentView: View {
    
    @Namespace private var switchingNamespace
    
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
//        .transition(.identity)// takes away any default fade-ins/outs, since we want
        // to use the matchedGeometryEffect for the transitions
//        .transition(AnyTransition.horizontalRotation.combined(with: AnyTransition.move(edge: .top)))
//        .cardRotation(degrees: degrees)
        .matchedGeometryEffect(id: "card\(index)", in: switchingNamespace, isSource: isSource)
        .cardRotationOffset(degrees: degrees, offset: moveAmount)
        .animation(.easeInOut(duration: 1.0), value: moveAmount)
//        .animation(nil, value: degrees)
    }
    
    
    /// Create the main body of the view as a ZStack, sometimes showing the deck of undealt cards, sometimes showing
    /// the tableau of dealt cards. Any tap on this ZStack will toggle between the two states.
    var body: some View {
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
//                                    .rotation3DEffect(.degrees(0), axis: (x: 1, y: 0, z: 0))
//                                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                                    .transition(.horizontalRotation(direction: 0).combined(with: .move(edge: .bottom)))
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
        // rotate the entire view based on the number of cards that have been dealt
//        .rotation3DEffect(Angle.degrees(currentRotation), axis: (x: 1, y: 0, z: 0))

//        .rotation3DEffect(Angle.degrees(dealt.count == 0 ? 0 : 0 ), axis: (x: 1, y: 0, z: 0))
//        .rotation3DEffect(Angle.degrees(dealt.count == 0 ? 70 : 0 ), axis: (x: 1, y: 0, z: 0))

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
                    .opacity(isDealt(index) ? 0 : 1)
                    .animation(nil, value: 1)
                    .verticallyStacked(at: Double(index), in: Double(CardConstants.totalCards))
                    .transition(.horizontalRotation(direction: 1).combined(with: .move(edge: .bottom)))

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
