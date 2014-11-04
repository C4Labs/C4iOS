//  Created by Alejandro Isaza on 2014-11-03.
//  Copyright (c) 2014 C4. All rights reserved.

import QuartzCore

private let _sharedAnimator = C4Animator()

internal class C4Animator : NSObject {
    private let displayLink: CADisplayLink!
    private var animations: [NSObject: [String: C4Animation]] = [:]
    
    class var sharedAnimator: C4Animator {
        return _sharedAnimator
    }
    
    override init() {
        super.init()
        displayLink = CADisplayLink(target: self, selector: Selector("render"))
        displayLink.paused = true
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    deinit {
        displayLink.invalidate()
    }
    
    func animations(#object: NSObject) -> [String: C4Animation]? {
        return animations[object]
    }
    
    func animation(#object: NSObject, key: String) -> C4Animation? {
        return animations[object]?[key]
    }
    
    func addAnimation(animation: C4Animation, object: NSObject, key: String) {
        if var animations = animations[object] {
            if let existingAnimation = animations[key] {
                if existingAnimation === animation {
                    return
                }
                removeAnimation(object: object, key: key)
            }
            animations[key] = animation
        } else {
            animations[object] = [key: animation]
        }
        
        displayLink.paused = false
    }
    
    func removeAnimation(#object: NSObject, key: String) {
        if var objectAnimations = animations[object] {
            objectAnimations.removeValueForKey(key)
            if objectAnimations.isEmpty {
                animations.removeValueForKey(object)
            }
        }
        
        if animations.isEmpty {
            displayLink.paused = true
        }
    }
    
    func removeAnimations(#object: NSObject) {
        animations.removeValueForKey(object)
        if animations.isEmpty {
            displayLink.paused = true
        }
    }
    
    var currentRenderTime: CFTimeInterval {
        return CACurrentMediaTime()
    }
    
    private func render() {
        let time = CACurrentMediaTime()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        for (object, objectAnimations) in animations {
            for (key, animation) in objectAnimations {
                if !animation.paused {
                    animation.animate(time)
                }
                if animation.finished() {
                    animations[object]!.removeValueForKey(key)
                }
            }
        }
        
        CATransaction.commit()
    }
}
