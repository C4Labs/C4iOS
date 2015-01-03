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

private let _sharedAnimator = C4Animator()

internal class C4Animator : NSObject {
    private let displayLink: CADisplayLink!
    private var animations: [NSObject: [String: C4GenericAnimation]] = [:]
    
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
    
    func animations(#object: NSObject) -> [String: C4GenericAnimation]? {
        return animations[object]
    }
    
    func animation(#object: NSObject, key: String) -> C4GenericAnimation? {
        return animations[object]?[key]
    }
    
    func addAnimation(animation: C4GenericAnimation, object: NSObject, key: String) {
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
