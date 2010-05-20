//
//  Server.m
//  ServerStatus
//
//  Created by Florian Mutter on 14.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "Server.h"


@implementation Server
@synthesize serverName, serverHost, serverStatus;
@synthesize pinger		= _pinger;
@synthesize delegate	= _delegate;


#pragma mark -
#pragma mark Initialisation
- (id)init
{
	self = [super init];
	if (self != nil) {
		serverName = @"localhost";
		serverHost = @"127.0.0.1";
		serverStatus = SERVER_UNKNOWN;
		self.pinger = [SimplePing simplePingWithHostName:serverHost];
	}
	return self;
}

- (id)initWithName:(NSString *)name host:(NSString *)host {
	self = [super init];
	if (self != nil) {
		self.serverName = name;
		self.serverHost = host;
		serverStatus = SERVER_UNKNOWN;
		self.pinger = [SimplePing simplePingWithHostName:serverHost];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self != nil) {
		serverName = [aDecoder decodeObjectForKey:@"serverName"];
		serverHost = [aDecoder decodeObjectForKey:@"serverHost"];
		serverStatus = SERVER_UNKNOWN;
		self.pinger = [SimplePing simplePingWithHostName:serverHost];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.serverName forKey:@"serverName"];
	[aCoder encodeObject:self.serverHost forKey:@"serverHost"];
}

- (void)dealloc {
	[self->_pinger stop];
    [self->_pinger release];
	self.serverName = NULL;
	self.serverHost = NULL;
	[super dealloc];
}


#pragma mark -
#pragma mark ping

- (void)ping {
	self.pinger.delegate = self;
	[self.pinger start];
	
	pingTimeout = [NSTimer scheduledTimerWithTimeInterval:10
												   target:self
												 selector:@selector(pingTimedOut:)
												 userInfo:nil
												  repeats:NO];
}

- (void)pingTimedOut:(NSTimer *)timer {
	[self.pinger stop];
	serverStatus = SERVER_FAIL;
	NSLog(@"Ping timed out");
	if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(serverPingFailed:)] ) {
		[self.delegate serverPingFailed:self];
	}
}

#pragma mark -
#pragma mark SimplePingDelegate

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

@end
