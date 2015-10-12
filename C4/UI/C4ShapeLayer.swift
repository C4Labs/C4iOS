//  Copyright (c) 2015 C4. All rights reserved.

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
        
        if key == "lineWidth" {
            let animation = CABasicAnimation(keyPath: key)
            animation.configureOptions()
            animation.fromValue = self.lineWidth
            return animation;
        }
        else if key == "strokeEnd" {
            let animation = CABasicAnimation(keyPath: key)
            animation.configureOptions()
            animation.fromValue = self.strokeEnd
            return animation;
        }
        else if key == "strokeStart" {
            let animation = CABasicAnimation(keyPath: key)
            animation.configureOptions()
            animation.fromValue = self.strokeStart
            return animation;
        }
        else if key == "strokeColor" {
            let animation = CABasicAnimation(keyPath: key)
            animation.configureOptions()
            animation.fromValue = self.strokeColor
            return animation;
        }
        else if key == "path" {
            let animation = CABasicAnimation(keyPath: key)
            animation.configureOptions()
            animation.fromValue = self.path
            return animation;
        }
        else if key == "fillColor" {
            let animation = CABasicAnimation(keyPath: key)
            animation.configureOptions()
            animation.fromValue = self.fillColor
            return animation;
        } else if key == "lineDashPhase" {
            let animation = CABasicAnimation(keyPath: key)
            animation.configureOptions()
            animation.fromValue = self.lineDashPhase
            return animation;
        }
        
        return super.actionForKey(key)
    }
}

extension CABasicAnimation {
    ///  Configures basic options for a CABasicAnimation.
    ///
    ///  The options set in this method are favorable for the inner workings of C4's animation behaviours.
    public func configureOptions() {
        if let animation = C4ViewAnimation.currentAnimation {
            self.autoreverses = animation.autoreverses
            self.repeatCount = Float(animation.repeatCount)
        }
        self.fillMode = kCAFillModeBoth
        self.removedOnCompletion = false
    }
}
