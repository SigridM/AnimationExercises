//
//  RotationEffect.swift
//  AnimationExercises
//
//  Created by Sigrid Mortensen on 11/16/22.
//

import SwiftUI

struct RotationEffect: GeometryEffect {
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
    func cardRotation(degrees: Double) -> some View {
        modifier(RotationEffect(rotationDegrees: degrees))
    }
}

struct RotationOffset: GeometryEffect {
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

        let translatedTransform = CATransform3DMakeTranslation(size.width / -2, 0, 0)
        let rotatedTransform = CATransform3DRotate(transform3d, rotationRadians, 1, 0, 0)
        let translateBackTransform = CATransform3DMakeTranslation(size.width / 2, 0, 0)

        transform3d = CATransform3DConcat(CATransform3DConcat( translatedTransform, rotatedTransform), translateBackTransform)

        transform3d = CATransform3DTranslate(transform3d, 0, offset, 0)
        return ProjectionTransform(transform3d)
    }
}

public extension View {
    func cardRotationOffset(degrees: Double, offset: CGFloat) -> some View {
        modifier(RotationOffset(rotationDegrees: degrees, offset: offset))
    }
}

struct SkewedOffset: GeometryEffect {
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

struct LabelView: View {
    let text: String
    var offset: CGFloat
    var percent: CGFloat
    let backgroundColor: Color
    
    var body: some View {
        Text(text)
            .font(.headline)
            .padding(.vertical, 40)
            .padding(.horizontal, 5)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(backgroundColor)
            )
            .foregroundColor(.black)
            .modifier(SkewedOffset(offset: offset, percent: percent, goingRight: offset > 0))
    }
}

struct LabelViewRotate: View {
    let text: String
    var tiltAngle: CGFloat
    var moveAmount: CGFloat
    let backgroundColor: Color
    

    var body: some View {
        Text(text)
            .font(.headline)
            .padding(.vertical, 40)
            .padding(.horizontal, 5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(backgroundColor)
                    .shadow(radius: 1, x: 2.0, y: 2.0)
            )
            .foregroundColor(.black)
            .modifier(RotationOffset(rotationDegrees: tiltAngle, offset: moveAmount))
    }
}

struct ExampleSkew: View {
    @State private var moveIt = true
    
    var body: some View {
        VStack {
            LabelView(
                text: "Hello World",
                offset: moveIt ? 120: -120,
                percent: moveIt ? 1 : 0,
                backgroundColor: .red
            )
            .animation(.easeInOut(duration: 1.0), value: moveIt)
            
            Button(
                action: {self.moveIt.toggle()},
                label: {Text("Animate")}
                )
        }
        .onTapGesture {
            self.moveIt.toggle()
        }
   
    }
}

struct ExampleRotate: View {
    @State private var tilted = true
    
    var body: some View {
        VStack {
            LabelViewRotate(
                text: "Hello World",
                tiltAngle: tilted ? 70: 0,
                moveAmount: tilted ? 90 : -200,
                backgroundColor: .red
            )
            .animation(.easeInOut(duration: 1.0), value: tilted)
            
            Button(
                action: {self.tilted.toggle()},
                label: {Text(tilted ? "Straighten" : "Tilt")}
            )
        }
        .onTapGesture {
            self.tilted.toggle()
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExampleRotate()
////        ExampleSkew()
//    }
//}
