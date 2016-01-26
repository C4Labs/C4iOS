// Copyright © 2015 C4
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import QuartzCore

/// Extension for CAShapeLayer that allows overriding the actions for specific properties.
public class C4ShapeLayer: CAShapeLayer {
    /// A boolean value that, when true, prevents the animation of a shape's properties.
    ///
    /// ````
    /// C4ShapeLayer.disableActions = true
    /// circle.fillColor = red
    /// C4ShapeLayer.disableActions = false
    ///
    /// This value can be set globally, after which changes to any shape's properties will be immediate.
    public static var disableActions = true

    ///  This method searches for the given action object of the layer. Actions define dynamic behaviors for a layer. For example, the animatable properties of a layer typically have corresponding action objects to initiate the actual animations. When that property changes, the layer looks for the action object associated with the property name and executes it. You can also associate custom action objects with your layer to implement app-specific actions.
    ///
    ///  - parameter key: The identifier of the action.
    ///
    ///  - returns: the action object assigned to the specified key.
    public override func actionForKey(key: String) -> CAAction? {
        if C4ShapeLayer.disableActions == true {
            return nil
        }

        let animatableProperties = ["lineWidth", "strokeEnd", "strokeStart", "strokeColor", "path", "fillColor", "lineDashPhase", "contents"]
        if !animatableProperties.contains(key) {
            return super.actionForKey(key)
        }

        if let viewAnimation = C4ViewAnimation.stack.last as? C4ViewAnimation where viewAnimation.spring != nil {
            let animation = CASpringAnimation(keyPath: key)
            animation.configureOptions()
            animation.fromValue = valueForKey(key)
            return CASpringAnimation(keyPath: key)
        }

        let animation: CABasicAnimation
        animation = CABasicAnimation(keyPath: key)
        animation.configureOptions()
        animation.fromValue = valueForKey(key)
        return animation
    }
}

extension CABasicAnimation {
    ///  Configures basic options for a CABasicAnimation.
    ///
    ///  The options set in this method are favorable for the inner workings of C4's action behaviours.
    public func configureOptions() {
        if let animation = C4ViewAnimation.currentAnimation {
            self.autoreverses = animation.autoreverses
            self.repeatCount = Float(animation.repeatCount)
        }
        self.fillMode = kCAFillModeBoth
        self.removedOnCompletion = false
    }
}

extension CASpringAnimation {
    ///  Configures basic options for a CABasicAnimation.
    ///
    ///  The options set in this method are favorable for the inner workings of C4's animation behaviours.
    public override func configureOptions() {
        super.configureOptions()
        if let animation = C4ViewAnimation.currentAnimation as? C4ViewAnimation, spring = animation.spring {
            mass = CGFloat(spring.mass)
            damping = CGFloat(spring.damping)
            stiffness = CGFloat(spring.stiffness)
            initialVelocity = CGFloat(spring.initialVelocity)
        }
    }
}
