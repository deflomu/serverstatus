//
//  PreferenceWindowController.h
//  ServerStatus
//
//  Created by Florian Mutter on 24.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class ServerListController;
@class ServerListTableController;

@interface PreferenceWindowController : NSWindowController <NSWindowDelegate> {
	ServerListController *serverListController;
	ServerListTableController *serverListTableController;
	WebView *webView;
	NSTextField *version;
	NSButton *startAtLoginCheckBox;
}

@property (assign) ServerListController *serverListController;
@property (assign) IBOutlet ServerListTableController *serverListTableController;
@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSTextField *version;
@property (assign) IBOutlet NSButton *startAtLoginCheckBox;

- (IBAction)autostartButtonSelector:(NSButton *)sender;

@end
