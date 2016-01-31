// Copyright © 2016 C4
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

import ReplayKit

public class ScreenRecorder: NSObject, RPPreviewViewControllerDelegate {
    public typealias PreviewControllerFinishedAction = (activities: Set<String>?) -> ()
    public typealias RecorderStoppedAction = () -> ()

    var recorder: RPScreenRecorder?
    var preview: RPPreviewViewController?
    var activities: Set<String>?

    public var controller: UIViewController?
    public var previewFinished: PreviewControllerFinishedAction?
    public var didStop: RecorderStoppedAction?
    public var microphoneEnabled = false

    public override init() {
        super.init()
        recorder = RPScreenRecorder.sharedRecorder()
    }

    public func start() {
        recorder?.startRecordingWithMicrophoneEnabled(microphoneEnabled) { error in
            if error != nil {
                print("Start Recording Error: \(error?.localizedDescription)")
            }
        }
    }

    public func start(duration: Double) {
        preview = nil

        start()
        delay(duration) {
            self.stop()
        }
    }


    public func stop() {
        recorder?.stopRecordingWithHandler { previewViewController, error in
            self.preview = previewViewController
            self.preview?.previewControllerDelegate = self
            self.didStop?()
        }
    }

    public func showPreview() {
        guard let p = preview else {
            print("Recorder has no preview to show.")
            return
        }

        controller?.presentViewController(p, animated: true, completion: nil)
    }

    public func previewController(previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        self.activities = activityTypes
    }

    public func previewControllerDidFinish(previewController: RPPreviewViewController) {
        if let f = self.previewFinished {
            f(activities: self.activities)
        }
        if let c = self.controller {
            c.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
