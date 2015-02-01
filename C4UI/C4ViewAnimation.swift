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

import C4Animation

public class C4ViewAnimation : C4Animation {
    public var delay: NSTimeInterval = 0
    
    public var animations: () -> Void
    
    public init(animations: () -> Void) {
        self.animations = animations
    }
    
    public convenience init(duration: NSTimeInterval, animations: () -> Void) {
        self.init(animations)
        self.duration = duration
    }
    
    public func animate() {
        var timing: CAMediaTimingFunction
        var options: UIViewAnimationOptions
        
        switch curve {
        case .Linear:
            options = UIViewAnimationOptions.CurveLinear
            timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        case .EaseOut:
            options = UIViewAnimationOptions.CurveEaseOut
            timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        case .EaseIn:
            options = UIViewAnimationOptions.CurveEaseIn
            timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        case .EaseInOut:
            options = UIViewAnimationOptions.CurveEaseInOut
            timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }
        
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
            CATransaction.begin()
            CATransaction.setAnimationDuration(self.duration)
            CATransaction.setAnimationTimingFunction(timing)
            self.animations()
            CATransaction.commit()
        }, completion: { finished in
            if finished {
                self.postCompletedEvent()
            } else {
                self.postCancelledEvent()
            }
        })
    }
}

/**
  A sequence of animations that run one after the other. This class ignores the duration property.
 */
public class C4ViewAnimationSequence: C4Animation {
    private var animations: [C4ViewAnimation]
    private var currentAnimationIndex: Int = -1
    private var currentObserver: AnyObject?
    
    public init(animations: [C4ViewAnimation]) {
        self.animations = animations
    }
    
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

/**
  Groups animations so that they can all be run at the same time. The completion call is dispatched when all the
  animations in the group have finished. This class ignores the duration property.
 */
public class C4ViewAnimationGroup: C4Animation {
    private var animations: [C4ViewAnimation]
    private var observers: [AnyObject] = []
    private var completed: [Bool]
    
    public init(animations: [C4ViewAnimation]) {
        self.animations = animations
        completed = [Bool](count: animations.count, repeatedValue: false)
    }
    
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
            allCompleted &= c
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
