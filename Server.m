//
//  Server.m
//  ServerStatus
//
//  Created by Florian Mutter on 14.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "Server.h"


@implementation Server

- (id)init {
	self = [super init];
	serverName = @"Skweezasd";
	serverHost = @"10.0.0.42";
	serverStatus = SERVER_UNKNOWN;
	self.pinger = [SimplePing simplePingWithHostName:serverHost];
	return self;
}

- (void)dealloc {
	[self->_pinger stop];
    [self->_pinger release];
	[serverName release];
	[serverHost release];
	[super dealloc];
}

@synthesize serverName;
@synthesize serverHost;
@synthesize serverStatus;
@synthesize pinger		= _pinger;
@synthesize delegate	= _delegate;


- (void)ping {
	self.pinger.delegate = self;
	[self.pinger start];
	
	pingTimeout = [NSTimer scheduledTimerWithTimeInterval:10
												   target:self
												 selector:@selector(pingTimedOut:)
												 userInfo:nil
												  repeats:NO];
}

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
	[self.pinger sendPingWithData:nil];
	NSLog(@"Ping sent");
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet
			 error:(NSError *)error {
	
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet {
	[pingTimeout invalidate];
	[self.pinger stop];
	serverStatus = SERVER_OK;
	NSLog(@"Ping received");
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error {
}

- (void)pingTimedOut:(NSTimer *)timer {
	[self.pinger stop];
	serverStatus = SERVER_FAIL;
	NSLog(@"Ping timed out");
	if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(serverPingFailed:)] ) {
		[self.delegate serverPingFailed:self];
	}
}

@end
