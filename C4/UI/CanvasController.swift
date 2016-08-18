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

/// The CanvasController class provides the infrastructure for managing the views of your iOS apps. A canvas controller manages a set of views that make up a portion of your app’s user interface. It is responsible for loading and disposing of those views, for managing interactions with those views, and for coordinating responses with any appropriate data objects. Canvas controllers also coordinate their efforts with other controller objects—including other view controllers—and help manage your app’s overall interface.
open class CanvasController: UIViewController {

    /// Called after the controller's view is loaded into memory.
    ///
    /// This override disables implicit CALayer animations, calls `setup()` and then re-enables animations.
    ///
    /// You should **not** override this method, instead use **setup()**.
    open override func viewDidLoad() {
        canvas.backgroundColor = C4Grey
        ShapeLayer.disableActions = true
        self.setup()
        ShapeLayer.disableActions = false
    }

    /// Called during the controller's `viewDidLoad()` method.
    ///
    /// This method should be used to set up any objects or behaviours necessary when the controller's view loads.
    open func setup() {
    }

    ///  Overrides default behaviour of showing the app's status bar. Defaults to `true`
    ///
    /// - returns: a boolean value representing whether or not the app should hide its status bar
    open override var prefersStatusBarHidden: Bool {
        return true
    }
}
