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

///This protocol defines 3 required methods for objects to post and listen for notifications, as well as cancel.
public protocol C4EventSource {

    /// Posts a new notification originating from the receiver.
    ///
    /// - parameter event: The name of the event to post.
    func post(event: String)

    /// Register an action to run when an event is triggered. Returns an observer handle you can use to cancel the action.
    ///
    ///  - parameter notificationName: The notification name to listen for
    ///  - parameter executionBlock:   A block of code to run when the receiver "hears" the specified notification name
    func on(event notificationName: String, run: Void -> Void) -> AnyObject

    ///  Register an action to run when an event is triggered by the specified sender. Returns an observer handle you can use to cancel the action.
    ///
    ///  - parameter notificationName: The notification name to listen for
    ///  - parameter sender:           The object from which to listen for the notification
    ///  - parameter executionBlock:   A block of code to run when the receiver "hears" the specified notification name
    func on(event notificationName: String, from sender: AnyObject?, run executionBlock: Void -> Void) -> AnyObject

    /// Cancel a previously registered action from an observer handle.
    func cancel(observer: AnyObject)
}

/// This extension allows any NSObject to post and listen for events in the same way as C4 objects.
extension NSObject : C4EventSource {
    
    //MARK: - EventSource

    /// Posts a new notification originating from the receiver.
    ///
    /// ````
    /// canvas.addTapGestureRecognizer { location, state in
    ///     self.canvas.post("tapped")
    /// }
    /// ````
    ///
    /// - parameter event: The notification name for the event
    public func post(event: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(event, object: self)
    }
    
    /// An action to run on receipt of a given event.
    ///
    /// ````
    /// canvas.on(event: "tapped") {
    ///     println("received tap")
    /// }
    /// ````
    ///
    /// - parameter event: The notification name to listen for
    /// - parameter run:   A block of code to run when the receiver "hears" the specified event name
    public func on(event notificationName: String, run executionBlock: Void -> Void) -> AnyObject {
        return on(event: notificationName, from: nil, run: executionBlock)
    }

    ///  Register an action to run when an event is triggered by the specified sender. Returns an observer handle you can use to cancel the action.
    ///
    ///  ````
    ///  canvas.on(event: "tapped", from: anObject) {
    ///      print("obj was tapped")
    ///  }
    ///  ````
    ///
    ///  - parameter notificationName: The notification name to listen for
    ///  - parameter sender:           The object from which to listen for the notification
    ///  - parameter executionBlock:   A block of code to run when the receiver "hears" the specified notification name
    public func on(event notificationName: String, from sender: AnyObject?, run executionBlock: Void -> Void) -> AnyObject {
        let nc = NSNotificationCenter.defaultCenter()
        return nc.addObserverForName(notificationName, object: sender, queue: NSOperationQueue.currentQueue(), usingBlock: { notification in
            executionBlock()
        });
    }
    
    /// Cancels any actions registered to run for a specified object.
    ///
    /// ````
    /// canvas.cancel(self)
    /// ````
    ///
    /// - parameter observer: An object whose actions are to be removed from the notification center.
    public func cancel(observer: AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(observer)
    }
    
}