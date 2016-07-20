// Copyright © 2014 C4
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

import UIKit

/// C4StoredAnimation is a concrete subclass of C4Animation. 
///
/// A C4StoredAnimation object is able to apply a set of stored animation properties to an object.
///
/// This class is useful for serializing and deserializing animations.
public class C4StoredAnimation : C4Animation {
    /// A dictionary of keys whose values will be applied to animatable properties of the receiver. The keys should map directly to the names of animatable properies.
    public var values = [String: AnyObject]()

    /// Initiates the changes specified in the receivers `animations` block.
    public func animate(object: NSObject) {
        let disable = C4ShapeLayer.disableActions
        C4ShapeLayer.disableActions = false
        var timing: CAMediaTimingFunction
        var options : UIViewAnimationOptions = [UIViewAnimationOptions.BeginFromCurrentState]

        switch curve {
        case .Linear:
            options = [options, UIViewAnimationOptions.CurveLinear]
            timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        case .EaseOut:
            options = [options, UIViewAnimationOptions.CurveEaseOut]
            timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        case .EaseIn:
            options = [options, UIViewAnimationOptions.CurveEaseIn]
            timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        case .EaseInOut:
            options = [options, UIViewAnimationOptions.CurveEaseInOut]
            timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }

        if autoreverses == true {
            options.unionInPlace(.Autoreverse)
        } else {
            options.subtractInPlace(.Autoreverse)
        }

        if repeatCount > 0  {
            options.unionInPlace(.Repeat)
        } else {
            options.subtractInPlace(.Repeat)
        }

        UIView.animateWithDuration(duration, delay: 0, options: options, animations: {
            C4ViewAnimation.stack.append(self)
            UIView.setAnimationRepeatCount(Float(self.repeatCount))
            CATransaction.begin()
            CATransaction.setAnimationDuration(self.duration)
            CATransaction.setAnimationTimingFunction(timing)
            CATransaction.setCompletionBlock() {
                self.postCompletedEvent()
            }
            for (key, value) in self.values {
                object.setValue(value, forKeyPath: key)
            }
            CATransaction.commit()
            C4ViewAnimation.stack.removeLast()
        }, completion:nil)
        C4ShapeLayer.disableActions = disable
    }
}
