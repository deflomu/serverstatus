//
//  ServerStatusAppDelegate.h
//  ServerStatus
//
//  Created by Florian Mutter on 11.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"
#import "PreferenceWindowController.h";
#import "ServerListController.h"

@interface ServerStatusAppDelegate : NSObject <NSApplicationDelegate> {
	PreferenceWindowController *preferenceWindowController;
	ServerListController *serverListController;
}

@property (assign) IBOutlet ServerListController *serverListController;

- (IBAction)showPreferenceWindow:(id)sender;

@end
