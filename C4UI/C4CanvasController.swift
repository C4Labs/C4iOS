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
import C4Core

public class C4CanvasController : UIViewController {
    /**
    Called after the controller's view is loaded into memory.
    
    This override disables implicit CALayer animations, calls `setup()` and then re-enables animations.
    
    You should **not** override this method, instead use **setup()**.
    */
    public override func viewDidLoad() {
        C4ShapeLayer.disableActions = true
        self.setup()
        C4ShapeLayer.disableActions = false
    }

    /**
    Called during the controller's `viewDidLoad()` method. 
    
    This method should be used to set up any objects or behaviours necessary when the controller's view loads.
    */
    public func setup() {
    }
}
