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
	
	NSImage *statusOk, *statusFail, *statusUnknown, *statusWait;
	
}

@property (assign) IBOutlet NSWindow *window;

@end
