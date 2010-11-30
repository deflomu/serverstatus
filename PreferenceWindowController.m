//
//  PreferenceWindowController.m
//  ServerStatus
//
//  Created by Florian Mutter on 24.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "PreferenceWindowController.h"


@implementation PreferenceWindowController
@synthesize webView, version, serverListTableController, serverListController;

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
	
	[self.version setStringValue:[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
}

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element 
    defaultMenuItems:(NSArray *)defaultMenuItems
{
	/* Disable right-click context menu */
    return nil;
}
	 
- (void)windowWillClose:(NSNotification *)notification {
	/*[self autorelease];*/
	/* TODO: implement release of window and controller to save memory */
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

@end
