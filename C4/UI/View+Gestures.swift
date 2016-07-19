// Copyright © 2014 
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

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension View {
    /// Adds a tap gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// v.addTapGestureRecognizer { location, state in
    ///     println("tapped")
    /// }
    /// ````
    ///
    /// - parameter action: A block of code to be executed when the receiver recognizes a tap gesture.
    ///
    /// - returns: A UITapGestureRecognizer that can be customized.
    public func addTapGestureRecognizer(action: TapAction) -> NativeTapGestureRecognizer {
        let gestureRecognizer = NativeTapGestureRecognizer(view: self.view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }

    /// Adds a pan gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// v.addPanGestureRecognizer { location, translation, velocity, state in
    ///     println("panned")
    /// }
    ///
    /// - parameter action: A block of code to be executed when the receiver recognizes a pan gesture.
    ///
    /// - returns: A UIPanGestureRecognizer that can be customized.
    #if os(iOS)
    public func addPanGestureRecognizer(action: PanAction) -> UIPanGestureRecognizer {
        let gestureRecognizer = UIPanGestureRecognizer(view: self.view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    #elseif os(OSX)
    public func addPanGestureRecognizer(action: PanAction) -> NSPanGestureRecognizer {
        let gestureRecognizer = NSPanGestureRecognizer(view: self.view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    #endif

    /// Adds a pinch gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// v.addPinchGestureRecognizer { scale, velocity, state in
    ///     println("pinched")
    /// }
    ///
    /// - parameter action: A block of code to be executed when the receiver recognizes a pinch gesture.
    ///
    /// - returns: A NativePinchGestureRecognizer that can be customized.
    public func addPinchGestureRecognizer(action: PinchAction) -> NativePinchGestureRecognizer {
        let gestureRecognizer = NativePinchGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }

    /// Adds a rotation gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// v.addRotationGestureRecognizer { rotation, velocity, state in
    ///     println("rotated")
    /// }
    /// ````
    ///
    /// - parameter action: A block of code to be executed when the receiver recognizes a rotation gesture.
    ///
    /// - returns: A NativeRotationGestureRecognizer that can be customized.
    public func addRotationGestureRecognizer(action: RotationAction) -> NativeRotationGestureRecognizer {
        let gestureRecognizer = NativeRotationGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }

    /// Adds a longpress gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// v.addLongPressGestureRecognizer { location, state in
    ///     println("longpress")
    /// }
    /// ````
    /// - parameter action: A block of code to be executed when the receiver recognizes a longpress gesture.
    ///
    /// - returns: A NativePressGestureRecognizer that can be customized.
    public func addLongPressGestureRecognizer(action: LongPressAction) -> NativePressGestureRecognizer {
        let gestureRecognizer = NativePressGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }

    #if os(iOS)
    /// Adds a swipe gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// v.addSwipeGestureRecognizer { location, state in
    ///     println("swiped")
    /// }
    /// ````
    ///
    /// - parameter action: A block of code to be executed when the receiver recognizes a swipe gesture.
    ///
    /// - returns: A UISwipeGestureRecognizer that can be customized.
    public func addSwipeGestureRecognizer(action: SwipeAction) -> UISwipeGestureRecognizer {
        let gestureRecognizer = UISwipeGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    #endif

    #if os(iOS)
    /// Adds a screen edge pan gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let v = View(frame: canvas.bounds)
    /// v.addSwipeGestureRecognizer { location, state in
    /// println("edge pan")
    /// }
    /// ````
    /// - parameter action: A block of code to be executed when the receiver recognizes a screen edge pan gesture.
    ///
    /// - returns: A UIScreenEdgePanGestureRecognizer that can be customized.
    public func addScreenEdgePanGestureRecognizer(action: ScreenEdgePanAction) -> UIScreenEdgePanGestureRecognizer {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    #endif
}
