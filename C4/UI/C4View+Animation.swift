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

import QuartzCore
import UIKit

/// Extension to C4View that handles animating of basic properties.
public extension C4View {
    internal func animateKeyPath(keyPath: String, toValue: AnyObject) {
        let anim = CABasicAnimation()
        anim.duration = 0.25
        anim.beginTime = CACurrentMediaTime()
        anim.keyPath = keyPath
        anim.fromValue = view.layer.presentationLayer()?.valueForKeyPath(keyPath)
        anim.toValue = toValue
        view.layer.addAnimation(anim, forKey:"C4AnimateKeyPath: \(keyPath)")
        view.layer.setValue(toValue, forKeyPath: keyPath)
    }
    
    /// Class level function that executes an animation using a specified block of code.
    ///
    /// - parameter duration: The length of time in seconds for the animation to execute.
    /// - parameter animations: A block of code with specified animations to execute.
    public class func animate(duration duration: Double, animations: Void -> Void) {
        UIView.animateWithDuration(duration, animations: animations)
    }
    
    /// Class level function that executes an animation using a specified block of code.
    ///
    /// - parameter duration: The length of time in seconds for the animation to execute.
    /// - parameter delay: The length of time in seconds to wait before executing the specified block of code.
    /// - parameter animations: A block of code with specified animations to execute.
    /// - parameter completion: A block of code to execute when the animation completes.
    public class func animate(duration duration: Double, delay: Double, animations: () -> Void, completion: (Bool -> Void)?) {
        UIView.animateWithDuration(duration, animations: animations, completion: completion)
    }
    
    /// Class level function that executes an animation using a specified block of code.
    ///
    /// - parameter duration: The length of time in seconds for the animation to execute.
    /// - parameter delay: The length of time in seconds to wait before executing the specified block of code.
    /// - parameter options: Options for animating views using block objects, see: UIViewAnimationOptions.
    /// - parameter animations: A block of code with specified animations to execute.
    /// - parameter completion: A block of code to execute when the animation completes.
    public class func animate(duration duration: Double, delay: Double, options: UIViewAnimationOptions, animations: () -> Void, completion: (Bool -> Void)?) {
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: completion)
    }
}
