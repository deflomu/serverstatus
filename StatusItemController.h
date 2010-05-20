//
//  StatusItemController.h
//  ServerStatus
//
//  Created by Florian Mutter on 20.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface StatusItemController : NSObject {
	IBOutlet NSMenu *statusMenu;
	IBOutlet NSView *statusItemMenuView;
	IBOutlet NSProgressIndicator *progressIndicator;
	NSStatusItem *statusItem;
	
	NSImage *serversOk, *serversOkAlternate,
	*serversWarning, *serversWarningAlternate,
	*serversFail, *serversFailAlternate,
	*serversInactive, *serversInactiveAlternate;
}

@property (retain) NSStatusItem *statusItem;

- (void)loadStatusItemImages;
- (void)addServersToMenu:(NSMutableArray *) serverList;
- (void)setStatusItemFail;

@end
