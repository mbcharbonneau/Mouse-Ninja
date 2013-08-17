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

@interface MNAppDelegate()

@property (nonatomic, strong) NSWindowController *welcomeWindowController;

@end

@implementation MNAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if ( ![[NSUserDefaults standardUserDefaults] boolForKey:MNHasSeenWelcomeWindowDefaultsKey] )
    {
        self.welcomeWindowController = [[MNWelcomeWindowController alloc] initWithWindowNibName:@"WelcomeWindow"];
        [self.welcomeWindowController showWindow:self];
        [self.welcomeWindowController.window makeKeyAndOrderFront:self];
    }
}

+ (void)initialize;
{
    NSDictionary *defaults = @{ MNHasSeenWelcomeWindowDefaultsKey : @(NO) };

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

@end