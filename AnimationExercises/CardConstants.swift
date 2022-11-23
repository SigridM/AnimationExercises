//
//  CardConstants.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/22/22.
//

import SwiftUI

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
