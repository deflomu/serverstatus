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
	
	statusOk = [NSImage imageNamed:@"serverok"];
	[statusOk setSize:NSMakeSize([bar thickness]+5, [bar thickness])];
	
	statusWait = [NSImage imageNamed:@"statusWait"];
	[statusWait setSize:NSMakeSize([bar thickness]-7.0, [bar thickness]-7.0)];
	
	statusFail = [NSImage imageNamed:@"statusFail"];
	[statusFail setSize:NSMakeSize([bar thickness]-7.0, [bar thickness]-7.0)];
	
	statusUnknown = [NSImage imageNamed:@"statusUnknown"];
	[statusUnknown setSize:NSMakeSize([bar thickness]-7.0, [bar thickness]-7.0)];
	
	[statusItem setMenu:statusMenu];
	[statusItem setImage:statusOk];
	[statusItem setHighlightMode:YES];
}

@end
