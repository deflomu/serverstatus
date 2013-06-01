//
//  StatusItemController.h
//  ServerStatus
//
//  Created by Florian Mutter on 20.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GrowlController;
@class Server;

#define NAME_TEXTFIELD 0
#define STATUS_TEXTFIELD 1
#define STATUS_ICON 2
#define SEPARATOR_MENU_ITEM_TAG 1000

@interface StatusItemController : NSObject {
	NSMenu *statusMenu;
	NSStatusItem *statusItem;
		
	NSImage *serversOk, *serversOkAlternate,
	*serversWarning, *serversWarningAlternate,
	*serversFail, *serversFailAlternate,
	*serversInactive, *serversInactiveAlternate;
	
	NSMutableArray *activeServerList;
	
	NSInteger serversDownCounter;
	NSInteger serversErrorCounter;
	
	BOOL hasConnection;
	
	GrowlController *growlController;
}

@property (retain) NSStatusItem *statusItem;
@property (retain) NSMenu *statusMenu;
@property (retain) NSMutableArray *activeServerList;

- (void)addServer:(Server *)server atIndex:(NSInteger)index;
- (void)removeServer:(Server *)server atIndex:(NSInteger)index;

@end
