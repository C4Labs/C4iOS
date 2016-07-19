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
#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

/// ViewAnimation is a concrete subclass of Animation whose execution blocks affect properties of view-based objects.
public class ViewAnimation : Animation {
    /// The amount of time to way before executing the animation.
    public var delay: NSTimeInterval = 0

    /// A block animations to execute.
    public var animations: () -> Void

    ///  Initializes an animation object with a block of animtinos to execute.
    ///
    ///  let anim = ViewAnimation() {
    ///       aView.backgroundColor = Blue
    ///  }
    ///
    ///  - parameter animations: a block of animations to execute.
    public init(_ animations: () -> Void) {
        self.animations = animations
    }

    /// Initializes a new ViewAnimation.
    /// 
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// canvas.add(v)
    /// let bg = ViewAnimation(duration: 0.25) {
    ///     v.backgroundColor = Blue
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

    /// Initiates the changes specified in the receivers `animations` block.
    public func animate() {
        let disable = ShapeLayer.disableActions
        ShapeLayer.disableActions = false
        var timing: CAMediaTimingFunction

        switch curve {
        case .Linear:
            timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        case .EaseOut:
            timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        case .EaseIn:
            timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        case .EaseInOut:
            timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }

        #if os(iOS)
        UIView.animateWithDuration(duration, delay: delay, options: animationOptions(), animations: {
            ViewAnimation.stack.append(self)
            UIView.setAnimationRepeatCount(Float(self.repeatCount))
            CATransaction.begin()
            CATransaction.setAnimationDuration(self.duration)
            CATransaction.setAnimationTimingFunction(timing)
            CATransaction.setCompletionBlock() {
                self.postCompletedEvent()
            }
            self.animations()
            CATransaction.commit()
            ViewAnimation.stack.removeLast()
        }, completion:nil)
        #elseif os(OSX)
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = self.duration
            context.timingFunction = timing
            ViewAnimation.stack.append(self)
            self.animations()
            ViewAnimation.stack.removeLast()
        }, completionHandler: {
            self.postCompletedEvent()
        })
        #endif
        ShapeLayer.disableActions = disable
    }

    #if os(iOS)
    func animationOptions() -> UIViewAnimationOptions {
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
    #endif
}

/// A sequence of animations that run one after the other. This class ignores the duration property.
public class ViewAnimationSequence: Animation {
    private var animations: [ViewAnimation]
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
    /// delay(1.0) {
    ///     seq.animate()
    /// }
    /// ````
    public init(animations: [ViewAnimation]) {
        self.animations = animations
    }

    ///  Calling this method will tell the receiver to begin animating.
    public func animate() {
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
    private var animations: [ViewAnimation]
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
    /// delay(1.0) {
    ///     grp.animate()
    /// }
    /// ````
    public init(animations: [ViewAnimation]) {
        self.animations = animations
        completed = [Bool](count: animations.count, repeatedValue: false)
    }

    ///  Calling this method will tell the receiver to begin animating.
    public func animate() {
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
