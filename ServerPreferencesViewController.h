//
//  ServerPreferencesViewController.h
//  ServerStatus
//
//  Created by Florian Mutter on 12.10.12.
//  Copyright (c) 2012 skweez.net. All rights reserved.
//

#import "MASPreferencesViewController.h"

@class ServerListController;
@class ServerListTableController;

@interface ServerPreferencesViewController : NSViewController <MASPreferencesViewController> {
    ServerListController *serverListController;
	ServerListTableController *serverListTableController;
}

@property (assign) ServerListController *serverListController;
@property (assign) IBOutlet ServerListTableController *serverListTableController;

@end
