//
//  MNPreferencesWindowController.m
//  Mouse Ninja
//
//  Created by Marc Charbonneau on 8/17/13.
//  Copyright (c) 2013 Downtown Software House. All rights reserved.
//

#import "MNPreferencesWindowController.h"

@interface MNPreferencesWindowController ()

@end

@implementation MNPreferencesWindowController

+ (instancetype)sharedPreferencesController;
{
    static MNPreferencesWindowController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] initWithWindowNibName:@"Preferences"];
    });

    return sharedController;
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
