//
//  GeneralPreferencesViewController.h
//  ServerStatus
//
//  Created by Florian Mutter on 12.10.12.
//  Copyright (c) 2012 skweez.net. All rights reserved.
//

#import "MASPreferencesViewController.h"
#import <WebKit/WebKit.h>

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController> {
    WebView *webView;
	NSTextField *version;
	NSButton *startAtLoginCheckBox;
}

@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSTextField *version;
@property (assign) IBOutlet NSButton *startAtLoginCheckBox;

- (IBAction)autostartButtonSelector:(NSButton *)sender;

@end
