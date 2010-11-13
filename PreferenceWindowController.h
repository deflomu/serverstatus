//
//  PreferenceWindowController.h
//  ServerStatus
//
//  Created by Florian Mutter on 24.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "ServerListController.h"
#import "ServerListTableController.h"

@interface PreferenceWindowController : NSWindowController {
	ServerListController *serverListController;
	IBOutlet ServerListTableController *serverListTableController;
	IBOutlet NSTabView *tabView;
	IBOutlet WebView *webView;
}

@property (assign) ServerListController *serverListController;
@property (assign) IBOutlet NSTabView *tabView;
@property (assign) IBOutlet WebView *webView;

- (IBAction)pushClose:(NSButton *)sender;
@end
