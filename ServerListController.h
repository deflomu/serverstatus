//
//  ServerListController.h
//  ServerStatus
//
//  Created by Florian Mutter on 27.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"
#import "StatusItemController.h"


@interface ServerListController : NSObject {
	NSMutableArray *serverList;
	StatusItemController *statusItemController;
}
@property (retain) NSMutableArray *serverList;
@property (assign) IBOutlet StatusItemController *statusItemController;

- (void)addServer:(Server *)server;
- (void)removeServers:(NSIndexSet *)serverIndexes;
- (void)modifyServer:(Server *)server setObjectValue:(id)object forKey:(NSString *)key;

- (void)checkServers;

@end
