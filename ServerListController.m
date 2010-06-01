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

#pragma mark -
#pragma mark Init
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
}

#pragma mark -
#pragma mark Public
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

- (void)checkServers {		
	NSLog(@"Checking servers");
	for (Server *server in self.serverList) {
		if (server.active) {
			[server performSelectorInBackground:@selector(ping) withObject:self];
		}
	}
}


@end
