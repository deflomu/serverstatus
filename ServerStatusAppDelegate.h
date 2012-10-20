//
//  ServerStatusAppDelegate.h
//  ServerStatus
//
//  Created by Florian Mutter on 11.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Sparkle/Sparkle.h"

@class ServerListController;
@class StatusItemController;

@interface ServerStatusAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindowController *_preferencesWindowController;
	ServerListController *serverListController;
	StatusItemController *statusItemController;
	SUUpdater *suupdater;
}

@property (assign) IBOutlet ServerListController *serverListController;
@property (assign) IBOutlet StatusItemController *statusItemController;
@property (readonly) NSWindowController *preferencesWindowController;
@property (assign) IBOutlet SUUpdater *suupdater;

- (IBAction)openPreferences:(id)sender;

@end
