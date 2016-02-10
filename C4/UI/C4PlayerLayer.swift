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
import AVFoundation

/// Extension for CAShapeLayer that allows overriding the actions for specific properties.
public class C4PlayerLayer: AVPlayerLayer {
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

        let animatableProperties = [C4Layer.rotationKey]
        if !animatableProperties.contains(key) {
            return super.actionForKey(key)
        }

        let animation: CABasicAnimation
        if let viewAnimation = C4ViewAnimation.stack.last as? C4ViewAnimation where viewAnimation.spring != nil {
            animation = CASpringAnimation(keyPath: key)
        } else {
            animation = CABasicAnimation(keyPath: key)
        }

        animation.configureOptions()
        animation.fromValue = valueForKey(key)

        if key == C4Layer.rotationKey {
            if let layer = presentationLayer() as? C4ShapeLayer {
                animation.fromValue = layer.valueForKey(key)
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
    public override init(layer: AnyObject) {
        super.init(layer: layer)
        if let layer = layer as? C4PlayerLayer {
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
    public override func setValue(value: AnyObject?, forKey key: String) {
        super.setValue(value, forKey: key)
        if key == C4Layer.rotationKey {
            _rotation = value as? Double ?? 0.0
        }
    }

    /// Returns a Boolean indicating whether changes to the specified key require the layer to be redisplayed.
    /// - parameter key: A string that specifies an attribute of the layer.
    /// - returns: A Boolean indicating whether changes to the specified key require the layer to be redisplayed.
    public override class func needsDisplayForKey(key: String) -> Bool {
        if  key == C4Layer.rotationKey {
            return true
        }
        return super.needsDisplayForKey(key)
    }

    /// Reloads the content of this layer.
    /// Do not call this method directly.
    public override func display() {
        guard let presentation = presentationLayer() as? C4PlayerLayer else {
            return
        }
        setValue(presentation._rotation, forKeyPath: "transform.rotation.z")
    }
}
