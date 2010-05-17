//
//  ServerList.m
//  ServerStatus
//
//  Created by Florian Mutter on 16.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "ServerList.h"


@implementation ServerList

- (id)init {
	[super init];
	serverList = [[NSMutableArray alloc] init];
	return self;
}

- (void)dealloc {
	[self setServerList:nil];
	[super dealloc];
}

- (void)setServerList:(NSMutableArray *)a {
	
}

@end
