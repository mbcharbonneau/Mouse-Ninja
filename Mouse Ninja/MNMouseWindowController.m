//
//  MNMouseWindowController.m
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/17/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import "MNMouseWindowController.h"
#import "MNMouseView.h"

@interface MNMouseWindowController ()

@end

@implementation MNMouseWindowController

+ (instancetype)sharedMouseWindowController;
{
    static MNMouseWindowController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });

    return sharedController;
}

- (id)init;
{
    NSRect frame = [[NSScreen mainScreen] frame];
    NSWindow *mouseWindow = [[NSWindow alloc] initWithContentRect:frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES];
    MNMouseView *mouseView = [[MNMouseView alloc] initWithFrame:frame];

    [mouseWindow setContentView:mouseView];
    [mouseWindow setLevel:kCGAssistiveTechHighWindowLevelKey];

    return [self initWithWindow:mouseWindow];
}

@end
