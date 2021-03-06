//
//  Server.m
//  ServerStatus
//
//  Created by Florian Mutter on 14.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "Server.h"

#include <sys/socket.h>
#include <netdb.h>

@implementation Server
@synthesize serverName, serverHost, serverError, lastKnownAddress, serverStatus, previousStatus, active, pinging, pingTimeout, pingTimeoutCount;
@synthesize pinger		= _pinger;

+ (Server *)server {
	return [[[Server alloc] init] autorelease];
}

#pragma mark -
#pragma mark Private
- (void)startPinging {
	if (!self.pinging) {
		DLog(@"%@: Start pinging", self.serverName);
		self.pinging = YES;
		[self.pinger start];
		
		/* shedule timer to detect ping timeout */
		self.pingTimeout = [NSTimer scheduledTimerWithTimeInterval:PingTimoutInSeconds
															target:self
														  selector:@selector(pingTimedOut:)
														  userInfo:nil
														   repeats:NO];
	}
}

- (void)stopPinging {
	if (self.pinging) {
		DLog(@"%@: Stop pinging", self.serverName);
		if (self.pingTimeout) {
			[self.pingTimeout invalidate];
		}
	
		self.pinging = NO;
		[self.pinger stop];
	}
}

- (void)setServerStatus:(ServerStatus)status {
	self.previousStatus = serverStatus;
	serverStatus = status;
}

- (void)setServerHost:(NSString *)aServerHost {
	if (serverHost == aServerHost) {
		return;
	}
	if (self.pinger) {
		[self stopPinging];
		self.pinger = nil;
	}
	
	[serverHost autorelease];
	serverHost = [aServerHost retain];
	
	if (serverHost) {
		self.pinger = [SimplePing simplePingWithHostName:serverHost];
		self.pinger.delegate = self;
	}
}

- (void)setServerName:(NSString *)aServerName {
	if ([self.serverHost isEqualToString:@""]) {
		self.serverHost = aServerName;
	}
	
	[serverName autorelease];
	serverName = [aServerName retain];
}

- (NSString *)DisplayAddressForAddress:(NSData *) address
    // Returns a dotted decimal string for the specified address (a (struct sockaddr) 
    // within the address NSData).
{
    int         err;
    NSString *  result;
    char        hostStr[NI_MAXHOST];
    
    result = nil;
    
    if (address != nil) {
        err = getnameinfo([address bytes], (socklen_t) [address length], hostStr, sizeof(hostStr), NULL, 0, NI_NUMERICHOST);
        if (err == 0) {
            result = [NSString stringWithCString:hostStr encoding:NSASCIIStringEncoding];
            assert(result != nil);
        }
    }
	
    return result;
}

#pragma mark -
#pragma mark Public

- (NSString *)lastKnownAddressAsString {
	NSString * result = [self DisplayAddressForAddress:lastKnownAddress];
	return result ? result : @"Unknown";
}

#pragma mark -
#pragma mark ping
- (void)pingTimedOut:(NSTimer *)timer {
	[self stopPinging];
	self.pingTimeoutCount ++;
	DLog(@"%@: Ping timed out (%ld/%d)", self.serverName, (long)self.pingTimeoutCount, MaxPingTimeoutCount);
	if (self.pingTimeoutCount >= MaxPingTimeoutCount) {
		self.serverError = [NSError errorWithDomain:PingTimeoutError
											   code:PingTimeoutErrorCode
										   userInfo:[NSDictionary
													 dictionaryWithObject:@"Ping timed out"
													 forKey:NSLocalizedDescriptionKey]];
		self.serverStatus = SERVER_FAIL;
		self.pingTimeoutCount = 0;
	} else {
		[self startPinging];
	}

}

- (void)ping {
	[self startPinging];
}

#pragma mark -
#pragma mark Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"active"]) {
		if (!self.active) {
			[self stopPinging];
			self.serverStatus = SERVER_UNKNOWN;
		}
	}
	if ([keyPath isEqualToString:@"serverHost"]) {
		if (self.active) {
			[self stopPinging];
			self.serverStatus = SERVER_UNKNOWN;
			[self startPinging];
		}
	}
}

#pragma mark -
#pragma mark Network Status
- (void)networkConnectionChanged:(NSNotification *)notification {
	BOOL hasConnection = [[[notification userInfo] objectForKey:@"networkAvailable"] boolValue];
	
	if (!hasConnection) {
		[self stopPinging];
		self.serverStatus = SERVER_UNKNOWN;
	}
}

#pragma mark -
#pragma mark SimplePingDelegate

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
	self.lastKnownAddress = address;
	[self.pinger sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet
			 error:(NSError *)e {
	self.serverError = e;
	[self stopPinging];
	self.serverStatus = SERVER_ERROR;
	DLog(@"%@: Failed to send Packet: %@", self.serverName, [e localizedDescription]);
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet {
	[self stopPinging];
	self.serverStatus = SERVER_OK;
	self.pingTimeoutCount = 0;
	DLog(@"%@: Received ping response packet.", self.serverName);
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)e {
	self.serverError = e;
	[self stopPinging];
	self.serverStatus = SERVER_ERROR;
	DLog(@"%@: Failed with Error: %@", self.serverName, [e localizedDescription]);
}

#pragma mark -
#pragma mark Init
- (void)initializeValues {
	[self addObserver:self forKeyPath:@"active" options:0 context:NULL];
	[self addObserver:self forKeyPath:@"serverHost" options:0 context:NULL];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(networkConnectionChanged:)
			   name:NetworkChangeNotification
			 object:nil];
	
	self.serverStatus = SERVER_UNKNOWN;
	self.previousStatus = SERVER_UNKNOWN;
	self.pinging = NO;
	self.pingTimeoutCount = 0;
	
}

- (id)init
{
	self = [super init];
	if (self != nil) {
		self.serverName = @"New Server";
		self.serverHost = @"";
		self.lastKnownAddress = nil; 
		self.active = NO;
		self.serverError = nil;
		[self initializeValues];
	}
	return self;
}

- (void)dealloc {
	self.serverStatus = SERVER_UNKNOWN;
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[self removeObserver:self forKeyPath:@"active"];
	[self removeObserver:self forKeyPath:@"serverHost"];
	[self stopPinging];
    self.pinger = nil;
	self.pingTimeout = nil;
	self.lastKnownAddress = nil;
	self.serverName = nil;
	self.serverHost = nil;
	self.serverError = nil;
	[super dealloc];
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self != nil) {
		self.serverName = [aDecoder decodeObjectForKey:@"serverName"];
		self.serverHost = [aDecoder decodeObjectForKey:@"serverHost"];
		self.lastKnownAddress = [aDecoder decodeObjectForKey:@"lastKnownAddress"];
		self.active = [aDecoder decodeBoolForKey:@"active"];
		[self initializeValues];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.serverName forKey:@"serverName"];
	[aCoder encodeObject:self.serverHost forKey:@"serverHost"];
	[aCoder encodeObject:self.lastKnownAddress forKey:@"lastKnownAddress"];
	[aCoder encodeBool:self.active forKey:@"active"];
}


@end
