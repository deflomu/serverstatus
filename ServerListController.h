//
//  ServerListController.h
//  ServerStatus
//
//  Created by Florian Mutter on 27.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#define TIMER_INTERVAL 30

#import <Cocoa/Cocoa.h>
#import "Server.h"
#import "StatusItemController.h"

@interface ServerListController : NSObject {
	NSMutableArray *serverList;
	StatusItemController *statusItemController;
	NSTimer *timer;
}
@property (retain) NSMutableArray *serverList;
@property (assign) IBOutlet StatusItemController *statusItemController;

- (void)addServer:(Server *)server;
- (void)addServer:(Server *)server atIndex:(NSInteger)index;
- (void)removeServers:(NSIndexSet *)serverIndexes;
- (void)removeServerAtIndex:(NSInteger)index;
- (void)modifyServer:(Server *)server setObjectValue:(id)object forKey:(NSString *)key;

@end
