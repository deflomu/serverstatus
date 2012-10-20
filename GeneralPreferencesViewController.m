//
//  GeneralPreferencesViewController.m
//  ServerStatus
//
//  Created by Florian Mutter on 12.10.12.
//  Copyright (c) 2012 skweez.net. All rights reserved.
//

#import "GeneralPreferencesViewController.h"
#import "AutostartManager.h"

@interface GeneralPreferencesViewController ()

@end

@implementation GeneralPreferencesViewController

@synthesize version, startAtLoginCheckBox, webView;

- (id)init
{
    self = [super initWithNibName:@"GeneralPreferencesView" bundle:nil];
    if (self) {

    }
    return self;
}

#pragma mark -
#pragma mark Autostart

- (IBAction)autostartButtonSelector:(NSButton *)sender {
	[[AutostartManager sharedAutostartManager] startAtLogin:[sender state]];
}

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
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

- (void)viewWillAppear {
    /* Set autostart checkbox according to current status.  */
	[self.startAtLoginCheckBox setState:[[AutostartManager sharedAutostartManager] isStartingAtLogin]];
}

#pragma mark -
#pragma mark NSViewController methodes

- (void)viewDidLoad {
    [self setWebViewContent];
    NSString *_version = [NSString stringWithFormat:@"%@ (%@)",
                          [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"],
                          [[NSBundle mainBundle] objectForInfoDictionaryKey: @"BuildRevision"]];
    [self.version setStringValue:_version];
}

- (void)loadView {
    [super loadView];
    [self viewDidLoad];
}

@end
