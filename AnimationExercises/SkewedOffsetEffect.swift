//
//  SkewedOffsetEffect.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/22/22. Taken from SwiftUILab
//  https://swiftui-lab.com/swiftui-animations-part2/
//

import SwiftUI

/// Creates an animatable GeometryEffect that will skew a View moving to the right or left as it moves, modifying the skew
/// so that it increases at the begining of the movement and decreases at the end.
struct SkewedOffsetEffect: GeometryEffect {
    var offset: CGFloat
    var percent: CGFloat
    var goingRight: Bool
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(offset, percent) }
        set {
            offset = newValue.first
            percent = newValue.second
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        var skew: CGFloat
        
        let fullSkew = 0.5 * (goingRight ? -1 : 1)
        
        if percent < 0.2 {
            skew = percent * 5 * fullSkew
        } else if percent > 0.8 {
            skew = (1 - percent) * 5 * fullSkew
        } else {
            skew = fullSkew
        }
        
        return ProjectionTransform(
            CGAffineTransform(a: 1, b: 0, c: skew, d: 1, tx: offset, ty: 0)
        )
    }
}
