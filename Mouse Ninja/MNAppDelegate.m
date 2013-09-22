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
    NSDictionary *hotkey = @{ @"characters" : @"/", @"charactersIgnoringModifiers" : @"/", @"keyCode" : @(44), @"modifierFlags" : @(786432) };
    NSDictionary *defaults = @{ MNHasSeenWelcomeWindowDefaultsKey : @(NO), MNGlobalHotkeyInfoDefaultsKey : hotkey };

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
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag;
{
    if ( flag == NO )
    {
        [[MNPreferencesWindowController sharedPreferencesController] showWindow:self];
        return NO;
    }

    return YES;
}

@end
