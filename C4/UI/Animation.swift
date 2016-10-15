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

import Foundation

private let AnimationCompletedEvent = "C4AnimationCompleted"
private let AnimationCancelledEvent = "C4AnimationCancelled"

/// Defines an object that handles the creation of animations for specific actions and keys.
public class Animation {
    ///  Specifies the supported animation curves.
    ///
    ///  ````
    ///  animation.curve = .EaseIn
    ///  ````
    public enum Curve {
        /// A linear animation curve causes an animation to occur evenly over its duration.
        case Linear
        /// An ease-out curve causes the animation to begin quickly, and then slow down as it completes.
        case EaseOut
        /// An ease-in curve causes the animation to begin slowly, and then speed up as it progresses.
        case EaseIn
        /// An ease-in ease-out curve causes the animation to begin slowly, accelerate through the middle of its duration, and then slow again before completing. This is the default curve for most animations.
        case EaseInOut
    }

    /// Determines if the animation plays in the reverse upon completion.
    public var autoreverses = false

    /// Specifies the number of times the animation should repeat.
    public var repeatCount = 0.0

    /// If `true` the animation will repeat indefinitely.
    public var repeats: Bool {
        get {
            return repeatCount > 0
        }
        set {
            if newValue {
                repeatCount = DBL_MAX
            } else {
                repeatCount = 0
            }
        }
    }

    /// The duration of the animation, measured in seconds.
    public var duration: TimeInterval = 1

    /// The animation curve that the receiver will apply to the changes it is supposed to animate.
    public var curve: Curve = .EaseInOut

    private var completionObservers: [AnyObject] = []
    private var cancelObservers: [AnyObject] = []


    static var stack = [Animation]()
    static var currentAnimation: Animation? {
        return stack.last
    }

    ///Intializes an empty animation object.
    public init() {

    }

    deinit {
        let nc = NotificationCenter.default
        for observer in completionObservers {
            nc.removeObserver(observer)
        }
        for observer in cancelObservers {
            nc.removeObserver(observer)
        }
    }

    /// Run the animation
    func animate() {}

    ///  Adds a completion observer to an animation.
    ///
    ///  The completion observer listens for the end of the animation then executes a specified block of code.
    ///
    /// - parameter action: a block of code to be executed at the end of an animation.
    ///
    /// - returns: the observer object.
    public func addCompletionObserver(_ action: @escaping () -> Void) -> AnyObject {
        let nc = NotificationCenter.default
        let observer = nc.addObserver(forName: NSNotification.Name(rawValue: AnimationCompletedEvent), object: self, queue: OperationQueue.current, using: { notification in
            action()
        })
        completionObservers.append(observer)
        return observer
    }

    ///  Removes a specified observer from an animation.
    ///
    /// - parameter observer: the observer object to remove.
    public func removeCompletionObserver(_ observer: AnyObject) {
        let nc = NotificationCenter.default
        nc.removeObserver(observer, name: NSNotification.Name(rawValue: AnimationCompletedEvent), object: self)
    }

    ///  Posts a completion event.
    ///
    ///  This method is triggered when an animation completes. This can be used in place of `addCompletionObserver` for objects outside the scope of the context in which the animation is created.
    public func postCompletedEvent() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(rawValue: AnimationCompletedEvent), object: self)
        }
    }

    ///  Adds a cancel observer to an animation.
    ///
    ///  The cancel observer listens for when an animation is canceled then executes a specified block of code.
    ///
    /// - parameter action: a block of code to be executed when an animation is canceled.
    ///
    /// - returns: the observer object.
    public func addCancelObserver(_ action: @escaping () -> Void) -> AnyObject {
        let nc = NotificationCenter.default
        let observer = nc.addObserver(forName: NSNotification.Name(rawValue: AnimationCancelledEvent), object: self, queue: OperationQueue.current, using: { notification in
            action()
        })
        cancelObservers.append(observer)
        return observer
    }

    ///  Removes a specified cancel observer from an animation.
    ///
    /// - parameter observer: the cancel observer object to remove.
    public func removeCancelObserver(_ observer: AnyObject) {
        let nc = NotificationCenter.default
        nc.removeObserver(observer, name: NSNotification.Name(rawValue: AnimationCancelledEvent), object: self)
    }

    ///  Posts a cancellation event.
    ///
    ///  This method is triggered when an animation is canceled. This can be used in place of `addCancelObserver` for objects outside the scope of the context in which the animation is created.
    public func postCancelledEvent() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(rawValue: AnimationCancelledEvent), object: self)
        }
    }
}
