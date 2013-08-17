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

    //self.path = [NSBezierPath bezierPathWithRect:self.bounds];

    CGFloat strokeWidth = 4.0f;
    NSBezierPath *stroke = [NSBezierPath bezierPathWithRect:NSInsetRect( self.bounds, strokeWidth / 2.0f, strokeWidth / 2.0f )];

    [[NSColor redColor] set];
    [stroke setLineWidth:strokeWidth];
    [stroke stroke];

    [self.color set];
    [self.path fill];
}

- (BOOL)isOpaque;
{
    return NO;
}

#pragma mark NSResponder

- (void)keyDown:(NSEvent *)theEvent
{
    switch ( [theEvent keyCode] )
    {
        case 53:
            [self.delegate mouseViewShouldCancel:self];
            break;
        case 123:
            [self.delegate mouseView:self sliceDirection:MNDirectionLeft];
            break;
        case 126:
            [self.delegate mouseView:self sliceDirection:MNDirectionUp];
            break;
        case 124:
            [self.delegate mouseView:self sliceDirection:MNDirectionRight];
            break;
        case 125:
            [self.delegate mouseView:self sliceDirection:MNDirectionDown];
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

@end
