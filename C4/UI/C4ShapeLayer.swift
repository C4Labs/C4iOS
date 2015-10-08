//  Copyright (c) 2015 C4. All rights reserved.

import QuartzCore


/// Extension for CAShapeLayer that allows overriding the actions for specific properties.
public class C4ShapeLayer: CAShapeLayer {
    public static var disableActions = true
    
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
    public func configureOptions() {
        if let animation = C4ViewAnimation.currentAnimation {
            self.autoreverses = animation.autoreverses
            self.repeatCount = Float(animation.repeatCount)
        }
        self.fillMode = kCAFillModeBoth
        self.removedOnCompletion = false
    }
}
