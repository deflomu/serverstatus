//
//  PreferenceWindowController.m
//  ServerStatus
//
//  Created by Florian Mutter on 24.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "PreferenceWindowController.h"


@implementation PreferenceWindowController
@synthesize tabView, webView, serverListController;

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

- (void)windowDidLoad {
	[self.webView setMainFrameURL:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"]];
	[self.webView setDrawsBackground:NO];
	[self.webView setUIDelegate:self];
	[self.webView setPolicyDelegate:self];
	[self.webView setEditingDelegate:self];
}

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element 
    defaultMenuItems:(NSArray *)defaultMenuItems
{
		// disable right-click context menu
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

- (IBAction)showWindow:(id) sender {
	[self.tabView selectTabViewItem:[self.tabView tabViewItemAtIndex:0]];
	[super showWindow:sender];
}

#pragma mark -
#pragma mark Actions
- (IBAction)pushClose:(NSButton *)sender {
	[self.window performClose:self];
}

@end
