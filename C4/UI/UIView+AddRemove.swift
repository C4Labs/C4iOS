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

import UIKit

/// Extension to UIView that adds handling addition and removal of View objects.
extension UIView {

    /// Adds a view to the end of the receiver’s list of subviews.
    /// When working with C4, use this method to add views because it handles the addition of both UIView and View.
    /// - parameter subview:	The view to be added.
    public func add<T>(_ subview: T?) {
        if let v = subview as? UIView {
            self.addSubview(v)
        } else if let v = subview as? View {
            self.addSubview(v.view)
        } else {
            fatalError("Can't add subview of class `\(type(of: subview))`")
        }
    }

    //MARK: - AddRemoveSubview

    /// Adds an array of views to the end of the receiver’s list of subviews.
    /// When working with C4, use this method to add views because it handles the addition of both UIView and View.
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// let subv1 = View(frame: Rect(25,25,50,50))
    /// let subv2 = View(frame: Rect(100,25,50,50))
    /// v.add([subv1,subv2])
    /// ````
    /// - parameter subviews: An array of UIView or View subclasses to be added to the receiver
    public func add<T>(_ subviews: [T?]) {
        for subv in subviews {
            self.add(subv)
        }
    }

    /// Unlinks the view from the receiver and its window, and removes it from the responder chain.
    /// Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the
    /// subtree of the view you are removing.
    /// When working with C4, use this method to remove views because it handles the removal of both UIView and View.
    /// - parameter subview: The view to be removed.
    public func remove<T>(_ subview: T?) {
        if let v = subview as? UIView {
            v.removeFromSuperview()
        } else if let v = subview as? View {
            v.view.removeFromSuperview()
        } else {
            fatalError("Can't remove subview of class `\(type(of: subview))`")
        }
    }

    /// Moves the specified subview so that it appears behind its siblings.
    /// When working with C4, use this method because it handles both UIView and View.
    /// - parameter subview: The subview to move to the back.
    public func sendToBack<T>(_ subview: T?) {
        if let v = subview as? UIView {
            self.sendSubview(toBack: v)
        } else if let v = subview as? View {
            self.sendSubview(toBack: v.view)
        } else {
            fatalError("Can't operate on subview of class `\(type(of: subview))`")
        }
    }

    /// Moves the specified subview so that it appears on top of its siblings.
    /// When working with C4, use this method because it handles both UIView and View.
    /// - parameter subview: The subview to move to the front.
    public func bringToFront<T>(_ subview: T?) {
        if let v = subview as? UIView {
            self.bringSubview(toFront: v)
        } else if let v = subview as? View {
            self.bringSubview(toFront: v.view)
        } else {
            fatalError("Can't operate on subview of class `\(type(of: subview))`")
        }
    }
}
