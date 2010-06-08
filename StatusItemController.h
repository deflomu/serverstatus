//
//  StatusItemController.h
//  ServerStatus
//
//  Created by Florian Mutter on 20.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"
#import "ServerMenuItemController.h"
#import "MenuItemView.h"

#define NAME_TEXTFIELD 0
#define STATUS_TEXTFIELD 1

@interface StatusItemController : NSObject {
	IBOutlet NSMenu *statusMenu;
	NSStatusItem *statusItem;
		
	NSImage *serversOk, *serversOkAlternate,
	*serversWarning, *serversWarningAlternate,
	*serversFail, *serversFailAlternate,
	*serversInactive, *serversInactiveAlternate;
	
	NSMutableArray *activeServerList;
	
	NSInteger serversDownCounter;
	NSInteger serversErrorCounter;
	
	BOOL hasConnection;
}

@property (retain) NSStatusItem *statusItem;
@property (assign) NSMenu *statusMenu;
@property (retain) NSMutableArray *activeServerList;

- (void)addServer:(Server *)server atIndex:(NSInteger)index;
- (void)removeServer:(Server *)server atIndex:(NSInteger)index;

@end
