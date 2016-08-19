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
public protocol EventSource {

    /// Posts a new notification originating from the receiver.
    ///
    /// - parameter event: The name of the event to post.
    func post(_ event: String)

    /// Register an action to run when an event is triggered. Returns an observer handle you can use to cancel the action.
    ///
    /// - parameter notificationName: The notification name to listen for
    /// - parameter executionBlock:   A block of code to run when the receiver "hears" the specified notification name
    @discardableResult
    func on(event notificationName: String, run: @escaping (Void) -> Void) -> AnyObject

    ///  Register an action to run when an event is triggered by the specified sender. Returns an observer handle you can use to cancel the action.
    ///
    /// - parameter notificationName: The notification name to listen for
    /// - parameter sender:           The object from which to listen for the notification
    /// - parameter executionBlock:   A block of code to run when the receiver "hears" the specified notification name
    @discardableResult
    func on(event notificationName: String, from sender: AnyObject?, run executionBlock: @escaping () -> Void) -> AnyObject

    /// Cancel a previously registered action from an observer handle.
    func cancel(_ observer: AnyObject)
}

/// This extension allows any NSObject to post and listen for events in the same way as C4 objects.
extension NSObject : EventSource {

    /// Posts a new notification originating from the receiver.
    ///
    /// ````
    /// canvas.addTapGestureRecognizer { location, state in
    ///     self.canvas.post("tapped")
    /// }
    /// ````
    ///
    /// - parameter event: The notification name for the event
    public func post(_ event: String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: event), object: self)
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
    /// - returns: A token to use for cancelling the action.
    @discardableResult
    public func on(event notificationName: String, run executionBlock: @escaping (Void) -> Void) -> AnyObject {
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
    /// - parameter notificationName: The notification name to listen for
    /// - parameter sender:           The object from which to listen for the notification
    /// - parameter executionBlock:   A block of code to run when the receiver "hears" the specified notification name
    /// - returns: A token to use for cancelling the action.
    @discardableResult
    public func on(event notificationName: String, from sender: AnyObject?, run executionBlock: @escaping (Void) -> Void) -> AnyObject {
        let nc = NotificationCenter.default
        return nc.addObserver(forName: NSNotification.Name(rawValue: notificationName), object: sender, queue: OperationQueue.current, using: { notification in
            executionBlock()
        })
    }

    /// Cancels any actions registered to run for a specified object.
    ///
    /// ````
    /// canvas.cancel(self)
    /// ````
    ///
    /// - parameter token: A token returned from a call to `on(event:run:)` method
    public func cancel(_ token: AnyObject) {
        let nc = NotificationCenter.default
        nc.removeObserver(token)
    }
}
