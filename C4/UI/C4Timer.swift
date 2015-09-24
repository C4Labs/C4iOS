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

public final class C4Timer : NSObject {
    public internal(set) var step = 0
    public internal(set) var count: Int
    public internal(set) var interval: Double
    var action: () -> ()
    weak var timer: NSTimer?

    public init(interval: Double, count: Int = Int.max, action: () -> ()) {
        self.action = action
        self.count = count
        self.interval = interval
        super.init()
    }

    public func fire() {
        action()
        step++
        if step >= count { stop() }
    }

    public func start() {
        guard timer == nil else {
            return // Timer already running
        }

        let t = NSTimer(timeInterval: NSTimeInterval(interval), target: self, selector: "fire", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(t, forMode: NSDefaultRunLoopMode)
        timer = t
    }

    public func pause() {
        timer?.invalidate()
    }

    public func stop() {
        pause()
        step = 0
    }
}
