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

#pragma mark Private
- (NSString *)getStatusString:(ServerStatus) aServerStatus {
	NSString *status;
	switch (aServerStatus) {
		case SERVER_OK:
			status = NSLocalizedString(@"Server is reachable",@"Server is reachable");
			break;
		case SERVER_FAIL:
			status = NSLocalizedString(@"Server is unreachable",@"Server is unreachable");
			break;
		case SERVER_UNKNOWN:
			status = NSLocalizedString(@"Server status is unknown",@"Server status is unknown");
			break;
		case SERVER_ERROR:
			status = NSLocalizedString(@"An error occurred",@"An error occurred");
			break;
		default:
			status = NSLocalizedString(@"No server status is set",@"No server status is set");
			break;
	}
	return status;
}

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

- (void)serverIsPinging:(BOOL)pinging {
	if (pinging) {
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
	[self updateView];
}

- (void)updateView {
	if (server) {
		[self.serverName setStringValue:self.server.serverName];
		[self.serverHost setStringValue:self.server.serverHost];
		[self.serverHost setEnabled:YES];
		[self serverIsPinging:[server pinging]];
		[self.serverStatus setStringValue:[self getStatusString:[self.server serverStatus]]];
		[self.lastKnownAddress setStringValue:[self.server lastKnownAddressAsString]];
	} else {
		[self.serverName setStringValue:@"Server"];
		[self.serverHost setStringValue:@""];
		[self.serverHost setEnabled:NO];
		[self serverIsPinging:FALSE];
		[self.serverStatus setStringValue:@""];
		[self.lastKnownAddress setStringValue:@""];
	}
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
	self.server.serverHost = [self.serverHost stringValue];
}

@end
