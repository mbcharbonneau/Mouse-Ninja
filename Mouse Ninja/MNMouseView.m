//
//  MNMouseView.m
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/17/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import "MNMouseView.h"

@implementation MNMouseView

#pragma mark NSView

- (id)initWithFrame:(NSRect)frame;
{
    if ( self = [super initWithFrame:frame] ) {
        
        _boxColor = [NSColor colorWithCalibratedWhite:0.08f alpha:0.8f];
        _guideColor = [NSColor blueColor];

        [self addObserver:self forKeyPath:@"boxPath" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"guidesPath" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"boxColor" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"guideColor" options:0 context:NULL];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect;
{
    NSAssert( self.boxColor != nil, @"cannot draw with nil color" );
    NSAssert( self.guideColor != nil, @"cannot draw with nil color" );
    
    [[NSColor whiteColor] set];
    [self.guidesPath setLineWidth:4.0f];
    [self.guidesPath stroke];
    [self.guideColor set];
    [self.guidesPath fill];

    [self.boxColor set];
    [self.boxPath fill];
}

- (BOOL)isOpaque;
{
    return NO;
}

#pragma mark NSResponder

- (void)keyDown:(NSEvent *)theEvent;
{
    switch ( [theEvent keyCode] ) {
        case 53:
            [self.delegate mouseViewShouldCancel:self];
            break;
        case 123:
            [self.delegate mouseView:self removeDirection:MNDirectionRight];
            break;
        case 126:
            [self.delegate mouseView:self removeDirection:MNDirectionDown];
            break;
        case 124:
            [self.delegate mouseView:self removeDirection:MNDirectionLeft];
            break;
        case 125:
            [self.delegate mouseView:self removeDirection:MNDirectionUp];
            break;
        case 36:
        case 49:
            [self.delegate mouseViewShouldFinish:self];
            break;
        default:
            [super keyDown:theEvent];
            break;
    }
}

- (BOOL)acceptsFirstResponder;
{
    return YES;
}

#pragma mark NSObject

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    [self setNeedsDisplay:YES];
}

- (void)dealloc;
{
    [self removeObserver:self forKeyPath:@"boxPath"];
    [self removeObserver:self forKeyPath:@"guidesPath"];
    [self removeObserver:self forKeyPath:@"boxColor"];
    [self removeObserver:self forKeyPath:@"guideColor"];
}

@end
