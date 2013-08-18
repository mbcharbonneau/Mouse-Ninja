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
    if ( self = [super initWithFrame:frame] )
    {
        _color = [NSColor colorWithCalibratedWhite:0.08f alpha:0.8f];
        _path = [[NSBezierPath alloc] init];

        [self addObserver:self forKeyPath:@"path" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"color" options:0 context:NULL];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect;
{
    NSAssert( self.color != nil, @"cannot draw with nil color" );

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

- (void)keyDown:(NSEvent *)theEvent;
{
    switch ( [theEvent keyCode] )
    {
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
    [self removeObserver:self forKeyPath:@"path"];
    [self removeObserver:self forKeyPath:@"color"];
}

@end
