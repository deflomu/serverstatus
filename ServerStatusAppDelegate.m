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
@synthesize pinger;

- (id)init {
	[super init];
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

	return self;
}

- (void)dealloc {
    [self->pinger stop];
    [self->pinger release];
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
		
	[statusItem setMenu:statusMenu];
	[statusItem setImage:serversInactive];
	[statusItem setAlternateImage:serversInactiveAlternate];
	[statusItem setHighlightMode:YES];
	
	[self runWithHostName:@"skweez.net"];
}

- (void)runWithHostName:(NSString *)hostName {
	self.pinger = [SimplePing simplePingWithHostName:hostName];
	self.pinger.delegate = self;
	[self.pinger start];
}

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
	[self.pinger sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet {
	[statusItem setImage:serversOk];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error {
	[statusItem setImage:serversFail];
}


@end
