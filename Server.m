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
	serverName = @"Skweez";
	serverHost = @"skweez.net";
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
