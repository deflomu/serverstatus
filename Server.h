//
//  Server.h
//  ServerStatus
//
//  Created by Florian Mutter on 14.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "SimplePing.h"

typedef enum {
	SERVER_UNKNOWN,
	SERVER_OK,
	SERVER_FAIL
} ServerStatus;

@protocol ServerDelegate;

@interface Server : NSObject <SimplePingDelegate, NSCoding> {
	NSString *serverName;
	NSString *serverHost;
	BOOL active;
	SimplePing *_pinger;
	NSTimer *pingTimeout;
	
	ServerStatus serverStatus;
	
	id<ServerDelegate>  _delegate;
}

@property (retain) NSString *serverName;
@property (retain) NSString *serverHost;
@property BOOL active;
@property ServerStatus serverStatus;
@property (retain) SimplePing *pinger;

@property (assign) id<ServerDelegate> delegate;

+ (Server *)server;

- (void)ping;
- (void)pingTimedOut:(NSTimer *)timer;

@end
