//
//  Rotation3DXModifier.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/22/22.
//

import SwiftUI

// TODO: - Figure out parameters
/// This needs work. I'm not sure I understand the difference between "value" and "direction." I seem to be using both to do
/// the same thing!
///
/// Attempts to create an animatable modifier that changes the 3D rotation along the x-axis of rotation to be used in a custom
/// transition.
struct Rotation3DXModifier: AnimatableModifier {
    /// How rotated the View is, between 0 and 1: 0 being not rotated, and 1 being fully rotated
    var value: Double
    let fullRotation: Double
    
    var animatableData: Double {
        get {value}
        set {value = newValue}
    }
    
    func body(content: Content) -> some View {
        let degrees = Angle(degrees: fullRotation * value)
        return content
//            .rotation3DEffect(degrees, axis: (x: 1, y: 0, z: 0), anchor: UnitPoint(x: 0.5, y: 0.9))
            .rotation3DEffect(degrees, axis: (x: 1, y: 0, z: 0))

    }
}

extension AnyTransition {
    
    /// Let us remind, what the transition is:
    /// Transition is an animation that might be triggered when some View is being added to or removed from the View hierarchy
    /// IOW: it's not just any animation, but an animation specific to adding and removing views.
    /// (In practice, the change in the view hierarchy can usually come from the conditional statements.)
    /// By default, transitions are fade in/fade out.
    /// The built-in transtions are:
    ///     .scale
    ///     .move
    ///     .offset
    ///     .slide
    ///     .opacity (default)
    /// Can combine transitions using .combine(with:)
    static func rotate3DXTransition(fullRotation: Double) -> AnyTransition {
        /// Identity is applied when the view is fully inserted in the view hierarchy, and active when the view is gone.
        /// When the view disappears, we want it to be unrotated
        /// Put another way: When a view isn't transitioning, the identity modifier is applied. When a view is removed,
        /// the animation interpolates in between the identity modifier and the active modifier before removing the view completely.
        /// Likewise, when a view is inserted it starts out with the active modifier at the start of the animation,
        /// and ends with the identity modifier at the end of the animation.
        AnyTransition.modifier(
            active: Rotation3DXModifier(value: 0, fullRotation: fullRotation),
            identity: Rotation3DXModifier(value: 1, fullRotation: fullRotation)
        )
    }
}
