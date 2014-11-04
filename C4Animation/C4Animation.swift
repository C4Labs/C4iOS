//  Created by Alejandro Isaza on 2014-11-03.
//  Copyright (c) 2014 C4. All rights reserved.

import C4Core

public class C4Animation {
    public var beginTime: CFTimeInterval = 0
    public var duration: CFTimeInterval = 1
    
    public var paused: Bool = true
    public var completion: (Bool -> Void)?
    
    private var startTime: CFTimeInterval = 0
    private var progress: Double = 0
    
    public func finished() -> Bool {
        return progress == 1
    }
    
    public func reset() {
        if startTime == 0 {
            return
        }
        
        if let completion = completion {
            completion(false)
        }
        
        paused = true
        startTime = 0
        progress = 0
    }
    
    internal func animate(time: CFTimeInterval) {
        if finished() {
            return
        }
        
        if startTime == 0 && time >= beginTime {
            startTime = time
            paused = false
            return
        }
        
        let dt = time - startTime
        if duration > 0 {
            progress = clamp(dt / duration, 0.0, 1.0)
        } else {
            progress = 1
        }
        
        if finished() {
            paused = true
            dispatch_async(dispatch_get_main_queue()) {
                if let completion = self.completion {
                    completion(true)
                }
            }
        }
    }
}

extension NSObject {
    public func animationForKey(key: String) -> C4Animation? {
        return C4Animator.sharedAnimator.animation(object: self, key: key)
    }
    
    public func addAnimation(animation: C4Animation, key: String) {
        C4Animator.sharedAnimator.addAnimation(animation, object: self, key: key)
    }
    
    public func removeAnimation(#key: String) {
        C4Animator.sharedAnimator.removeAnimation(object: self, key: key)
    }
    
    public func removeAllAnimations() {
        C4Animator.sharedAnimator.removeAnimations(object: self)
    }
}
