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

    let recorder = RPScreenRecorder.sharedRecorder()
    var preview: RPPreviewViewController?
    var activities: Set<String>?

    public var previewFinishedAction: PreviewControllerFinishedAction?
    public var recordingEndedAction: RecorderStoppedAction?
    public var enableMicrophone = false

    public func start() {
        preview = nil
        recorder.startRecordingWithMicrophoneEnabled(enableMicrophone) { error in
            if let error = error {
                print("Start Recording Error: \(error.localizedDescription)")
            }
        }
    }

    public func start(duration: Double) {
        start()
        wait(duration) {
            self.stop()
        }
    }

    public func stop() {
        recorder.stopRecordingWithHandler { previewViewController, error in
            self.preview = previewViewController
            self.preview?.previewControllerDelegate = self
            self.recordingEndedAction?()
        }
    }

    public func showPreviewInController(controller: UIViewController) {
        guard let preview = preview else {
            print("Recorder has no preview to show.")
            return
        }

        controller.presentViewController(preview, animated: true, completion: nil)
    }

    public func previewController(previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        activities = activityTypes
    }

    public func previewControllerDidFinish(previewController: RPPreviewViewController) {
        previewFinishedAction?(activities: activities)
        preview?.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
