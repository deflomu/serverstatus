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

@interface PreferenceWindowController : NSWindowController <NSWindowDelegate> {
	ServerListController *serverListController;
	ServerListTableController *serverListTableController;
	WebView *webView;
	NSTextField *version;
}

@property (assign) ServerListController *serverListController;
@property (assign) IBOutlet ServerListTableController *serverListTableController;
@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSTextField *version;

@end
