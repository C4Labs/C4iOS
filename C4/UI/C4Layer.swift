//
//  C4ImageLayer.swift
//  C4iOS
//
//  Created by travis on 2016-01-04.
//  Copyright © 2016 C4. All rights reserved.
//

import QuartzCore

public class C4Layer: CALayer {
    ///  Configures basic options for a CABasicAnimation.
    ///
    ///  The options set in this method are favorable for the inner workings of C4's animation behaviours.
    public override func actionForKey(key: String) -> CAAction? {
        if C4ShapeLayer.disableActions == true {
            return nil
        }

        if key == "contents" {
            let animation = CABasicAnimation(keyPath: key)
            animation.configureOptions()
            animation.fromValue = self.contents
            return animation;
        }
        return super.actionForKey(key)
    }
}