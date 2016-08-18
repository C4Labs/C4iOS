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

/// You use the Timer class to create timer objects or, more simply, timers. A timer waits until a certain time interval has elapsed and then fires, executing a specified block of code.
public final class Timer: NSObject {
    /// The current number of times the timer has fired.
    public internal(set) var step = 0
    /// The number of times the timer will fire.
    public internal(set) var count: Int
    /// The time interval between firing.
    public internal(set) var interval: Double
    var action: () -> ()
    /// The timer that the receiver manages
    weak var timer: Foundation.Timer?

    ///  Initializes a new timer.
    ///
    ///  ````
    ///  let t = Timer(0.25) {
    ///      print("tick")
    ///  }
    ///  ````
    /// - parameter interval: the time between firing
    /// - parameter count:    the total number of times the timer should fire, defaults to Int.max
    /// - parameter action:   a block of code to execute
    public init(interval: Double, count: Int = Int.max, action: @escaping () -> ()) {
        self.action = action
        self.count = count
        self.interval = interval
        super.init()
    }

    ///  Tells the timer to fire, i.e. execute its block of code.
    public func fire() {
        action()
        step += 1
        if step >= count {
            stop()
        }
    }

    ///  Tells the timer to attach itself to the main run loop of an application, after calling `start` the timer will continue firing until the timer reaches its `count` or is otherwise stopped.
    public func start() {
        guard timer == nil else {
            return // Timer already running
        }

        let t = Foundation.Timer(timeInterval: TimeInterval(interval), target: self, selector: #selector(Timer.fire), userInfo: nil, repeats: true)
        RunLoop.main.add(t, forMode: RunLoopMode.defaultRunLoopMode)
        timer = t
    }

    ///  Pauses the execution of the timer.
    public func pause() {
        timer?.invalidate()
    }

    ///  Stops the timer and resets its step to 0.
    public func stop() {
        pause()
        step = 0
    }
}
