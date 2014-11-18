//
//  C4Events.swift
//  C4iOS
//
//  Created by travis on 2014-11-07.
//  Copyright (c) 2014 C4. All rights reserved.
//

import Foundation

public protocol EventSource {
    func post(event: String)
    func on(event notificationName: String, run executionBlock: Void -> Void) -> AnyObject
    func on(event notificationName: String, from objectToObserve: AnyObject?, run executionBlock: Void -> Void) -> AnyObject
    func cancel(observer: AnyObject)
    func cancel(event: String, observer: AnyObject)
    func cancel(event: String, observer: AnyObject, object: AnyObject)
    func watch(property: String, of object: NSObject)
}