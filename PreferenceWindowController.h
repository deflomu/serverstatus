//
//  PreferenceWindowController.h
//  ServerStatus
//
//  Created by Florian Mutter on 24.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ServerListController.h"
#import "ServerListTableController.h"

@interface PreferenceWindowController : NSWindowController {
	ServerListController *serverListController;
	ServerListTableController *serverListTableController;
}

@property (assign) ServerListController *serverListController;
@property (assign) IBOutlet ServerListTableController *serverListTableController;

- (IBAction)pushClose:(NSButton *)sender;
@end
