//
//  MNWelcomeWindowController.m
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/17/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import "MNWelcomeWindowController.h"
#import "MNConstants.h"
#import "MNPreferencesWindowController.h"

@interface MNWelcomeWindowController ()

@end

@implementation MNWelcomeWindowController

#pragma mark MNWelcomeWindowController

- (IBAction)openPreferences:(id)sender;
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MNHasSeenWelcomeWindowDefaultsKey];
    [[MNPreferencesWindowController sharedPreferencesController] showWindow:sender];
    [[self window] performClose:sender];
}

- (IBAction)learnMore:(id)sender;
{
#warning stub

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MNHasSeenWelcomeWindowDefaultsKey];

}

#pragma mark NSWindowDelegate

- (BOOL)windowShouldClose:(id)sender;
{
    // Don't use -windowWillClose, we only want to observe when the user
    // explicitly closes the window (not if they quit).

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MNHasSeenWelcomeWindowDefaultsKey];
    
    return YES;
}

@end
