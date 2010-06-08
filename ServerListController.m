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
#pragma mark Public
- (void)addServer:(Server *)server {
    [self.serverList addObject:server];
	if (server.active) {
		[self.statusItemController addServer:server atIndex:[self.serverList count]-1];
	}
}

- (void)addServer:(Server *)server atIndex:(NSInteger)index {
    [self.serverList insertObject:server atIndex:index];
	if (server.active) {
		[self.statusItemController addServer:server atIndex:index];
	}
}

- (void)removeServers:(NSIndexSet *)serverIndexes {
	NSInteger index = [serverIndexes firstIndex];
	while (NSNotFound != index) {
		[self removeServerAtIndex:index];
		index = [serverIndexes indexGreaterThanIndex:index];
	}
}

- (void)removeServerAtIndex:(NSInteger)index {
	Server *server = [self.serverList objectAtIndex:index];
	if (server.active) {
		[self.statusItemController removeServer:server atIndex:index];
	}
	[self.serverList removeObjectAtIndex:index];
}

- (void)modifyServer:(Server *)server setObjectValue:(id)object forKey:(NSString *)key {
	[server setValue:object forKey:key];
	if ([key isEqualToString:@"active"]) {
		NSInteger index = [self.serverList indexOfObject:server];
		if ([object boolValue]) {
			[self.statusItemController addServer:server atIndex:index];
		} else {
			[self.statusItemController removeServer:server atIndex:index];
		}
		
	}
}

- (void)checkServers:(NSTimer *)timer {		
	NSLog(@"Checking servers");
	for (Server *server in self.serverList) {
		if (server.active) {
			[server performSelectorInBackground:@selector(ping) withObject:self];
		}
	}
}

#pragma mark -
#pragma mark Notification reciever
- (void)networkConnectionChanged:(NSNotification *)notification {
	BOOL hasConnection = [[[notification userInfo] objectForKey:@"networkAvailable"] boolValue];
	
	if (hasConnection) {
		[self checkServers:NULL];
		
		timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
														  target:self
														selector:@selector(checkServers:)
														userInfo:nil
														 repeats:YES];
						  
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
		
	} else {
		[timer invalidate];
	}
}

#pragma mark -
#pragma mark Init
- (id) init
{
	self = [super init];
	if (self != nil) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self
			   selector:@selector(networkConnectionChanged:)
				   name:NetworkChangeNotification
				 object:nil];
	}
	return self;
}

- (void) dealloc
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[super dealloc];
}


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

@end
