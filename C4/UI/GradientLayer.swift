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

/// The GradientLayer class draws a color gradient over its background color, filling the shape of the layer (including rounded corners)
public class GradientLayer: CAGradientLayer {
    /// A boolean value that, when true, prevents the animation of a shape's properties.
    ///
    /// This value can be set globally, after which changes to any shape's properties will be immediate.
    public static var disableActions = true

    private var _rotation = 0.0

    /// The value of the receiver's current rotation state.
    /// This value is cumulative, and can represent values beyong +/- π
    public dynamic var rotation: Double {
        return _rotation
    }

    ///  This method searches for the given action object of the layer. Actions define dynamic behaviors for a layer. For example, the animatable properties of a layer typically have corresponding action objects to initiate the actual animations. When that property changes, the layer looks for the action object associated with the property name and executes it. You can also associate custom action objects with your layer to implement app-specific actions.
    ///
    /// - parameter key: The identifier of the action.
    /// - returns: the action object assigned to the specified key.
    public override func action(forKey key: String) -> CAAction? {
        if ShapeLayer.disableActions == true {
            return nil
        }

        if key != "colors" {
            return super.action(forKey: key)
        }

        let animation: CABasicAnimation
        if let viewAnimation = ViewAnimation.stack.last as? ViewAnimation, viewAnimation.spring != nil {
            animation = CASpringAnimation(keyPath: key)
        } else {
            animation = CABasicAnimation(keyPath: key)
        }

        animation.configureOptions()
        animation.fromValue = self.colors

        return animation
    }
}
