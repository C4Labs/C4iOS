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
public class ShapeLayer: CAShapeLayer {
    /// A boolean value that, when true, prevents the animation of a shape's properties.
    ///
    /// ````
    /// ShapeLayer.disableActions = true
    /// circle.fillColor = red
    /// ShapeLayer.disableActions = false
    ///
    /// This value can be set globally, after which changes to any shape's properties will be immediate.
    public static var disableActions = true

    ///  This method searches for the given action object of the layer. Actions define dynamic behaviors for a layer. For example, the animatable properties of a layer typically have corresponding action objects to initiate the actual animations. When that property changes, the layer looks for the action object associated with the property name and executes it. You can also associate custom action objects with your layer to implement app-specific actions.
    ///
    /// - parameter key: The identifier of the action.
    ///
    /// - returns: the action object assigned to the specified key.
    public override func action(forKey key: String) -> CAAction? {
        if ShapeLayer.disableActions == true {
            return nil
        }

        let animatableProperties = ["lineWidth", "strokeEnd", "strokeStart", "strokeColor", "path", "fillColor", "lineDashPhase", "contents", Layer.rotationKey, "shadowColor", "shadowRadius", "shadowOffset", "shadowOpacity", "shadowPath"]
        if !animatableProperties.contains(key) {
            return super.action(forKey: key)
        }

        let animation: CABasicAnimation
        if let viewAnimation = ViewAnimation.stack.last as? ViewAnimation, viewAnimation.spring != nil {
            animation = CASpringAnimation(keyPath: key)
        } else {
            animation = CABasicAnimation(keyPath: key)
        }

        animation.configureOptions()
        animation.fromValue = value(forKey: key)

        if key == Layer.rotationKey {
            if let layer = presentation() {
                animation.fromValue = layer.value(forKey: key)
            }
        }

        return animation
    }

    private var _rotation = 0.0

    /// The value of the receiver's current rotation state.
    /// This value is cumulative, and can represent values beyong +/- π
    public dynamic var rotation: Double {
        return _rotation
    }

    /// Initializes a new C4Layer
    public override init() {
        super.init()
    }

    /// Initializes a new C4Layer from a specified layer of any other type.
    /// - parameter layer: Another CALayer
    public override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? ShapeLayer {
            _rotation = layer._rotation
        }
    }

    /// Initializes a new C4Layer from data in a given unarchiver.
    /// - parameter coder: An unarchiver object.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// Sets a value for a given key.
    /// - parameter value: The value for the property identified by key.
    /// - parameter key: The name of one of the receiver's properties
    public override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
        if key == Layer.rotationKey {
            _rotation = value as? Double ?? 0.0
        }
    }

    /// Returns a Boolean indicating whether changes to the specified key require the layer to be redisplayed.
    /// - parameter key: A string that specifies an attribute of the layer.
    /// - returns: A Boolean indicating whether changes to the specified key require the layer to be redisplayed.
    public override class func needsDisplay(forKey key: String) -> Bool {
        if  key == Layer.rotationKey {
            return true
        }
        return super.needsDisplay(forKey: key)
    }

    /// Reloads the content of this layer.
    /// Do not call this method directly.
    public override func display() {
        guard let presentation = presentation() else {
            return
        }
        setValue(presentation._rotation, forKeyPath: "transform.rotation.z")
    }
}

extension CABasicAnimation {
    ///  Configures basic options for a CABasicAnimation.
    ///
    ///  The options set in this method are favorable for the inner workings of C4's action behaviours.
    public func configureOptions() {
        if let animation = ViewAnimation.currentAnimation {
            self.autoreverses = animation.autoreverses
            self.repeatCount = Float(animation.repeatCount)
        }
        self.fillMode = kCAFillModeBoth
        self.isRemovedOnCompletion = false
    }
}

extension CASpringAnimation {
    ///  Configures basic options for a CABasicAnimation.
    ///
    ///  The options set in this method are favorable for the inner workings of C4's animation behaviours.
    public override func configureOptions() {
        super.configureOptions()
        if let animation = ViewAnimation.currentAnimation as? ViewAnimation, let spring = animation.spring {
            mass = CGFloat(spring.mass)
            damping = CGFloat(spring.damping)
            stiffness = CGFloat(spring.stiffness)
            initialVelocity = CGFloat(spring.initialVelocity)
        }
    }
}
