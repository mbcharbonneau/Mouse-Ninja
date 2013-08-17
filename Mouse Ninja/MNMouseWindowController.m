//
//  MNMouseWindowController.m
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/17/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import "MNMouseWindowController.h"
#import "MNMouseWindow.h"
#import "MNMouseView.h"

@interface MNMouseWindowController ()

@end

@implementation MNMouseWindowController

#pragma mark MNMouseWindowController

+ (instancetype)sharedMouseWindowController;
{
    static MNMouseWindowController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });

    return sharedController;
}

#pragma mark NSObject

- (id)init;
{
    NSRect frame = [[NSScreen mainScreen] frame];
    MNMouseWindow *mouseWindow = [[MNMouseWindow alloc] initWithContentRect:frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES];
    MNMouseView *mouseView = [[MNMouseView alloc] initWithFrame:frame];

    mouseView.delegate = self;

    [mouseWindow setBackgroundColor:[NSColor clearColor]];
    [mouseWindow setOpaque:NO];
    [mouseWindow setContentView:mouseView];
    [mouseWindow setInitialFirstResponder:mouseView];
    [mouseWindow setLevel:CGShieldingWindowLevel()];

    return [self initWithWindow:mouseWindow];
}

#pragma mark MNMouseViewDelegate

- (void)mouseView:(MNMouseView *)view sliceDirection:(MNDirection)direction;
{
    
}

- (void)mouseViewShouldCancel:(MNMouseView *)view;
{
    [self close];
}

@end
