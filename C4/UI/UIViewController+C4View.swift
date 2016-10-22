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
import ObjectiveC
import UIKit

private var canvasAssociationKey: UInt8 = 0

/// Extension to UIViewController that adds a `canvas` object.
///
/// The canvas is a View representation of the view controller's UIView property.
///
/// This extension adds properties and functionality of View to the native contoller object.
///
/// For example:
/// ````
/// canvas.backgroundColor = Color(r,g,b,a)
/// canvas.addTapGestureRecognizer(0.5){...}
/// ````
///
/// Where, `canvas` is essentially equal to `self.viewController.view`, keeping the interaction with a controller's main view consistent with using other View objects.
public extension UIViewController {
    /// Returns a View object representation of the controller's `view` property.
    public var canvas: View {
        get {
            if let canvas = objc_getAssociatedObject(self, &canvasAssociationKey) as? View {
                return canvas
            }

            let canvas = View(view: view)
            objc_setAssociatedObject(
                self,
                &canvasAssociationKey,
                canvas,
                .OBJC_ASSOCIATION_RETAIN)
            return canvas
        }
    }
}
