//
//  ServerStatusAppDelegate.h
//  ServerStatus
//
//  Created by Florian Mutter on 11.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"

@interface ServerStatusAppDelegate : NSObject <NSApplicationDelegate, ServerDelegate> {
    NSWindow *window;
	IBOutlet NSMenu *statusMenu;
	IBOutlet NSView *statusItemMenuView;
	NSStatusItem *statusItem;
	
	NSImage *serversOk, *serversOkAlternate,
			*serversWarning, *serversWarningAlternate,
			*serversFail, *serversFailAlternate,
			*serversInactive, *serversInactiveAlternate;
	
	NSMutableArray *serverList;
		
}

@property (assign) IBOutlet NSWindow *window;

- (void)loadStatusItemImages;
- (void)addServersToMenu;

@end
