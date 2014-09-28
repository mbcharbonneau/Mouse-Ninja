//
//  MNMouseWindowController.h
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/17/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MNMouseView.h"

@interface MNMouseWindowController : NSWindowController <MNMouseViewDelegate>

@property (readonly, nonatomic) MNMouseView *mouseView;

+ (instancetype)sharedMouseWindowController;

@end
