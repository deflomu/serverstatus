//
//  ServerTabViewController.h
//  ServerStatus
//
//  Created by Florian Mutter on 24.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"


@interface ServerTabViewController : NSObject <NSTextFieldDelegate> {
	NSTextField *serverName;
	NSTextField *serverHost;
	NSTextField *lastKnownAddress;
	NSTextField *serverStatus;
	
	Server *server;
}

@property (assign) IBOutlet NSTextField *serverName;
@property (assign) IBOutlet NSTextField *serverHost;
@property (assign) IBOutlet NSTextField *lastKnownAddress;
@property (assign) IBOutlet NSTextField *serverStatus;

@property (nonatomic, assign) Server *server;

- (void)updateView;

@end
