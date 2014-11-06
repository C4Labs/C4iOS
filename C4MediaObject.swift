//
//  C4MediaObject.swift
//  C4Swift
//
//  Created by travis on 2014-11-05.
//  Copyright (c) 2014 C4. All rights reserved.
//

import Foundation
import C4Core
import C4iOS
import AVFoundation

protocol MediaObject: Run, Notification {
    func setup()
}

protocol VisibleMediaObject: MediaObject, Visible, Interactive, Animatable {
    
}

protocol Run {
    func run()
    func run(delay: Double)
}

protocol Notification {
    typealias NotificationClosure = (notification: NSNotification) -> ()
    
    func post(notification: String)
    func listen(notification: String, run: NotificationClosure)
    func listen(notification: String, object: AnyObject, run: NotificationClosure)
    func listen(notification: String, objects: [AnyObject], run: NotificationClosure)
    func stopListening(notification: String)
    func stopListening(notification: String, object: AnyObject)
    func stopListening(notification: String, objects: [AnyObject])
}

protocol Visible {
    var frame: C4Rect { get set }
    var bounds: C4Rect { get }
    var center: C4Point { get set }
    var width: Double { get set }
    var height: Double { get set }
    var size: C4Size { get }
    var constrainsProportions: Bool { get set }
    //    var transform: ?? { get set } //not sure we need this
    
    var backgroundColor: C4Color { get set }
    var alpha: Double { get set }
    //consistent alpha, or opacity? throughout the api
    var hidden: Bool { get set }
    var borderWidth: Double { get set }
    var borderHeight: Double { get set }
    var borderColor: C4Color { get set }
    var cornerRadius: Double { get set }
    //potential idea: struct border > .width, .height, .color, .radius
    
    var shadowRadius: Double { get set }
    var shadowColor: C4Color { get set }
    var shadowOffset: C4Point { get set }
    var shadowOpacity: Double { get set }
    var shadowPath: C4Path { get set }
    //potential idea: struct shadow > ... (see above)
    
    var masksToBounds: Bool { get set } //clips or masks? should be consistent throughout
    var mask: Maskable { get set }
    
    var rotation: Double { get set }
    var rotationX: Double { get set }
    var rotationZ: Double { get set }
    //idea: struct rotation > .z, .x, .y
    var perspectiveDistance: Double { get set }
    var anchorPoint: C4Point { get set }
//    var layerTransform: CATransform3D { get set } //not sure if we need this, could bury in effects of changing rotation struct
    
    func add(subview: Visible)
    func add(subviews: [Visible])
    func remove(subview: Visible)
    func remove(subviews: [Visible])
    func removeFromSuperview()
    
    func sizeToFit() //generic version of adjustsToFitPath() that makes the frame the contain its contents
}

protocol Interactive {
    var interactionEnabled: Bool { get set }
    
    //I don't like the name closure here...
    typealias C4TapClosure = (location: C4Point) -> ()
    typealias C4PanClosure = (location: C4Point, translation: C4Point, velocity: C4Point) -> ()
    typealias C4PinchClosure = (location: C4Point, scale: Double, velocity: Double) -> ()
    typealias C4RotationClosure = (location: C4Point, rotation: Double, velocity: Double) -> ()
    typealias C4LongPressClosure = (location: C4Point) -> ()
    typealias C4SwipeClosure = (location: C4Point) -> ()
    
    //i also really don't like it here either
    func onTap(closure: C4TapClosure)
    func onPan(closure: C4PanClosure)
    func onPinch(closure: C4PinchClosure)
    func onRotate(closure: C4RotationClosure)
    func onLongPress(closure: C4LongPressClosure)
    func onSwipe(closure: C4SwipeClosure)
    
    func tapped()
    func tapped(location: C4Point)
    func panned()
    func panned(location: C4Point, translation: C4Point, velocity: C4Point)
    func pinched()
    func pinched(location: C4Point, scale: Double, velocity: Double)
    func rotated()
    func rotated(location: C4Point, rotation: Double, velocity: Double)
    func swipedLeft()
    func swipedRight()
    func swipedUp()
    func swipedDown()
    func longPressStarted()
    func longPressStarted(location: C4Point)
    func longPressUpdated()
    func longPressUpdated(location: C4Point)
    func longPressEnded()
    func longPressEnded(location: C4Point)
    func move(location: C4Point)
}

protocol Animatable {

    var animationDuration: Double { get set }
    var animationDelay: Double { get set }
    var animationOptions: Int { get set }
    
    func animate()
}

protocol Maskable {
    //objects that can be used as a mask
}

protocol Style {
    //copying, setting, default styles
}

protocol Playback {
    var duration: Double { get }
    var currentTime: Double { get }
    var deviceCurrentTime: Double { get }
    var isPlaying: Bool { get }
    var loops: Bool { get set }
    var loopCount: Int { get set }
    var autoplays: Bool { get set }
    var rate: Double { get set }
    var rateEnabled: Bool { get set }
    
    func play()
    func play(at time:Double)
    func pause()
    func stop()
    func prepare()
    func seek(to time: Double)
    func seek(byAdding time: Double)
    func ended() -> Bool //returns true for normally, false otherwise
}

protocol Audio {
    var volume: Double { get set }
}

struct Original {
    var size: C4Size { get{ return C4Size() } }
    var ratio: Double { get{ return 0.0} }
}

//class
protocol Movie: VisibleMediaObject {
    var original: Original { get }
    var audioMix: AVMutableAudioMix { get }
    var player: AVPlayer { get }

    func initialize(fileName: String)
    func initialize(fileName: String, frame: C4Rect)
    func initialize(url: NSURL)
    func initialize(url: NSURL, frame: C4Rect)
}

//class
protocol Sound: MediaObject {
    var pan: Double { get set }
    var player: AVAudioPlayer { get }
    var numberOfChannels: Int { get }
    var meteringEnabled: Bool { get set }
    var settings: Dictionary<String,AnyObject> { get } //audio player settings, etc.
    
    func initialize(fileName: String)
    func initialize(fileName: NSURL)
    func peakPower(channel: Int) -> Double
    func averagePower(channel: Int) -> Double
    func updateMeters()
}

struct CameraPosition {
    // front, back
}

struct CaptureQuality {
    //etc.
}

struct CameraSpecs {
    var quality: CaptureQuality
    var position: CameraPosition
}

protocol CameraDelegate {
    func cameraDidCaptureImage()
}

//class
protocol Camera: VisibleMediaObject {
    var initialized: Bool { get }
    var capturedImage: Image { get }
    var position: CameraPosition { get set }
    var quality: CaptureQuality { get set }
    var session: AVCaptureSession { get }
    var delegate: CameraDelegate { get set }
    
    func initialize(frame: C4Rect)
    func initialize(frame: C4Rect, specs: CameraSpecs)
    func startCapturing()
    func stopCapturing()
}

//class
protocol Font: MediaObject {
    var UIFont: UIFont { get }
    var CTFont: CTFont { get }
    var CGFont: CGFont { get }
    var familyName: String { get }
    var fontName: String { get }
    var pointSize: Double { get set }
    var ascender: Double { get }
    var descender: Double { get }
    var capHeight: Double { get }
    var xHeight: Double { get }
    var lineHeight: Double { get }
}

//class
protocol Image: VisibleMediaObject {
    var pixelsLoaded: Bool { get set }
    var original: original { get }
    var contents: CGImage { get }

    func initialize(fileName: String)
    func initialize(image: Image)
    func initialize(data: NSData)
    func initialize(uiimage: UIImage)
    func initialize(url: NSURL)
    func initialize(fileName: String)
    func initialize(cgimage: CGImage)
//        -(id)initWithRawData:(unsigned char *)data width:(NSInteger)width height:(NSInteger)height; // not sure how to convert

    func loadPixels()
    func unloadPixels()
    func color(at: C4Color) -> Color
    func apply(filter: Filter)
    func apply(filters: [Filter])
}

//extension
protocol AnimatedImage {
    var images: [Image] { get }
    var rate: Double { get set } //set explicity .25s, etc.
    var duration: Double { get set } //convenience, set 10s, calculates rate based on duration / image count

    func initialize(fileNames: [String])
    
    var currentFrame: Int { get }
    func seek(to frame: Int)
    // methods from Playback, could have most of them be optional in protocol and not implemented here.
    var isPlaying: Bool { get }
    var loops: Bool { get set }
    var loopCount: Int { get set }
    var autoplays: Bool { get set }

    func play()
    func pause()
    func ended() -> Bool //returns true for normally, false otherwise
}

//class
protocol Filter: MediaObject {
    var availableFilters: [String]
    class func filter(var1: AnyObject, var2: AnyObject) -> Filter //and then all the rest
    func applyTo(inout image: Image)
    
    class func filterType(var1: AnyObject, var2: AnyObject) -> Image //and then all the rest
    
}

//class
protocol Timer: VisibleMediaObject {
    var valid: Bool { get }
    var fireDate: NSDate { get set }
    var interval: Double { get }
    var info: AnyObject { get }

    func initialize(seconds: Double, target: AnyObject, completion: (()))
    func initialize(seconds: Double, target: AnyObject, completion: (()), repeats: Bool)
    func fire()
    func start()
    func stop()
    func invalidate()
}

struct ControlEvent {}

protocol UI {
    func run(function:((sender: AnyObject)), event: ControlEvent)
    func run(function:((sender: AnyObject)), events: [ControlEvent])
    func stopRunning(event: ControlEvent)
    func stopRunning(events: [ControlEvent])
}

struct ButtonType {}
struct ControlState {}
//class
protocol Button: VisibleMediaObject {
    var buttonType: ButtonType { get set }
    var title: String { get } //the current title
    var attributedTitle: String { get } //the current attributed title
    var titleColor: Color { get } //the current title color
    var titleShadowColor: Color { get } //the current title shadow color
    var image: Image { get } //the current image
    var backgroundImage: Image { get } //the current backgroundImage
    var tintColor: Color { get set }
    var font: Font { get set }
    var showsTouchWhenHighlighted: Bool { get set }
    var UIButton: UIButton { get }

    func initialize(type: ButtonType)
    func initialize(type: ButtonType, frame: C4Rect)

    //title
    var reversesTitleShadowWhenHighlighted: Bool { get set }

    func set(title: String, state: ControlState)
    func set(attributedTitle: AttributedString, state: ControlState)
    func set(titleColor: Color, state: ControlState)
    func set(titleShadowColor: Color, state: ControlState)
    func title(forState state: ControlState)
    func attributedTitle(forState state: ControlState)
    func titleColor(forState state: ControlState)
    func titleShadowColor(forState state: ControlState)
    
    //image
    var adjustsImageWhenHighlighted: Bool { get set }
    var adjustsImageWhenDisabled: Bool { get set }
    
    func set(image: Image, state: ControlState)
    func set(backgroundImage: Image, state: ControlState)
    func image(forState state: ControlState)
    func backgroundImage(forState state: ControlState)
    
    //edges
    var contentInsets: UIEdgeInsets { get set }
    var titleInsets: UIEdgeInsets { get set }
    var imageInsets: UIEdgeInsets { get set }
}

struct BaselineAdjustment {}
struct TextAlignment {}
struct LineBreakMode {}
		
//class
protocol Label: VisibleMediaObject {
	var text: String { get set }
	var font: Font { get set }
	var adjustsToWidth: Bool { get set }
	var baseline: BaselineAdjustment { get set }
	var highlighted: Bool { get set }
	var textColor: Color { get set }
	var textHiglightedColor: Color { get set }
	var textShadowColor: Color { get set }
	var alignment: TextAlignment { get set }
	var lineBreak: LineBreakMode { get set }
	var minimumFontSize: Double { get set }
	var numberOfLines: Int { get set }
	var textShadowOffset: C4Point { get set }
	var UILabel : UILabel { get }
	
	func initialize(text: String)
	func initialize(text: String, font: Font)
	func initialize(text: String, font: Font, frame: C4Rect)
}

struct IndicatorStyle {}

//class
protocol ScrollView: VisibleMediaObject {
	var delegate: UIScrollViewDelegate { get set }
	var contentOffset: C4Point { get set }
	var contentSize: C4Size { get set }
	var contentInset: UIEdgeInsets { get set }
	var scrollEnabled: Bool { get set }
	var directionalLockEnabled: Bool { get set }
	var scrollsToTop: Bool { get set }
	var pagingEnabled: Bool { get set }
	var bounces: Bool { get set }
	var bouncesVertical: Bool { get set }
	var bouncesHorizontal: Bool { get set }
	var cancelsContentTouches: Bool { get set }
	var delaysContentTouches: Bool { get set }
	var deceleration: Double { get set }
	var dragging: Bool { get }
	var tracking: Bool { get }
	var decelerating: Bool { get }
	
	var indicatorStyle: IndicatorStyle { get set }
	var indicatorInsets: UIEdgeInsets { get set }
	var showsHorizontalIndicator: Bool { get set }
	var showsVerticalIndicator: Bool { get set}
	
	var panRecognizer: UIPanGestureRecognizer { get }
	var pinchRecognizer: UIPinchGestureRecognizer { get }
	var zoomScale: Double { get set }
	var maxZoomScale: Double { get set }
	var minZoomScale: Double { get set }
	var zoomBounces: Bool { get set }
	var zooming: Bool { get set }

	var UIScrollView: UIScrollView { get }
	
	func initialize(frame: C4Rect)
	// func set(offset: C4Point, animated: Bool) //not sure if we need this function
	func scroll(toPoint point: C4Point, animated: Bool)
	func scroll(toRect rect: C4Rect, animated: Bool)
	func flashIndicators()
	func zoom(toRect rect: C4Rect, animated: Bool)
	func set(zoomScale: Double, animated: Bool)
	func touchesShouldCancelInContentView(view: UIView) -> Bool
}

//class
protocol Slider: VisibleMediaObject {
	var value: Double { get set }
	var minValue: Double { get set }
	var maxValue: Double { get set }
	var continuous: Bool { get set }
	var minValueImage: Image { get set }
	var maxValueImage: Image { get set }
	var minTrackTintColor: Color { get } //for current state
	var maxTrackTintColor: Color { get } //for current state
	var thumbTintColor: Color { get } //for current state
	var minTrackImage: Image { get } //for current state
	var maxTrackImage: Image { get } //for current state
	var thumbImage: Image { get } //for current state
	var UISlider: UISlider { get }
	//min / max labels?
	
	func initialize(frame: C4Rect)
	func set(value: Double, animated: Bool)
	func set(minTrackImage: Image, state: ControlState)
	func minTrackImage(state: ControlState) -> Image 
	func set(maxTrackImage: Image, state: ControlState)
	func maxTrackImage(state: ControlState) -> Image 
	func set(thumbTintColor: Color, state: ControlState)
	func thumbTintColor(state: ControlState) -> Color 
	func set(thumbImage: Image, state: ControlState)
	func thumbImage(state: ControlState) -> Image
}

//class
protocol Stepper: VisibleMediaObject {
	var continuous: Bool { get set }
	var autorepeats: Bool { get set }
	var wraps: Bool { get set }
	var minValue: Double { get set }
	var maxValue: Double { get set }
	var stepValue: Double { get set }
	var value: Double { get set }
	var tintColor: Color { get set }
	var UIStepper: UIStepper { get }
	
	func initialize() // because they're always the same size?
	func background(image: Image, state: ControlState)
	func backgroundImage(state: ControlState)
	func decrement(image: Image, state: ControlState)
	func decrementImage(state: ControlState)
	func divider(image: Image, state: ControlState)
	func dividerImage(state: ControlState)
	func increment(image: Image, state: ControlState)
	func incrementImage(state: ControlState)
}

//class
protocol Switch: VisibleMediaObject {
	var on: Bool { get set }
	var onTintColor: Color { get set }
	var tintColor: Color { get set }
	var thumbTintColor: Color { get set }
	var onImage: Image { get set }
	var offImage: Image { get set }
	var UISwitch: UISwitch { get }
	
	func initialize() // because they're always the same size?
	func set(on: Bool, animated: Bool)
}

struct ActivityIndicatorStyle {}
	
//class
protocol ActivityIndicator {
	func initialize(style: ActivityIndicatorStyle)

	var animating: Bool { get }
	var style: ActivityIndicatorStyle { get set }
	var hidesWhenStopped: Bool { get set }
	var color: Color { get set }
	var UIActivityIndicatorView: UIActivityIndicatorView { get }
	
	func start()
	func stop()
}


extension UIColor {
	var CIColor: CIColor {
		get {
			CIColor()
		}
	}
}