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
@synthesize serverList;

- (id)init {
	[super init];
	serverList = [[NSMutableArray alloc] init];
		
	return self;
}

- (void)dealloc {
	self.serverList = NULL;
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	Server* server1 = [[Server alloc] init];
	server1.delegate = self;
	
	[server1 ping];
	
	[serverList addObject:server1];
	[serverList addObject:server1];
}

- (void)serverPingFailed:(Server *)server {
	
}

@end
