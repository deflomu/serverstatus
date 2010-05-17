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
	[super init];
	serverName = @"localhost";
	serverHost = @"127.0.0.1";
	return self;
}

- (void)dealloc {
	[serverName release];
	[serverHost release];
	[super dealloc];
}

@synthesize serverName;
@synthesize serverHost;
@end
