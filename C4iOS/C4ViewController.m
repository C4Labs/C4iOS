//
//  C4ViewController.m
//  C4iOS
//
//  Created by Travis Kirton on 12-05-16.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4ViewController.h"

@interface C4ViewController ()

@end

@implementation C4ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

#pragma mark Notification Methods
-(void)listenFor:(NSString *)notification andRunMethod:(NSString *)methodName {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:nil];
}

-(void)listenFor:(NSString *)notification fromObject:(id)object andRunMethod:(NSString *)methodName {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:object];
}

-(void)listenFor:(NSString *)notification fromObjects:(NSArray *)objectArray andRunMethod:(NSString *)methodName {
    for (id object in objectArray) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:object];
    }
}

-(void)stopListeningFor:(NSString *)methodName {
    [self stopListeningFor:methodName object:nil];
}

-(void)stopListeningFor:(NSString *)methodName object:(id)object {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:methodName object:object];
}

-(void)stopListeningFor:(NSString *)methodName objects:(NSArray *)objectArray {
    for(id object in objectArray) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:methodName object:object];
    }
}

-(void)postNotification:(NSString *)notification {
	[[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:self afterDelay:seconds];
}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:object afterDelay:seconds];
}
@end
