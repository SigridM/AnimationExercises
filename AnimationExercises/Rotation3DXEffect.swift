//
//  Rotation3DXEffect.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/16/22.
//

import SwiftUI

/// A GeometryEffect that animates rotation in 3D along the x-axis of rotation by the given number of degrees.
struct Rotation3DXEffect: GeometryEffect {
    var rotationDegrees: Double
    
    var animatableData: Double {
        get {rotationDegrees}
        set {rotationDegrees = newValue}
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let rotationRadians = CGFloat(Angle(degrees: rotationDegrees).radians)
        
        var transform3d = CATransform3DIdentity
        transform3d.m34 = -1/500 // vanishing point
        
        transform3d = CATransform3DRotate(transform3d, rotationRadians, 1, 0, 0)
        
        // may need some translations in here
        
        return ProjectionTransform(transform3d)
    }
}

public extension View {
    /// Allow rotation animation in 3D along the x-axis of roation by the given number of degrees
    /// - Parameter degrees: how many degrees to rotate the view in 3D along the x-axis of rotation
    /// - Returns: a View, modified with the Rotation3DXEffect
    func rotate3DX(degrees: Double) -> some View {
        modifier(Rotation3DXEffect(rotationDegrees: degrees))
    }
}
