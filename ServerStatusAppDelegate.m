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

- (id)init {
	[super init];
	NSStatusBar *bar = [NSStatusBar systemStatusBar];
	statusItem = [[bar statusItemWithLength:NSVariableStatusItemLength] retain];
	
	[self loadStatusItemImages];
	
	serverList = [[NSMutableArray alloc] init];
		
	return self;
}

- (void)dealloc {
	[serverList release];
	[super dealloc];
}

- (void)loadStatusItemImages {
	serversOk = [NSImage imageNamed:@"serverOk"];
	serversOkAlternate = [NSImage imageNamed:@"serverOkAlternate"];
	
	serversWarning = [NSImage imageNamed:@"serverWarning"];
	serversWarningAlternate = [NSImage imageNamed:@"serverWarningAlternate"];
	
	serversFail = [NSImage imageNamed:@"serverFail"];
	serversFailAlternate = [NSImage imageNamed:@"serverFailAlternate"];
	
	serversInactive = [NSImage imageNamed:@"serverInactive"];
	serversInactiveAlternate = serversOkAlternate;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
		
	[statusItem setMenu:statusMenu];
	[statusItem setImage:serversInactive];
	[statusItem setAlternateImage:serversInactiveAlternate];
	[statusItem setHighlightMode:YES];
	
	Server* server1 = [[Server alloc] init];
	server1.delegate = self;
	
	[server1 ping];
	
	[serverList addObject:server1];
	[serverList addObject:server1];

	
	[self addServersToMenu];
}

- (void)serverPingFailed:(Server *)server {
	[statusItem setImage:serversFail];
	[statusItem setAlternateImage:serversFailAlternate];
}

- (void)addServersToMenu {
	NSData* viewCopyData = [NSArchiver archivedDataWithRootObject:statusItemMenuView];
	id viewCopy;
	NSMenuItem* menuItem;
	
	for (int i = 0; i < [serverList count]; i++) {
		viewCopy = [NSUnarchiver unarchiveObjectWithData:viewCopyData];
		
		NSTextField *serverName;
		NSTextField *serverStatusText;
		serverName = [viewCopy viewWithTag:SERVER_NAME_TEXTFIELD];
		serverStatusText = [viewCopy viewWithTag:SERVER_STATUSTEXT_TEXTFIELD];
		
		[serverName setStringValue:[[serverList objectAtIndex:i] serverName]];
		
		
		menuItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
					initWithTitle:@"Server" action:NULL keyEquivalent:@""];
		[statusMenu insertItem:menuItem atIndex:0];
		[menuItem setView: viewCopy];
		[menuItem setTarget:self];
	}

}

@end
