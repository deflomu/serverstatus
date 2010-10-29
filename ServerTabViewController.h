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
	IBOutlet NSTextField *serverName;
	IBOutlet NSTextField *serverHost;
	IBOutlet NSTextField *lastKnownAddress;
	IBOutlet NSTextField *version;
		
	Server *server;
}
@property (assign) IBOutlet NSTextField *serverName;
@property (assign) IBOutlet NSTextField *serverHost;
@property (assign) IBOutlet NSTextField *lastKnownAddress;
@property (assign) IBOutlet NSTextField *version;

@property (nonatomic, assign) Server *server;

- (void)updateView;

@end
