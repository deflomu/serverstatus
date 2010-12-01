//
//  ServerListTableController.h
//  ServerStatus
//
//  Created by Florian Mutter on 21.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#define ServerItemFileType @"net.skweez.ServerStatus.ServerItem"

#import <Cocoa/Cocoa.h>

@class ServerTabViewController;
@class ServerListController;


@interface ServerListTableController : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
    NSTableView *serverListTable;
	ServerTabViewController *serverTabViewController;
	ServerListController *serverListController;
	
}
@property (assign) IBOutlet NSTableView *serverListTable;
@property (assign) IBOutlet ServerTabViewController *serverTabViewController;
@property (assign) ServerListController *serverListController;


- (IBAction)pushAddServer:(NSButton *)sender;
- (IBAction)pushRemoveServer:(NSButton *)sender;
@end
