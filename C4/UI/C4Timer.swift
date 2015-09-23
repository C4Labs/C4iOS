// Copyright © 2015 C4
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

public class C4Timer : NSObject {
    internal var timer : NSTimer!
    internal var timerCanStart = false
    internal var closure : ()->()
    internal var repeats = true
    private(set) public var userInfo : AnyObject? = nil
    private(set) public var timeInterval : NSTimeInterval = 0.0

    public var valid : Bool {
        get {
            return timer.valid
        }
    }

    public init(interval:Double, userInfo: AnyObject? = nil, repeats: Bool = true, closure:()->()) {
        self.closure = closure
        self.timeInterval = interval
        self.repeats = repeats
        self.userInfo = userInfo
        super.init()
        timer = NSTimer(timeInterval: timeInterval, target: self, selector: "execute", userInfo: userInfo, repeats: repeats)
        self.timerCanStart = true
    }

    public func execute() {
        closure()
    }

    public func fire() {
        timer?.fire()
    }

    public func start() {
        if timerCanStart {
            if let t = timer where timer!.valid {
                NSRunLoop.mainRunLoop().addTimer(t, forMode: NSDefaultRunLoopMode)
            }
            else {
                timer = NSTimer(timeInterval: timeInterval, target: self, selector: "execute", userInfo:userInfo, repeats: repeats)
                NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
            }
            timerCanStart = false
        }
    }

    public func stop() {
        timer.invalidate()
        timerCanStart = true
    }

    public func invalidate() {
        timer!.invalidate()
    }
}
