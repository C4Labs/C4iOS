//
//  C4ImageView.h
//  C4iOS
//
//  Created by moi on 13-02-18.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface C4ImageView : UIImageView

-(C4Layer *)imageLayer;
-(void)rotationDidFinish:(CGFloat)newRotationAngle;
@end
