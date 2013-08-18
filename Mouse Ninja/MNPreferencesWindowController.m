//
//  MNPreferencesWindowController.m
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/17/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import "MNPreferencesWindowController.h"
#import "MNMouseWindowController.h"
#import "MNConstants.h"
#import "PTHotKey+ShortcutRecorder.h"

@interface MNPreferencesWindowController ()

@end

@implementation MNPreferencesWindowController

#pragma mark MNPreferencesWindowController

+ (instancetype)sharedPreferencesController;
{
    static MNPreferencesWindowController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] initWithWindowNibName:@"Preferences"];
    });

    return sharedController;
}

#pragma mark SRRecorderControlDelegate

- (BOOL)shortcutRecorderShouldBeginRecording:(SRRecorderControl *)aRecorder;
{
    [[PTHotKeyCenter sharedCenter] pause];
    return YES;
}

- (void)shortcutRecorderDidEndRecording:(SRRecorderControl *)aRecorder;
{
    PTHotKeyCenter *center = [PTHotKeyCenter sharedCenter];
    PTHotKey *oldHotKey = [center hotKeyWithIdentifier:MNGlobalHotkeyIdentifier];
    [center unregisterHotKey:oldHotKey];

    NSDictionary *keyInfo = [aRecorder objectValue];

    if ( keyInfo != nil )
    {
        MNMouseWindowController *target = [MNMouseWindowController sharedMouseWindowController];
        PTHotKey *newHotKey = [PTHotKey hotKeyWithIdentifier:MNGlobalHotkeyIdentifier keyCombo:keyInfo target:target action:@selector(showWindow:)];
        [center registerHotKey:newHotKey];
    }

    [center resume];
}

@end
