//
//  ServerStatusAppDelegate.h
//  ServerStatus
//
//  Created by Florian Mutter on 11.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ServerStatusAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	IBOutlet NSMenu *statusMenu;
	NSStatusItem *statusItem;
	
	NSImage *serversOk, *serversOkAlternate,
			*serversWarning, *serversWarningAlternate,
			*serversFail, *serversFailAlternate,
			*serversInactive, *serversInactiveAlternate;
	
}

@property (assign) IBOutlet NSWindow *window;

- (void)setImage:(NSImage *)status;

@end
