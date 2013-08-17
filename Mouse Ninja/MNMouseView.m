//
//  MNMouseView.m
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/17/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import "MNMouseView.h"

@implementation MNMouseView

- (id)initWithFrame:(NSRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        _color = [NSColor colorWithCalibratedWhite:0.1f alpha:0.7f];
        _path = [[NSBezierPath alloc] init];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSAssert( self.color != nil, @"cannot draw with nil color" );

    self.path = [NSBezierPath bezierPathWithRect:self.bounds];

    [self.color set];
    [self.path fill];

    
}

- (void)keyDown:(NSEvent *)theEvent
{
    NSLog( @"HERE" );
}

- (BOOL)acceptsFirstResponder;
{
    return YES;
}

- (BOOL)isOpaque;
{
    return NO;
}

@end
