//
//  MNPreferencesWindowController.h
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/17/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ShortcutRecorder.h>
#import <PTHotKey/PTHotKeyCenter.h>

@interface MNPreferencesWindowController : NSWindowController <SRRecorderControlDelegate>

+ (instancetype)sharedPreferencesController;

@end
