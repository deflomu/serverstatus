//
//  ServerStatusAppDelegate.h
//  ServerStatus
//
//  Created by Florian Mutter on 11.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "SimplePing.h"

@interface ServerStatusAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	IBOutlet NSMenu *statusMenu;
	NSStatusItem *statusItem;
	
	NSImage *serversOk, *serversOkAlternate,
			*serversWarning, *serversWarningAlternate,
			*serversFail, *serversFailAlternate,
			*serversInactive, *serversInactiveAlternate;
	
	SimplePing *_pinger;
	
}

- (void)runWithHostName:(NSString *)hostName;

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain, readwrite) SimplePing *pinger;

@end
