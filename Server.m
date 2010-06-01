//
//  Server.m
//  ServerStatus
//
//  Created by Florian Mutter on 14.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "Server.h"


@implementation Server
@synthesize serverName, serverHost, serverStatus, active, pingTimeout;
@synthesize pinger		= _pinger;
@synthesize delegate	= _delegate;

+ (Server *)server {
	return [[[Server alloc] init] autorelease];
}

#pragma mark -
#pragma mark ping
- (void)pingTimedOut:(NSTimer *)timer {
	[self.pinger stop];
	self.serverStatus = SERVER_FAIL;
	NSLog(@"%@: Ping timed out", self.serverName);
}

- (void)ping {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
	[self.pinger start];
	
	self.pingTimeout = [NSTimer scheduledTimerWithTimeInterval:10
												   target:self
												 selector:@selector(pingTimedOut:)
												 userInfo:nil
												  repeats:NO];
	
    [[NSRunLoop currentRunLoop] addTimer:self.pingTimeout forMode:NSDefaultRunLoopMode];  
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:11]];  
	
	[pool release];
}

#pragma mark -
#pragma mark Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"active"]) {
		if (!self.active) {
			[self.pinger stop];
			[self.pingTimeout invalidate];
			self.serverStatus = SERVER_UNKNOWN;
		}
	}
}

#pragma mark -
#pragma mark Network Status
- (void)networkConnectionChanged:(NSNotification *)notification {
	BOOL hasConnection = [[[notification userInfo] objectForKey:@"networkAvailable"] boolValue];
	
	if (!hasConnection) {
		[self.pinger stop];
		[self.pingTimeout invalidate];
	}
}

#pragma mark -
#pragma mark SimplePingDelegate

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
	[self.pinger sendPingWithData:nil];
	self.serverStatus = SERVER_PINGING;
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet
			 error:(NSError *)error {
	[self.pingTimeout invalidate];
	self.serverStatus = SERVER_ERROR;
	NSLog(@"%@: Failed to send Packet", self.serverName);
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet {
	[self.pingTimeout invalidate];
	[self.pinger stop];
	self.serverStatus = SERVER_OK;
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error {
	[self.pingTimeout invalidate];
	self.serverStatus = SERVER_ERROR;
	NSLog(@"%@: Did fail with Error: %@", self.serverName, [error localizedDescription]);
}

#pragma mark -
#pragma mark Init
- (void)initializeValues {
	[self addObserver:self forKeyPath:@"active" options:0 context:NULL];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(networkConnectionChanged:)
			   name:NetworkChangeNotification
			 object:nil];
	self.serverStatus = SERVER_UNKNOWN;
	self.pinger = [SimplePing simplePingWithHostName:serverHost];
	self.pinger.delegate = self;
}

- (id)init
{
	self = [super init];
	if (self != nil) {
		self.serverName = @"localhost";
		self.serverHost = @"127.0.0.1";
		self.active = NO;
		[self initializeValues];
	}
	return self;
}

- (void)dealloc {
	self.pingTimeout = NULL;
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[self.pinger stop];
    [self.pinger release];
	self.serverName = NULL;
	self.serverHost = NULL;
	[super dealloc];
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self != nil) {
		self.serverName = [aDecoder decodeObjectForKey:@"serverName"];
		self.serverHost = [aDecoder decodeObjectForKey:@"serverHost"];
		self.active = [aDecoder decodeBoolForKey:@"active"];
		[self initializeValues];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.serverName forKey:@"serverName"];
	[aCoder encodeObject:self.serverHost forKey:@"serverHost"];
	[aCoder encodeBool:self.active forKey:@"active"];
}


@end
