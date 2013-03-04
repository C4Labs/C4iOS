//
//  C4UIElement.h
//  C4iOS
//
//  Created by moi on 13-02-28.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol C4UIElement <NSObject>
-(void)runMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event;
-(void)stopRunningMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event;
@end
