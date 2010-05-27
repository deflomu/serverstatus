//
//  ServerListController.m
//  ServerStatus
//
//  Created by Florian Mutter on 27.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "ServerListController.h"


@implementation ServerListController
@synthesize serverList, statusItemController;

- (void)awakeFromNib {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"serverList"]];
	self.serverList = [NSMutableArray arrayWithArray:array];
	
	for (Server *server in self.serverList) {
		if (server.active) {
			[self.statusItemController addServer:server
										 atIndex:[self.serverList indexOfObject:server]];
		}
	}
	
	[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkServers:) userInfo:NULL repeats:YES];
}

- (void)addServer:(Server *)server {
    [self.serverList addObject:server];
}

- (void)removeServers:(NSIndexSet *)serverIndexes {
	for (Server *server in [self.serverList objectsAtIndexes:serverIndexes]) {
		if (server.active) {
				[self.statusItemController removeServer:server];
		}
	}
    [self.serverList removeObjectsAtIndexes:serverIndexes];
}

- (void)modifyServer:(Server *)server setObjectValue:(id)object forKey:(NSString *)key {
	[server setValue:object forKey:key];
	if ([key isEqualToString:@"active"]) {
		if ([object boolValue]) {
			NSInteger index = [self.serverList indexOfObject:server];
			[self.statusItemController addServer:server atIndex:index];
		}
		
	}
}


- (void)checkServers:(NSTimer *)timer {
	NSLog(@"Timer out");
}

@end
