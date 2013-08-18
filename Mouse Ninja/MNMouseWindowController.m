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
@property (nonatomic, assign) NSPoint oldMouseLocation;

- (NSPoint)centerPoint;

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
    self.oldMouseLocation = [NSEvent mouseLocation];
    self.centerRect = [self.window frame];
    [super showWindow:sender];
    [NSApp activateIgnoringOtherApps:YES];
    CGEventRef move = CGEventCreateMouseEvent( NULL, kCGEventMouseMoved, [self centerPoint], kCGMouseButtonLeft );
    CGEventPost( kCGHIDEventTap, move );
    CFRelease( move );
}

#pragma mark MNMouseWindowController Private

- (NSPoint)centerPoint;
{
    return NSMakePoint( CGRectGetMidX( self.centerRect ), CGRectGetHeight( self.window.frame ) - CGRectGetMidY( self.centerRect ) );
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

    CGEventRef move = CGEventCreateMouseEvent( NULL, kCGEventMouseMoved, [self centerPoint], kCGMouseButtonLeft );
    CGEventPost( kCGHIDEventTap, move );
    CFRelease( move );
}

- (void)mouseViewShouldFinish:(MNMouseView *)view;
{
    [NSApp hide:self];

    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        CGEventRef mouseDown = CGEventCreateMouseEvent( NULL, kCGEventLeftMouseDown, [self centerPoint], kCGMouseButtonLeft );
        CGEventRef mouseUp = CGEventCreateMouseEvent( NULL, kCGEventLeftMouseUp, [self centerPoint], kCGMouseButtonLeft );
        CGEventPost( kCGHIDEventTap, mouseDown );
        [NSThread sleepForTimeInterval:0.05];
        CGEventPost( kCGHIDEventTap, mouseUp );
        CFRelease( mouseDown );
        CFRelease( mouseUp );

        view.path = nil;
        [self close];
    });
}

- (void)mouseViewShouldCancel:(MNMouseView *)view;
{
    CGPoint location = CGPointMake( self.oldMouseLocation.x, CGRectGetHeight( self.window.frame ) - self.oldMouseLocation.y );
    CGEventRef move = CGEventCreateMouseEvent( NULL, kCGEventMouseMoved, location, kCGMouseButtonLeft );
    CGEventPost( kCGHIDEventTap, move );
    CFRelease( move );

    view.path = nil;
    [self close];
}

@end
