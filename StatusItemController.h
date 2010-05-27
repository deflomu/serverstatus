//
//  StatusItemController.h
//  ServerStatus
//
//  Created by Florian Mutter on 20.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"

#define NAME_TEXTFIELD 0
#define STATUS_TEXTFIELD 1

@interface StatusItemController : NSObject {
	IBOutlet NSMenu *statusMenu;
	IBOutlet NSView *serverItemMenuView;
	NSStatusItem *statusItem;
		
	NSImage *serversOk, *serversOkAlternate,
	*serversWarning, *serversWarningAlternate,
	*serversFail, *serversFailAlternate,
	*serversInactive, *serversInactiveAlternate;
	
	NSMutableArray *serverMenuItems;
	NSMutableArray *activeServerList;
}

@property (retain) NSStatusItem *statusItem;
@property (assign) NSMenu *statusMenu;
@property (retain) NSMutableArray *serverMenuItems;
@property (retain) NSMutableArray *activeServerList;


- (void)loadStatusItemImages;
- (void)setStatusItemFail;
- (void)addServer:(Server *)server atIndex:(NSInteger)index;
- (void)removeServer:(Server *)server;
- (NSString *)getStatusString:(ServerStatus)serverStatus;

@end
