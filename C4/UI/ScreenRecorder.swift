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
    public typealias PreviewControllerFinishedAction = (_ activities: Set<String>?) -> ()
    public typealias RecorderStoppedAction = () -> ()

    let recorder = RPScreenRecorder.shared()
    var preview: RPPreviewViewController?
    var activities: Set<String>?

    public var previewFinishedAction: PreviewControllerFinishedAction?
    public var recordingEndedAction: RecorderStoppedAction?
    public var enableMicrophone = false

    public var recording: Bool {
        return recorder.isRecording
    }

    public var available: Bool {
        return recorder.isAvailable
    }

    public func start() {
        if !recording && available {
            preview = nil
            recorder.startRecording(withMicrophoneEnabled: enableMicrophone) { error in
                if let error = error {
                    print("Start Recording Error: \(error.localizedDescription)")
                }
            }
        }
    }

    public func start(_ duration: Double) {
        start()
        wait(duration) {
            self.stop()
        }
    }

    public func stop() {
        recorder.stopRecording { previewViewController, error in
            self.preview = previewViewController
            self.preview?.previewControllerDelegate = self
            self.recordingEndedAction?()
        }
    }

    public func showPreviewInController(_ controller: UIViewController) {
        guard let preview = preview else {
            print("Recorder has no preview to show.")
            return
        }

        controller.present(preview, animated: true, completion: nil)
    }

    public func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        activities = activityTypes
    }

    public func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewFinishedAction?(activities)
        preview?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
