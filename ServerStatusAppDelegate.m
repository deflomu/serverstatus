//
//  ServerStatusAppDelegate.m
//  ServerStatus
//
//  Created by Florian Mutter on 11.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "ServerStatusAppDelegate.h"
#import "ServerListController.h"
#import "NetworkMonitor.h"
#import "AutostartManager.h"
#import "GeneralPreferencesViewController.h"
#import "ServerPreferencesViewController.h"
#import "MASPreferencesWindowController.h"


@implementation ServerStatusAppDelegate
@synthesize serverListController, statusItemController, suupdater;

#pragma mark -
#pragma mark First Launch
- (void)firstLaunch {
	DLog(@"First launch of ServerStatus");
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if (![[AutostartManager sharedAutostartManager] isStartingAtLogin]) {
		NSInteger ret = NSRunAlertPanel(@"Start ServerStatus automatically when you log in?",
										@"To allow ServerStatus to check your servers automatically, it should be started when you login.",
										@"Yes", @"No", NULL);
		switch (ret){
			case NSAlertDefaultReturn:
				[[AutostartManager sharedAutostartManager] startAtLogin:YES];
				break;
			default:
				break;
		}
	}
	
	[defaults setBool:YES forKey:@"hasStartedBefore"];
	[defaults synchronize];
}


#pragma mark -
#pragma mark General functions
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	/* Start network monitoring */
	[[NetworkMonitor sharedNetworkMonitor] monitorNetwork];
	
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasStartedBefore"]) {
		[self firstLaunch];
	}
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	/* save serverList in user preferences */
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.serverListController.serverList];
	[defaults setObject:data forKey:@"serverList"];
	[defaults synchronize];
}

- (void)awakeFromNib {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
								 /* Just enable automatic updates and don't ask the user about it */
								 [NSNumber numberWithBool:YES], @"SUEnableAutomaticChecks",
								 nil];
	[defaults registerDefaults:appDefaults];
}

#pragma mark PreferenceWindowController
- (NSWindowController *)preferencesWindowController
{
    if (_preferencesWindowController == nil)
    {
        GeneralPreferencesViewController *generalPreferencesViewController = [[GeneralPreferencesViewController alloc] init];
        ServerPreferencesViewController *serverPreferencesViewController = [[ServerPreferencesViewController alloc] init];
     
        serverPreferencesViewController.serverListController = self.serverListController;
        
        NSArray *controllers = [[NSArray alloc] initWithObjects:serverPreferencesViewController, generalPreferencesViewController, nil];
        
        [generalPreferencesViewController release];
        [serverPreferencesViewController release];
        
        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
        [[_preferencesWindowController.window standardWindowButton:NSWindowZoomButton] setEnabled:NO];
        _preferencesWindowController.window.styleMask = _preferencesWindowController.window.styleMask^NSResizableWindowMask;
        [controllers release];
    }
    return _preferencesWindowController;
}

- (IBAction)openPreferences:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [self.preferencesWindowController showWindow:nil];
}


@end
