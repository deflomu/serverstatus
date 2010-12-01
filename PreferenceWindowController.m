//
//  PreferenceWindowController.m
//  ServerStatus
//
//  Created by Florian Mutter on 24.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "PreferenceWindowController.h"
#import "AutostartManager.h"
#import "ServerListController.h"
#import "ServerListTableController.h"


@implementation PreferenceWindowController
@synthesize webView, version, serverListTableController, serverListController, startAtLoginCheckBox;


#pragma mark -
#pragma mark WebView
- (void)setWebViewContent {
	[self.webView setMainFrameURL:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"]];
	[self.webView setDrawsBackground:NO];
	[self.webView setUIDelegate:self];
	[self.webView setPolicyDelegate:self];
	[self.webView setEditingDelegate:self];
}

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element 
    defaultMenuItems:(NSArray *)defaultMenuItems
{
	/* Disable right-click context menu */
    return nil;
}

- (BOOL)webView:(WebView *)sender shouldChangeSelectedDOMRange:(DOMRange *)currentRange 
	 toDOMRange:(DOMRange *)proposedRange 
	   affinity:(NSSelectionAffinity)selectionAffinity 
 stillSelecting:(BOOL)flag
{
		// disable text selection
    return NO;
}

- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation 
		request:(NSURLRequest *)request
		  frame:(WebFrame *)frame
decisionListener:(id <WebPolicyDecisionListener>)listener
{
	[listener ignore];
    [[NSWorkspace sharedWorkspace] openURL:[request URL]];
}

#pragma mark -
#pragma mark Window methodes
- (IBAction)showWindow:(id)sender {
	/* Set autostart checkbox according to current status */
	[self.startAtLoginCheckBox setState:[[AutostartManager sharedAutostartManager] isStartingAtLogin]];
	[super showWindow:sender];
}

- (void)windowDidLoad {
	[self setWebViewContent];
	
	[self.version setStringValue:[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
	
	/* Set autostart checkbox according to current status.  */
	[self.startAtLoginCheckBox setState:[[AutostartManager sharedAutostartManager] isStartingAtLogin]];
}

#pragma mark -
#pragma mark Autostart

- (IBAction)autostartButtonSelector:(NSButton *)sender {
	[[AutostartManager sharedAutostartManager] startAtLogin:[sender state]];
}


#pragma mark -
#pragma mark init
- (id)init {
	if (![super initWithWindowNibName:@"Preferences"]) {
		return nil;
	}
	return self;
}

- (void)awakeFromNib {
	serverListTableController.serverListController = serverListController;
}


@end
