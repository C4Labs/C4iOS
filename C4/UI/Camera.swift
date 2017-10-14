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

import UIKit
import AVFoundation

public enum CameraPosition: Int {
    case unspecified = 0
    case back
    case front
}

public class Camera: View {
    public var capturedImage: Image?
    public var quality = AVCaptureSession.Preset.photo
    public var position = CameraPosition.front

    var imageOutput: AVCaptureStillImageOutput?
    var captureDevice: AVCaptureDevice?
    var previewView: CameraView?
    var input: AVCaptureDeviceInput?
    var stillImageOutput: AVCaptureStillImageOutput?
    var captureSession: AVCaptureSession?
    var didCaptureAction: (() -> Void)?
    var orientationObserver: Any?

    class CameraView: UIView {
        var previewLayer: PreviewLayer {
            return self.layer as! PreviewLayer // swiftlint:disable:this force_cast
        }

        override class var layerClass: AnyClass {
            return PreviewLayer.self
        }
    }

    var previewLayer: PreviewLayer {
        return self.cameraView.previewLayer
    }

    var cameraView: CameraView {
        return self.view as! CameraView // swiftlint:disable:this force_cast
    }

    public override init(frame: Rect) {
        super.init()
        view = CameraView()
        view.frame = CGRect(frame)

        previewLayer.backgroundColor = clear.cgColor
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        orientationObserver = on(event: NSNotification.Name.UIDeviceOrientationDidChange) { [unowned self] in
            self.updateOrientation()
        }
    }

    deinit {
        if let observer = orientationObserver {
            cancel(observer)
        }
    }

    public func startCapture(_ position: CameraPosition = .front) {
        self.position = position
        guard let cd = captureDevice(position) else {
            print("Could not retrieve capture device for \(position)")
            return
        }
        initializeInput(cd)

        guard input != nil else {
            print("Could not initialize input for \(cd)")
            return
        }
        initializeOutput(cd)
        captureDevice = cd

        initializeCaptureSession()

        captureSession?.startRunning()

        updateOrientation()
    }

    func captureDevice(_ position: CameraPosition) -> AVCaptureDevice? {
        return AVCaptureDevice.devices(for: AVMediaType.video).first(where: { $0.position.rawValue == position.rawValue })
    }

    func updateOrientation() {
        guard let connection = previewLayer.connection, connection.isVideoOrientationSupported else {
            return
        }

        switch UIApplication.shared.statusBarOrientation {
        case .portraitUpsideDown:
            connection.videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            connection.videoOrientation = .landscapeLeft
        case .landscapeRight:
            connection.videoOrientation = .landscapeRight
        default:
            connection.videoOrientation = .portrait
        }
    }

    func initializeInput(_ device: AVCaptureDevice) {
        if input == nil {
            do {
                input = try AVCaptureDeviceInput(device: device)
            } catch {
                print("Could not create input for device: \(device)")
                return
            }
        }
    }

    func initializeOutput(_ device: AVCaptureDevice) {
        if stillImageOutput == nil {
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        }
    }

    func initializeCaptureSession() {
        if captureSession == nil {
            captureSession = AVCaptureSession()
            previewLayer.session = captureSession
        }
        let session = captureSession!

        session.sessionPreset = quality

        for input in session.inputs {
            session.removeInput(input)
        }
        session.addInput(input!)

        for output in session.outputs {
            session.removeOutput(output)
        }
        session.addOutput(stillImageOutput!)
    }

    public func captureImage() {
        guard stillImageOutput?.isCapturingStillImage == false else {
            print("Still capturing, please wait until I'm done until you put me to work again")
            return
        }

        guard let connection = stillImageOutput?.connection(with: AVMediaType.video) else {
            return
        }

        updateOrientation()
        connection.videoOrientation = previewLayer.connection!.videoOrientation

        stillImageOutput?.captureStillImageAsynchronously(from: connection) { imageSampleBuffer, _ in
            guard imageSampleBuffer != nil else {
                print("Couldn't capture image from still image output")
                return
            }

            let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer! as CMSampleBuffer)

            if let img = UIImage(data: data!) {
                self.capturedImage = Image(uiimage: self.orientRawImage(img))
                self.didCaptureAction?()
            }
        }
    }

    func orientRawImage(_ image: UIImage) -> UIImage {
        guard let cgimg = image.cgImage, let videoOrientation = previewLayer.connection?.videoOrientation else {
            return image
        }

        var orientation: UIImageOrientation
        let shouldFlip = position == .front

        switch videoOrientation {
        case .landscapeLeft:
            orientation = shouldFlip ? .upMirrored : .down
        case .landscapeRight:
            orientation = shouldFlip ? .downMirrored : .up
        case .portrait:
            orientation = shouldFlip ? .leftMirrored : .right
        case .portraitUpsideDown:
            orientation = shouldFlip ? .rightMirrored : .left
        }
        return UIImage(cgImage: cgimg, scale: image.scale, orientation: orientation)
    }

    public func didCaptureImage(_ action: (() -> Void)?) {
        didCaptureAction = action
    }
}

class PreviewLayer: AVCaptureVideoPreviewLayer {

}
