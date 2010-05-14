//
//  ServerStatusAppDelegate.m
//  ServerStatus
//
//  Created by Florian Mutter on 11.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "ServerStatusAppDelegate.h"

@implementation ServerStatusAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSStatusBar *bar = [NSStatusBar systemStatusBar];
	statusItem = [[bar statusItemWithLength:NSVariableStatusItemLength] retain];
	
	serversOk = [NSImage imageNamed:@"serverOk"];
	serversOkAlternate = [NSImage imageNamed:@"serverOkAlternate"];
	
	serversWarning = [NSImage imageNamed:@"serverWarning"];
	serversWarningAlternate = [NSImage imageNamed:@"serverWarningAlternate"];
	
	serversFail = [NSImage imageNamed:@"serverFail"];
	serversFailAlternate = [NSImage imageNamed:@"serverFailAlternate"];
	
	serversInactive = [NSImage imageNamed:@"serverInactive"];
	serversInactiveAlternate = serversOkAlternate;
		
	[statusItem setMenu:statusMenu];
	[statusItem setImage:serversInactive];
	[statusItem setAlternateImage:serversInactiveAlternate];
	[statusItem setHighlightMode:YES];
}

- (void)setImage:(NSImage *)status {
	[statusItem setImage:status];
}

@end
