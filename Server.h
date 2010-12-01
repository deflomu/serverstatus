//
//  Server.h
//  ServerStatus
//
//  Created by Florian Mutter on 14.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"

#define MaxPingTimeoutCount 3
#define PingTimoutInSeconds 10

typedef enum {
	SERVER_UNKNOWN,
	SERVER_OK,
	SERVER_FAIL,
	SERVER_ERROR
} ServerStatus;

@interface Server : NSObject <SimplePingDelegate, NSCoding> {
	NSString *serverName;
	NSString *serverHost;
	NSError *serverError;
	NSData *lastKnownAddress;
	
	NSInteger pingTimeoutCount;
	
	ServerStatus serverStatus;
	ServerStatus previousStatus;
	
	BOOL active;
	BOOL pinging;
	
	SimplePing *_pinger;
	NSTimer *pingTimeout;
}

@property (retain) NSString *serverName;
@property (nonatomic, retain) NSString *serverHost;
@property (retain) NSError *serverError;
@property (retain) NSData *lastKnownAddress;
@property (assign) BOOL active;
@property (assign) BOOL pinging;
@property NSInteger pingTimeoutCount;
@property (nonatomic) ServerStatus serverStatus;
@property ServerStatus previousStatus;
@property (retain) SimplePing *pinger;
@property (retain) NSTimer *pingTimeout;

+ (Server *)server;

- (NSString *)lastKnownAddressAsString;
- (void)ping;

@end
