//
//  MNMouseView.h
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/17/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM( NSUInteger, MNDirection )
{
    MNDirectionLeft,
    MNDirectionRight,
    MNDirectionUp,
    MNDirectionDown
};

@protocol MNMouseViewDelegate;

@interface MNMouseView : NSView

@property (nonatomic, strong) NSColor *color;
@property (nonatomic, strong) NSBezierPath *path;
@property (nonatomic, weak) id<MNMouseViewDelegate> delegate;

@end

@protocol MNMouseViewDelegate <NSObject>

@required
- (void)mouseView:(MNMouseView *)view removeDirection:(MNDirection)direction;
- (void)mouseViewShouldCancel:(MNMouseView *)view;

@end