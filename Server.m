//
//  Server.m
//  ServerStatus
//
//  Created by Florian Mutter on 14.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "Server.h"


@implementation Server
@synthesize serverName, serverHost, serverStatus, active;
@synthesize pinger		= _pinger;
@synthesize delegate	= _delegate;


#pragma mark Public
+ (Server *)server {
	return [[[Server alloc] init] autorelease];
}

#pragma mark -
#pragma mark Init
- (id)init
{
	self = [super init];
	if (self != nil) {
		self.serverName = @"localhost";
		self.serverHost = @"127.0.0.1";
		self.active = NO;
		self.serverStatus = SERVER_UNKNOWN;
		self.pinger = [SimplePing simplePingWithHostName:serverHost];
	}
	return self;
}

- (void)dealloc {
		//Set active to no, to inform all observers (StatusItemController)
	self.active = NO;
	[self.pinger stop];
    [self.pinger release];
	self.serverName = NULL;
	self.serverHost = NULL;
	[super dealloc];
}


#pragma mark -
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self != nil) {
		self.serverName = [aDecoder decodeObjectForKey:@"serverName"];
		self.serverHost = [aDecoder decodeObjectForKey:@"serverHost"];
		self.active = [aDecoder decodeBoolForKey:@"active"];
		self.serverStatus = SERVER_UNKNOWN;
		self.pinger = [SimplePing simplePingWithHostName:serverHost];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.serverName forKey:@"serverName"];
	[aCoder encodeObject:self.serverHost forKey:@"serverHost"];
	[aCoder encodeBool:self.active forKey:@"active"];
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
	self.serverStatus = SERVER_FAIL;
	NSLog(@"Ping timed out");
}

#pragma mark -
#pragma mark SimplePingDelegate

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
	[self.pinger sendPingWithData:nil];
	NSLog(@"Ping sent");
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet
			 error:(NSError *)error {
	self.serverStatus = SERVER_UNKNOWN;
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet {
	[pingTimeout invalidate];
	[self.pinger stop];
	self.serverStatus = SERVER_OK;
	NSLog(@"Ping received");
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error {
}

@end
