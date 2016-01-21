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

public struct Spring {
    public var mass: Double
    public var stiffness: Double
    public var damping: Double
    public var initialVelocity: Double

    public init(mass: Double = 1.0, stiffness: Double = 100.0, damping: Double = 10.0, initialVelocity: Double = 1.0) {
        self.mass = mass
        self.stiffness = stiffness
        self.damping = damping
        self.initialVelocity = initialVelocity
    }
}

/// C4ViewAnimation is a concrete subclass of C4Animation whose execution blocks affect properties of view-based objects.
public class C4ViewAnimation : C4Animation {

    public var spring: Spring? 

    /// The amount of time to way before executing the animation.
    public var delay: NSTimeInterval = 0
    
    /// A block animations to execute.
    public var animations: () -> Void
    
    ///  Initializes an animation object with a block of animtinos to execute.
    ///
    ///  let anim = C4ViewAnimation() {
    ///       aView.backgroundColor = C4Blue
    ///  }
    ///
    ///  - parameter animations: a block of animations to execute.
    public init(_ animations: () -> Void) {
        self.animations = animations
    }
    
    /// Initializes a new C4ViewAnimation.
    ///
    /// ````
    /// let v = C4View(frame: C4Rect(0,0,100,100))
    /// canvas.add(v)
    /// let bg = C4ViewAnimation(duration: 0.25) {
    ///     v.backgroundColor = C4Blue
    /// }
    /// delay(1.0) {
    ///     bg.animate()
    /// }
    /// ````
    ///
    /// - parameter duration: The length of the animations, measured in seconds.
    /// - parameter animations: A block containing a variety of animations to execute
    public convenience init(duration: NSTimeInterval, animations: () -> Void) {
        self.init(animations)
        self.duration = duration
    }
    
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
    
    public var options: UIViewAnimationOptions {
        var options : UIViewAnimationOptions = [UIViewAnimationOptions.BeginFromCurrentState]
        
        switch curve {
        case .Linear:
            options = [options, UIViewAnimationOptions.CurveLinear]
        case .EaseOut:
            options = [options, UIViewAnimationOptions.CurveEaseOut]
        case .EaseIn:
            options = [options, UIViewAnimationOptions.CurveEaseIn]
        case .EaseInOut:
            options = [options, UIViewAnimationOptions.CurveEaseInOut]
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
        
        return options
    }
    
    /// Initiates the changes specified in the receivers `animations` block.
    public override func animate() {
        let disable = C4ShapeLayer.disableActions
        C4ShapeLayer.disableActions = false
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            if let spring = self.spring {
                UIView.animateWithDuration(self.duration, delay: 0, usingSpringWithDamping: CGFloat(spring.damping), initialSpringVelocity: CGFloat(spring.initialVelocity), options: self.options, animations:{
                    self.doAnimationStack()
                    }, completion:nil)

            } else {
                UIView.animateWithDuration(self.duration, delay: 0, options: self.options, animations: {
                    self.doAnimationStack()
                    }, completion:nil)
            }

        }



        C4ShapeLayer.disableActions = disable
    }

    private func doAnimationStack() {
        C4ViewAnimation.stack.append(self)
        UIView.setAnimationRepeatCount(Float(self.repeatCount))
        self.doInTransaction(self.animations)
        C4ViewAnimation.stack.removeLast()
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
public class C4ViewAnimationSequence: C4Animation {
    private var animations: [C4Animation]
    private var currentAnimationIndex: Int = -1
    private var currentObserver: AnyObject?

    /// Initializes a set of animations to execute in sequence.
    ///
    /// ````
    /// let v = C4View(frame: C4Rect(0,0,100,100))
    /// canvas.add(v)
    /// let bg = C4ViewAnimation(duration: 0.25) {
    ///     v.backgroundColor = C4Blue
    /// }
    /// let ctr = C4ViewAnimation(duration: 0.25) {
    ///     v.center = self.canvas.center
    /// }
    /// let seq = C4ViewAnimationSequence(animations: [bg,ctr])
    /// delay(1.0) {
    ///     seq.animate()
    /// }
    /// ````
    public init(animations: [C4Animation]) {
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
public class C4ViewAnimationGroup: C4Animation {
    private var animations: [C4Animation]
    private var observers: [AnyObject] = []
    private var completed: [Bool]

    /// Initializes a set of animations to be executed at the same time.
    /// 
    /// ````
    /// let v = C4View(frame: C4Rect(0,0,100,100))
    /// canvas.add(v)
    /// let bg = C4ViewAnimation(duration: 0.25) {
    ///     v.backgroundColor = C4Blue
    /// }
    /// let ctr = C4ViewAnimation(duration: 0.25) {
    ///     v.center = self.canvas.center
    /// }
    /// let grp = C4ViewAnimationGroup(animations: [bg,ctr])
    /// delay(1.0) {
    ///     grp.animate()
    /// }
    /// ````
    public init(animations: [C4Animation]) {
        self.animations = animations
        completed = [Bool](count: animations.count, repeatedValue: false)
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
                self.completedAnimation(i)
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
        observers.removeAll(keepCapacity: true)
        completed = [Bool](count: animations.count, repeatedValue: false)
        postCompletedEvent()
        
    }
}
