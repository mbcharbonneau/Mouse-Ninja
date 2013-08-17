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

@property (nonatomic, assign) NSRect centerRect;

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

- (void)showWindow:(id)sender;
{
    self.centerRect = [self.window frame];
    [super showWindow:sender];
    [self.window.contentView setNeedsDisplay:YES];
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

- (void)mouseView:(MNMouseView *)view removeDirection:(MNDirection)direction;
{
    CGFloat x = CGRectGetMinX( self.centerRect );
    CGFloat y = CGRectGetMinY( self.centerRect );
    CGFloat width = CGRectGetWidth( self.centerRect );
    CGFloat height = CGRectGetHeight( self.centerRect );
    
    switch ( direction )
    {
        case MNDirectionUp:
            height -= CGRectGetMidY( self.centerRect )  - CGRectGetMinY( self.centerRect );
            break;
        case MNDirectionDown:
            y += CGRectGetMidY( self.centerRect ) - CGRectGetMinY( self.centerRect );
            height -= CGRectGetHeight( self.centerRect ) / 2.0f;
            break;
        case MNDirectionRight:
            width -= CGRectGetMidX( self.centerRect ) - CGRectGetMinX( self.centerRect );
            break;
        case MNDirectionLeft:
            x += CGRectGetMidX( self.centerRect ) - CGRectGetMinX( self.centerRect );
            width -= CGRectGetWidth( self.centerRect ) / 2.0f;
            break;
    }

    self.centerRect = NSMakeRect( x, y, width, height );

    NSBezierPath *path = [[NSBezierPath alloc] init];

    [path appendBezierPathWithRect:NSMakeRect( 0.0f, 0.0f, CGRectGetMinX( self.centerRect ), CGRectGetHeight( view.frame ) )];
    [path appendBezierPathWithRect:NSMakeRect( CGRectGetMaxX( self.centerRect ), 0.0f, CGRectGetMaxX( view.frame ), CGRectGetHeight( view.frame ) )];
    [path appendBezierPathWithRect:NSMakeRect( 0.0f, 0.0f, CGRectGetWidth( view.frame ), CGRectGetMinY( self.centerRect ) )];
    [path appendBezierPathWithRect:NSMakeRect( 0.0f, CGRectGetMaxY( self.centerRect ), CGRectGetWidth( view.frame ), CGRectGetMaxY( view.frame ) )];

    view.path = path;
}

- (void)mouseViewShouldCancel:(MNMouseView *)view;
{
    view.path = nil;
    [self close];
}

@end
