//
//  Rotation3DXOffsetYEffect.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/22/22.
//

import SwiftUI

/// A GeometryEffect that animates rotation in 3D along the x-axis of rotation while simultaneously moving the view vertically, along the
/// y-axis. This allows, for example, a playing card to rotate from a deck, rotated with perspective to look like it's on a table, and move
/// to a tableau with no 3D rotation, floating up, say, to the tableau as it is dealt.
struct Rotation3DXOffsetYEffect: GeometryEffect {
    var rotationDegrees: Double
    var offset: CGFloat
    
    var animatableData: AnimatablePair<Double, CGFloat> {
        get {AnimatablePair(rotationDegrees, offset)}
        set {
            rotationDegrees = newValue.first
            offset = newValue.second
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let rotationRadians = CGFloat(Angle(degrees: rotationDegrees).radians)
        var transform3d = CATransform3DIdentity
        
        transform3d.m34 = -1/500 // vanishing point
        
        /// Because the vanishing point was centered along the origin of the object, it sighted down the left edge. To counteract
        /// this, it was necessary to create three transforms: one to translate it by half its width to the left, a second to do the rotation,
        /// and a third to translate it back to its original origin. These had to be concatenated, not applied sequentially, for reasons
        /// I have yet to research.
        let translatedTransform = CATransform3DMakeTranslation(size.width / -2, 0, 0)
        let rotatedTransform = CATransform3DRotate(transform3d, rotationRadians, 1, 0, 0)
        let translateBackTransform = CATransform3DMakeTranslation(size.width / 2, 0, 0)
        
        transform3d = CATransform3DConcat(CATransform3DConcat( translatedTransform, rotatedTransform), translateBackTransform)
        
        transform3d = CATransform3DTranslate(transform3d, 0, offset, 0)
        return ProjectionTransform(transform3d)
    }
}

public extension View {
    /// Allows for the rotation of a View in 3D along the x-axis of rotation while simultaneously moving vertically, along the y-axis
    /// - Parameters:
    ///   - degrees: The angle of rotation along the x-axis
    ///   - yOffset: The amount to move vertically
    /// - Returns: a View, rotated and offset vertically
    func rotate3DX(degrees: Double, yOffset: CGFloat) -> some View {
        modifier(Rotation3DXOffsetYEffect(rotationDegrees: degrees, offset: yOffset))
    }
}
