//
//  C4Timer.swift
//  C4Swift
//
//  Created by travis on 2015-09-21.
//  Copyright © 2015 C4. All rights reserved.
//

import Foundation

public class C4Timer : NSObject {
    var timer : NSTimer!
    var timerCanStart = false
    var properties = [String : AnyObject]()

    func setup() {
    }

    public class func timerWithTimeInterval(ti: NSTimeInterval,
        target aTarget: AnyObject,
        selector aSelector: Selector,
        userInfo: AnyObject?,
        repeats yesOrNo: Bool) -> C4Timer {
            let timer = C4Timer(timeInterval: ti, target: aTarget, selector: aSelector, userInfo: userInfo, repeats: yesOrNo)
            return timer
    }
    public convenience init(timeInterval ti: NSTimeInterval,
        target aTarget: AnyObject,
        selector aSelector: Selector,
        userInfo: AnyObject?,
        repeats yesOrNo: Bool) {
            self.init()
            timer = NSTimer(timeInterval: ti, target: aTarget, selector: aSelector, userInfo: userInfo, repeats: yesOrNo)
            properties.removeAll()
            properties["ti"] = ti
            properties["target"] = aTarget
            properties["selector"] = String.init(CString: sel_getName(aSelector), encoding: NSUTF8StringEncoding)
            if let ui = userInfo {
                properties["userInfo"] = ui
            }
            properties["repeats"] = yesOrNo
            timerCanStart = true
    }

    public func fire() {
        timer?.fire()
    }

    public func start() {
        if let t = timer {
            if t.valid {
                NSRunLoop.mainRunLoop().addTimer(t, forMode: NSDefaultRunLoopMode)
            }
            else {
                let ti = properties["ti"] as! NSTimeInterval
                let target = properties["target"]
                let selector = Selector(properties["selector"] as! String)
                let repeats = properties["repeats"] as! Bool
                timer = NSTimer(timeInterval: ti, target: target!, selector: selector, userInfo: properties["userInfo"], repeats: repeats)
                timerCanStart = false
                NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
            }
        }
    }

    public func stop() {
        timer.invalidate()
        timerCanStart = true
    }

    public var valid : Bool {
        get {
            return timer.valid
        }
    }

    public var fireDate : NSDate {
        get {
            return timer.fireDate
        } set {
            timer.fireDate = newValue
        }
    }

    public var timeInterval : NSTimeInterval {
        get {
            return timer.timeInterval
        }
    }

    public var userInfo : AnyObject? {
        get {
            return timer.userInfo
        }
    }

    public func invalidate() {
        timer!.invalidate()
    }
}
