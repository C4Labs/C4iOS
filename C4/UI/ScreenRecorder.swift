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

public typealias PreviewControllerFinishedAction = (activities: Set<String>?) -> ()
public typealias RecorderStoppedAction = () -> ()

public class ScreenRecorder: NSObject, RPPreviewViewControllerDelegate {
    internal var recorder: RPScreenRecorder?
    public var preview: RPPreviewViewController?
    public var controller: UIViewController?

    public override init() {
        super.init()
        recorder = RPScreenRecorder.sharedRecorder()
    }

    public func start() {
        guard recorder != nil else {
            print("Recorder was not initialized")
            return
        }

        recorder!.startRecordingWithMicrophoneEnabled(false) { error in
            if error != nil {
                print("Start Recording Error: \(error?.localizedDescription)")
            }
        }
    }

    public func start(duration: Double) {
        preview = nil

        self.start()
        delay(duration) {
            self.stop()
        }
    }

    public var didStop: RecorderStoppedAction?

    public func stop() {
        self.recorder!.stopRecordingWithHandler { previewViewController, error in
            self.preview = previewViewController
            self.preview?.previewControllerDelegate = self
            self.didStop?()
        }
    }

    public func showPreview() {
        guard controller != nil else {
            print("Recorder has no controller in which to present preview.")
            return
        }

        guard let p = preview else {
            print("Recorder has no preview to show.")
            return
        }

        self.controller?.presentViewController(p, animated: true, completion: nil)
    }

    public func presentPreview(viewController: UIViewController) {
        guard preview != nil else {
            print("PreviewRecorder has no movie to preview.")
            return
        }
        viewController.presentViewController(self.preview!, animated: true, completion: nil)
    }

    internal func screenRecorder(screenRecorder: RPScreenRecorder, didStopRecordingWithError error: NSError, previewViewController: RPPreviewViewController?) {
    }

    public var previewFinished: PreviewControllerFinishedAction?

    var activities: Set<String>?
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
