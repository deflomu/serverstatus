//
//  ServerTabViewController.m
//  ServerStatus
//
//  Created by Florian Mutter on 24.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "ServerTabViewController.h"


@implementation ServerTabViewController
@synthesize serverName, serverHost, lastKnownAddress, server;

- (void)setServer:(Server *)s {
	[server removeObserver:self forKeyPath:@"lastKnownAddress"];
	
	if (s) {
		[s addObserver:self
			forKeyPath:@"lastKnownAddress"
			   options:0
			   context:nil];
	}
	
	server = s;
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
	if ([keyPath isEqualToString:@"server"]) {
		[self updateView];
	}
	if (keyPath == @"lastKnownAddress") {
		[self updateView];
	}
}

- (void)updateView {
	if (server) {
		[self.serverName setStringValue:self.server.serverName];
		[self.serverHost setStringValue:self.server.serverHost];
		[self.serverHost setEditable:YES];
		[self.lastKnownAddress setStringValue:[self.server lastKnownAddressAsString]];
	} else {
		[self.serverName setStringValue:@"Server"];
		[self.serverHost setStringValue:@""];
		[self.serverHost setEditable:NO];
		[self.lastKnownAddress setStringValue:@""];
	}
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
	self.server.serverHost = [self.serverHost stringValue];
}

@end
