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
#import "MNConstants.h"

#define MIN_BOX_SIZE 20.0f

@interface MNMouseWindowController ()

@property (nonatomic, assign) NSRect centerRect;
@property (nonatomic, assign) NSPoint oldMouseLocation;

- (NSPoint)centerPoint;
- (NSArray *)createGuidesInsideRect:(NSRect)centerRect;

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

#pragma mark MNMouseWindowController Private

- (NSPoint)centerPoint;
{
    return NSMakePoint( CGRectGetMidX( self.centerRect ), CGRectGetHeight( self.window.frame ) - CGRectGetMidY( self.centerRect ) );
}

- (NSArray *)createGuidesInsideRect:(NSRect)centerRect;
{
    if ( ![[NSUserDefaults standardUserDefaults] boolForKey:MNEnableGuideLinesDefaultsKey] )
        return @[];

    NSMutableArray *guides = [[NSMutableArray alloc] initWithCapacity:4];

    CGFloat top = CGRectGetMinY( centerRect ) + CGRectGetHeight( centerRect ) / 4.0f;
    CGFloat bottom = CGRectGetMidY( centerRect ) + CGRectGetHeight( centerRect ) / 4.0f;

    if ( CGRectGetWidth( centerRect ) >= MIN_BOX_SIZE * 2.0f )
    {
        CGFloat left = CGRectGetMinX( centerRect ) + CGRectGetWidth( centerRect ) / 4.0f;
        CGFloat right = CGRectGetMidX( centerRect ) + CGRectGetWidth( centerRect ) / 4.0f;

        NSBezierPath *leftGuide = [[NSBezierPath alloc] init];
        [leftGuide moveToPoint:NSMakePoint( left, CGRectGetMinY( centerRect ) )];
        [leftGuide lineToPoint:NSMakePoint( left, CGRectGetMaxY( centerRect ) )];

        NSBezierPath *rightGuide = [[NSBezierPath alloc] init];
        [rightGuide moveToPoint:NSMakePoint( right, CGRectGetMinY( centerRect ) )];
        [rightGuide lineToPoint:NSMakePoint( right, CGRectGetMaxY( centerRect ) )];

        [guides addObject:leftGuide];
        [guides addObject:rightGuide];
    }

    if ( CGRectGetHeight( centerRect ) >= MIN_BOX_SIZE * 2.0f )
    {
        NSBezierPath *topGuide = [[NSBezierPath alloc] init];
        [topGuide moveToPoint:NSMakePoint( CGRectGetMinX( centerRect ), top )];
        [topGuide lineToPoint:NSMakePoint( CGRectGetMaxX( centerRect ), top )];

        NSBezierPath *bottomGuide = [[NSBezierPath alloc] init];
        [bottomGuide moveToPoint:NSMakePoint( CGRectGetMinX( centerRect ), bottom )];
        [bottomGuide lineToPoint:NSMakePoint( CGRectGetMaxX( centerRect ), bottom )];

        [guides addObject:topGuide];
        [guides addObject:bottomGuide];
    }

    return guides;
}

#pragma mark NSWindowController

- (IBAction)showWindow:(id)sender;
{
    self.oldMouseLocation = [NSEvent mouseLocation];
    self.centerRect = [self.window frame];
    ((MNMouseView *)self.window.contentView).guidePaths = [self createGuidesInsideRect:self.centerRect];
    [super showWindow:sender];
    [NSApp activateIgnoringOtherApps:YES];
    CGEventRef move = CGEventCreateMouseEvent( NULL, kCGEventMouseMoved, [self centerPoint], kCGMouseButtonLeft );
    CGEventPost( kCGHIDEventTap, move );
    CFRelease( move );
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
            if ( height > MIN_BOX_SIZE )
            {
                height -= CGRectGetMidY( self.centerRect )  - CGRectGetMinY( self.centerRect );
            }
            else
            {
                y = MAX( y - 1, CGRectGetMinY( view.frame ) );
            }
            break;
        case MNDirectionDown:
            if ( height > MIN_BOX_SIZE )
            {
                y += CGRectGetMidY( self.centerRect ) - CGRectGetMinY( self.centerRect );
                height -= CGRectGetHeight( self.centerRect ) / 2.0f;
            }
            else
            {
                y = MIN( y + 1, CGRectGetMaxY( view.frame ) - MIN_BOX_SIZE / 2.0f );
            }
            break;
        case MNDirectionRight:
            if ( width > MIN_BOX_SIZE )
            {
                width -= CGRectGetMidX( self.centerRect ) - CGRectGetMinX( self.centerRect );
            }
            else
            {
                x = MAX( x - 1, CGRectGetMinX( view.frame ) );
            }
            break;
        case MNDirectionLeft:
            if ( width > MIN_BOX_SIZE )
            {
                x += CGRectGetMidX( self.centerRect ) - CGRectGetMinX( self.centerRect );
                width -= CGRectGetWidth( self.centerRect ) / 2.0f;
            }
            else
            {
                x = MIN( x + 1, CGRectGetMaxX( view.frame ) - MIN_BOX_SIZE / 2.0f );
            }
            break;
    }

    self.centerRect = NSMakeRect( x, y, width, height );

    NSBezierPath *path = [[NSBezierPath alloc] init];

    [path appendBezierPathWithRect:NSMakeRect( 0.0f, 0.0f, CGRectGetMinX( self.centerRect ), CGRectGetHeight( view.frame ) )];
    [path appendBezierPathWithRect:NSMakeRect( CGRectGetMaxX( self.centerRect ), 0.0f, CGRectGetMaxX( view.frame ), CGRectGetHeight( view.frame ) )];
    [path appendBezierPathWithRect:NSMakeRect( 0.0f, 0.0f, CGRectGetWidth( view.frame ), CGRectGetMinY( self.centerRect ) )];
    [path appendBezierPathWithRect:NSMakeRect( 0.0f, CGRectGetMaxY( self.centerRect ), CGRectGetWidth( view.frame ), CGRectGetMaxY( view.frame ) )];

    view.path = path;
    view.guidePaths = [self createGuidesInsideRect:self.centerRect];

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
        view.guidePaths = nil;

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
    view.guidePaths = nil;

    [self close];
}

@end
