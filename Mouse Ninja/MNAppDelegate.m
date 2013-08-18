//
//  MNAppDelegate.m
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/12/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import "MNAppDelegate.h"
#import "MNWelcomeWindowController.h"
#import "MNConstants.h"
#import "MNPreferencesWindowController.h"
#import "MNMouseWindowController.h"
#import "PTHotKey+ShortcutRecorder.h"

@interface MNAppDelegate()

@property (nonatomic, strong) NSWindowController *welcomeWindowController;

@end

@implementation MNAppDelegate

#pragma mark NSObject

+ (void)initialize;
{
    NSDictionary *defaults = @{ MNHasSeenWelcomeWindowDefaultsKey : @(NO) };

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *hotkeyInfo = [userDefaults objectForKey:MNGlobalHotkeyInfoDefaultsKey];

    if ( ![userDefaults boolForKey:MNHasSeenWelcomeWindowDefaultsKey] )
    {
        self.welcomeWindowController = [[MNWelcomeWindowController alloc] initWithWindowNibName:@"WelcomeWindow"];
        [self.welcomeWindowController showWindow:self];
    }

    if ( hotkeyInfo != nil )
    {
        PTHotKeyCenter *hotkeyCenter = [PTHotKeyCenter sharedCenter];
        MNMouseWindowController *target = [MNMouseWindowController sharedMouseWindowController];
        PTHotKey *newHotKey = [PTHotKey hotKeyWithIdentifier:MNGlobalHotkeyIdentifier keyCombo:hotkeyInfo target:target action:@selector(showWindow:)];

        [hotkeyCenter registerHotKey:newHotKey];
    }

    [[MNPreferencesWindowController sharedPreferencesController] showWindow:self];
    
}

@end
