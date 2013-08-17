//
//  MNWelcomeWindowController.m
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/17/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import "MNWelcomeWindowController.h"
#import "MNConstants.h"

@interface MNWelcomeWindowController ()

@end

@implementation MNWelcomeWindowController

#pragma mark MNWelcomeWindowController

- (IBAction)openPreferences:(id)sender;
{
#warning stub

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MNHasSeenWelcomeWindowDefaultsKey];

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


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
