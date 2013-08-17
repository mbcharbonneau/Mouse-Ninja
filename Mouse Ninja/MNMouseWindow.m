//
//  MNMouseWindow.m
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/17/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import "MNMouseWindow.h"

@implementation MNMouseWindow

- (BOOL)canBecomeKeyWindow;
{
    return YES;
}

- (BOOL)canBecomeMainWindow;
{
    return YES;
}

@end
