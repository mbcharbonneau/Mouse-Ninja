//
//  MNPreferencesWindowController.h
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/17/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MNPreferencesWindowController : NSWindowController

+ (instancetype)sharedPreferencesController;

- (IBAction)showMouseWindow:(id)sender;

@end
