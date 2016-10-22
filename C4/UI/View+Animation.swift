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

/// Extension to View that handles animating of basic properties.
public extension View {
    /// Internal function for creating a basic animation and applying that to the receiver.
    /// - parameter keyPath: The identifier to animate
    /// - parameter toValue: The value to which the identifier will be animated
    internal func animateKeyPath(_ keyPath: String, toValue: AnyObject) {
        let anim = CABasicAnimation()
        anim.duration = 0.25
        anim.beginTime = CACurrentMediaTime()
        anim.keyPath = keyPath
        anim.fromValue = view.layer.presentation()?.value(forKeyPath: keyPath)
        anim.toValue = toValue
        view.layer.add(anim, forKey:"C4AnimateKeyPath: \(keyPath)")
        view.layer.setValue(toValue, forKeyPath: keyPath)
    }

    /// A class-level function that executes an animation using a specified block of code.
    ///
    /// - parameter duration: The length of time in seconds for the animation to execute.
    /// - parameter animations: A block of code with specified animations to execute.
    public class func animate(duration: Double, animations: @escaping (Void) -> Void) {
        UIView.animate(withDuration: duration, animations: animations)
    }

    /// A class-level function that executes an animation using a specified block of code, with parameters for delaying and completion.
    ///
    /// - parameter duration:   The length of time in seconds for the animation to execute.
    /// - parameter delay:      The length of time in seconds to wait before executing the specified block of code.
    /// - parameter completion: A block of code to execute when the animation completes.
    /// - parameter animations: A block of code with specified animations to execute.
    public class func animate(duration: Double, delay: Double, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }

    /// A class-level function that executes an animation using a specified block of code, with parameters for delaying, completion and animation options.
    ///
    /// - parameter duration: The length of time in seconds for the animation to execute.
    /// - parameter delay: The length of time in seconds to wait before executing the specified block of code.
    /// - parameter options: Options for animating views using block objects, see: UIViewAnimationOptions.
    /// - parameter animations: A block of code with specified animations to execute.
    /// - parameter completion: A block of code to execute when the animation completes.
    public class func animate(duration: Double, delay: Double, options: UIViewAnimationOptions, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: completion)
    }
}
