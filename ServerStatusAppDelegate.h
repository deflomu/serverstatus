//
//  ServerStatusAppDelegate.h
//  ServerStatus
//
//  Created by Florian Mutter on 11.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"

@interface ServerStatusAppDelegate : NSObject <NSApplicationDelegate, ServerDelegate> {
    NSWindow *window;
	
	NSMutableArray *serverList;
		
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSMutableArray *serverList;

@end
