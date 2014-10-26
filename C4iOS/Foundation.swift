//
//  Foundation.swift
//  C4iOS
//
//  Created by travis on 2014-10-26.
//  Copyright (c) 2014 C4. All rights reserved.
//

import CoreGraphics

/**
Prints a string to the console. Replacement for the noisy NSlog.

:param: string A formatted string that will print to the console
*/
public func C4Log(string: String) {
    println("[C4Log] \(string)")
}

/**
Returns a rectangle that contains all of the specified coordinates in an array.

:param: points An array of CGPoint coordinates
*/
public func CGRectMake(points: [CGPoint]) -> CGRect {
    var path = CGPathCreateMutable()
    CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
    for i in 1..<points.count {
        CGPathAddLineToPoint(path, nil, points[i].x, points[i].y)
    }
    return CGPathGetBoundingBox(path)
}

/**
Returns a bounding rectangle with the specified values for building an arc.

:param: center The center coordinate around which the arc will be drawn
:param: radius The radius of the arc
:param: startAngle The start angle of the arc
:param: endAngle The end angle of the arc
:param: clockwise The direction to draw the arc
*/
public func CGRectMakeFromArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) -> CGRect {
    var path = CGPathCreateMutable()
    CGPathAddArc(path, nil, center.x, center.y, radius, startAngle, endAngle, !clockwise)
    return CGPathGetBoundingBox(path)
}

/**
Returns a bounding rectangle with the specified values for building an wedge (includes the centerpoint when calculating the shape).

:param: center The center coordinate around which the wedge will be drawn
:param: radius The radius of the wedge
:param: startAngle The start angle of the wedge
:param: endAngle The end angle of the wedge
:param: clockwise The direction to draw the wedge
*/
public func CGRectMakeFromWedge(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) -> CGRect {
    var path = CGPathCreateMutable()
    CGPathAddArc(path, nil, center.x, center.y, radius, startAngle, endAngle, !clockwise)
    CGPathAddLineToPoint(path, nil, center.x, center.y)
    return CGPathGetBoundingBox(path)
}