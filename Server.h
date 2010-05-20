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

@interface Server : NSObject <SimplePingDelegate> {
	NSString *serverName;
	NSString *serverHost;
	SimplePing *_pinger;
	NSTimer *pingTimeout;
	
	ServerStatus serverStatus;
	
	id<ServerDelegate>  _delegate;
}

@property (readwrite, copy) NSString *serverName;
@property (readwrite, copy) NSString *serverHost;
@property (readwrite) ServerStatus serverStatus;
@property (nonatomic, retain, readwrite) SimplePing *   pinger;

@property (nonatomic, assign, readwrite) id<ServerDelegate> delegate;

- (void)ping;
- (void)pingTimedOut:(NSTimer *)timer;

@end

@protocol ServerDelegate <NSObject>

- (void)serverPingFailed:(Server*) server;

@end
