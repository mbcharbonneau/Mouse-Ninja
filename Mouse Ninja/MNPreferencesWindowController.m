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

@property (nonatomic, strong) IBOutlet SRRecorderControl *shortcutRecorder;

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

#pragma mark NSWindowController

- (void)windowDidLoad;
{
    [super windowDidLoad];

    NSDictionary *keyInfo = [[NSUserDefaults standardUserDefaults] objectForKey:MNGlobalHotkeyInfoDefaultsKey];
    [self.shortcutRecorder setObjectValue:keyInfo];
}

#pragma mark SRRecorderControlDelegate

- (BOOL)shortcutRecorderShouldBeginRecording:(SRRecorderControl *)aRecorder;
{
    [[PTHotKeyCenter sharedCenter] pause];
    return YES;
}

- (void)shortcutRecorderDidEndRecording:(SRRecorderControl *)aRecorder;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    PTHotKeyCenter *hotkeyCenter = [PTHotKeyCenter sharedCenter];
    PTHotKey *oldHotKey = [hotkeyCenter hotKeyWithIdentifier:MNGlobalHotkeyIdentifier];
    
    [hotkeyCenter unregisterHotKey:oldHotKey];
    [userDefaults setObject:nil forKey:MNGlobalHotkeyInfoDefaultsKey];

    NSDictionary *keyInfo = [aRecorder objectValue];

    if ( keyInfo != nil )
    {
        MNMouseWindowController *target = [MNMouseWindowController sharedMouseWindowController];
        PTHotKey *newHotKey = [PTHotKey hotKeyWithIdentifier:MNGlobalHotkeyIdentifier keyCombo:keyInfo target:target action:@selector(showWindow:)];

        [hotkeyCenter registerHotKey:newHotKey];
        [userDefaults setObject:keyInfo forKey:MNGlobalHotkeyInfoDefaultsKey];
    }

    [hotkeyCenter resume];
}

@end
