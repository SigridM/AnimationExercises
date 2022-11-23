//
//  VerticallyStackedModifier.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/22/22.
//

import SwiftUI

/// A ViewModifier that sets the offset and zIndex of a view within a total number of views so as to make them appear vertically stacked
/// in physical space.
struct VerticallyStackedModifier: ViewModifier {
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

extension View {
    /// Wraps offsets around the content so that it appears vertically stacked. Includes a zIndex so that the view at the "top" of the
    /// stack -- the lowest position -- will continue to appear at the top of the stack if the entire stack is embedded in a ZStack
    /// - Parameters:
    ///   - position: the location of the view within the stack. Lower numbers are at the top of the stack.
    ///   - total: the size of the entire stack of views,
    ///   - spacing: the distance between the views in the stack; defaulting to 5
    /// - Returns: a View, modified with offsets and zIndex set
    func verticallyStacked(at position: Double, in total: Double, spacing: Double = 5) -> some View {
        modifier(VerticallyStackedModifier(position: position, total: total, spacing: spacing))
    }
}

