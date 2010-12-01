//
//  ServerTabViewController.m
//  ServerStatus
//
//  Created by Florian Mutter on 24.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "ServerTabViewController.h"
#import "Server.h"


@implementation ServerTabViewController
@synthesize serverName, serverHost, lastKnownAddress, serverStatus, pingingIndicator, server;

- (void)setServer:(Server *)aServer {
	[server removeObserver:self forKeyPath:@"lastKnownAddress"];
	[server removeObserver:self forKeyPath:@"serverStatus"];
	[server removeObserver:self forKeyPath:@"pinging"];

	
	if (aServer) {
		[aServer addObserver:self
				  forKeyPath:@"lastKnownAddress"
					 options:0
					 context:NULL];
		[aServer addObserver:self
				  forKeyPath:@"serverStatus"
					 options:0
					 context:NULL];
		[aServer addObserver:self
				  forKeyPath:@"pinging"
					 options:0
					 context:NULL];
	}
	
	[server autorelease];
	server = [aServer retain];
}

- (void)serverIsPinging:(Server *)aServer {
	if ([aServer pinging]) {
		[serverStatus setHidden:YES];
		[pingingIndicator startAnimation:self];
	} else {
		[pingingIndicator stopAnimation:self];
		[serverStatus setHidden:NO];
	}

}

- (void)awakeFromNib {
	[self addObserver:self
		   forKeyPath:@"server"
			  options:0
			  context:NULL];
}

- (void) dealloc
{
	[self removeObserver:self forKeyPath:@"server"];
	self.server = nil;
	[super dealloc];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context {
	if (keyPath == @"server") {
		[self updateView];
	}
	if (keyPath == @"lastKnownAddress") {
		[self updateView];
	}
	if (keyPath == @"pinging") {
		[self serverIsPinging:object];
	}
}

- (void)updateView {
	if (server) {
		[self.serverName setStringValue:self.server.serverName];
		[self.serverHost setStringValue:self.server.serverHost];
		[self.serverHost setEnabled:YES];
		[self.lastKnownAddress setStringValue:[self.server lastKnownAddressAsString]];
	} else {
		[self.serverName setStringValue:@"Server"];
		[self.serverHost setStringValue:@""];
		[self.serverHost setEnabled:NO];
		[self.lastKnownAddress setStringValue:@""];
	}
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
	self.server.serverHost = [self.serverHost stringValue];
}

@end
