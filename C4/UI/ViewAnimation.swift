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
import UIKit

///A structure representing the characteristics of spring motion.
public struct Spring {
    /// The mass of the object attached to the end of the spring. Must be greater than 0. Defaults to one.
    public var mass: Double
    /// The spring stiffness coefficient. Must be greater than 0. Defaults to 100.
    public var stiffness: Double
    /// The damping coefficient. Must be greater than or equal to 0. Defaults to 10.
    public var damping: Double
    /// The initial velocity of the object attached to the spring.
    /// Defaults to zero, which represents an unmoving object.
    /// Negative values represent the object moving away from the spring attachment point,
    /// positive values represent the object moving towards the spring attachment point.
    public var initialVelocity: Double

    /// Initializes a new Spring structure
    /// - parameter mass: The mass for the object
    /// - parameter stiffness: The stiffness of the spring
    /// - parameter damping: The damping coefficient used to calculate the motion of the object
    /// - parameter initialVelocity: The initial velocity for the object
    public init(mass: Double = 1.0, stiffness: Double = 100.0, damping: Double = 10.0, initialVelocity: Double = 1.0) {
        self.mass = mass
        self.stiffness = stiffness
        self.damping = damping
        self.initialVelocity = initialVelocity
    }
}

/// ViewAnimation is a concrete subclass of Animation whose execution blocks affect properties of view-based objects.
public class ViewAnimation: Animation {
    /// An optional Spring structure.
    /// If this value is non-nil, property animations will default to CASpringAnimation if they are able.
    public var spring: Spring?

    /// The amount of time to way before executing the animation.
    public var delay: TimeInterval = 0

    /// A block animations to execute.
    public var animations: () -> Void

    ///  Initializes an animation object with a block of animtinos to execute.
    ///
    ///  let anim = ViewAnimation() {
    ///       aView.backgroundColor = C4Blue
    ///  }
    ///
    /// - parameter animations: a block of animations to execute.
    public init(_ animations: @escaping () -> Void) {
        self.animations = animations
    }

    /// Initializes a new ViewAnimation.
    ///
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// canvas.add(v)
    /// let bg = ViewAnimation(duration: 0.25) {
    ///     v.backgroundColor = C4Blue
    /// }
    /// wait(1.0) {
    ///     bg.animate()
    /// }
    /// ````
    ///
    /// - parameter duration: The length of the animations, measured in seconds.
    /// - parameter animations: A block containing a variety of animations to execute
    public convenience init(duration: TimeInterval, animations: @escaping () -> Void) {
        self.init(animations)
        self.duration = duration
    }

    /// This timingFunction represents one segment of a function that defines the pacing of an animation as a timing curve. The function maps an input time normalized to the range [0,1] to an output time also in the range [0,1].
    /// Options are `Linear`, `EaseOut`, `EaseIn`, `EaseInOut`
    public var timingFunction: CAMediaTimingFunction {
        switch curve {
        case .Linear:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        case .EaseOut:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        case .EaseIn:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        case .EaseInOut:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }
    }

    ///Options for animating views using block objects.
    public var options: UIViewAnimationOptions {
        var options: UIViewAnimationOptions = [UIViewAnimationOptions.beginFromCurrentState]
        switch curve {
        case .Linear:
            options = [options, .curveLinear]
        case .EaseOut:
            options = [options, .curveEaseOut]
        case .EaseIn:
            options = [options, .curveEaseIn]
        case .EaseInOut:
            options = [options, .curveEaseIn, .curveEaseOut]
        }

        if autoreverses == true {
            options.formUnion(.autoreverse)
        } else {
            options.subtract(.autoreverse)
        }

        if repeatCount > 0 {
            options.formUnion(.repeat)
        } else {
            options.subtract(.repeat)
        }
        return options
    }

    /// Initiates the changes specified in the receivers `animations` block.
    public override func animate() {
        let disable = ShapeLayer.disableActions
        ShapeLayer.disableActions = false

        wait(delay) {
            if let spring = self.spring {
                self.animateWithSpring(spring: spring)
            } else {
                self.animateNormal()
            }
        }

        ShapeLayer.disableActions = disable
    }

    private func animateWithSpring(spring: Spring) {
        UIView.animate(withDuration: self.duration, delay: 0, usingSpringWithDamping: CGFloat(spring.damping), initialSpringVelocity: CGFloat(spring.initialVelocity), options: self.options, animations: self.animationBlock, completion:nil)
    }

    private func animateNormal() {
        UIView.animate(withDuration: self.duration, delay: 0, options: self.options, animations: self.animationBlock, completion:nil)
    }

    private func animationBlock() {
        ViewAnimation.stack.append(self)
        UIView.setAnimationRepeatCount(Float(self.repeatCount))
        self.doInTransaction(action: self.animations)
        ViewAnimation.stack.removeLast()
    }

    private func doInTransaction(action: () -> Void) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(timingFunction)
        CATransaction.setCompletionBlock() {
            self.postCompletedEvent()
        }
        action()
        CATransaction.commit()
    }
}

/// A sequence of animations that run one after the other. This class ignores the duration property.
public class ViewAnimationSequence: Animation {
    private var animations: [Animation]
    private var currentAnimationIndex: Int = -1
    private var currentObserver: AnyObject?

    /// Initializes a set of animations to execute in sequence.
    ///
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// canvas.add(v)
    /// let bg = ViewAnimation(duration: 0.25) {
    ///     v.backgroundColor = C4Blue
    /// }
    /// let ctr = ViewAnimation(duration: 0.25) {
    ///     v.center = self.canvas.center
    /// }
    /// let seq = ViewAnimationSequence(animations: [bg,ctr])
    /// wait(1.0) {
    ///     seq.animate()
    /// }
    /// ````
    /// - parameter animations: An array of C4Animations
    public init(animations: [Animation]) {
        self.animations = animations
    }

    ///  Calling this method will tell the receiver to begin animating.
    public override func animate() {
        if currentAnimationIndex != -1 {
            // Animation is already running
            return
        }
        startNext()
    }

    private func startNext() {
        if let observer: AnyObject = currentObserver {
            let currentAnimation = animations[currentAnimationIndex]
            currentAnimation.removeCompletionObserver(observer)
            currentObserver = nil
        }

        currentAnimationIndex += 1
        if currentAnimationIndex >= animations.count && self.repeats {
            // Start from the beginning if sequence repeats
            currentAnimationIndex = 0
        }

        if currentAnimationIndex >= animations.count {
            // Reached the end
            currentAnimationIndex = -1
            postCompletedEvent()
            return
        }

        let animation = animations[currentAnimationIndex]
        currentObserver = animation.addCompletionObserver({
            self.startNext()
        })
        animation.animate()
    }
}

/// Groups animations so that they can all be run at the same time. The completion call is dispatched when all the
/// animations in the group have finished. This class ignores the duration property.
public class ViewAnimationGroup: Animation {
    private var animations: [Animation]
    private var observers: [AnyObject] = []
    private var completed: [Bool]

    /// Initializes a set of animations to be executed at the same time.
    ///
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// canvas.add(v)
    /// let bg = ViewAnimation(duration: 0.25) {
    ///     v.backgroundColor = C4Blue
    /// }
    /// let ctr = ViewAnimation(duration: 0.25) {
    ///     v.center = self.canvas.center
    /// }
    /// let grp = ViewAnimationGroup(animations: [bg,ctr])
    /// wait(1.0) {
    ///     grp.animate()
    /// }
    /// ````
    /// - parameter animations: An array of C4Animations
    public init(animations: [Animation]) {
        self.animations = animations
        completed = [Bool](repeating: false, count: animations.count)
    }

    ///  Calling this method will tell the receiver to begin animating.
    public override func animate() {
        if !observers.isEmpty {
            // Animation is already running
            return
        }

        for i in 0..<animations.count {
            let animation = animations[i]
            let observer: AnyObject = animation.addCompletionObserver({
                self.completedAnimation(index: i)
            })
            observers.append(observer)
            animation.animate()
        }
    }

    private func completedAnimation(index: Int) {
        let animation = animations[index]
        animation.removeCompletionObserver(observers[index])
        completed[index] = true
        var allCompleted = true
        for c in completed {
            allCompleted = allCompleted && c
        }
        if allCompleted {
            cleanUp()
        }
    }

    private func cleanUp() {
        observers.removeAll(keepingCapacity: true)
        completed = [Bool](repeating: false, count: animations.count)
        postCompletedEvent()
    }
}
