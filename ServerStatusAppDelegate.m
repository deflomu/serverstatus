//
//  ServerStatusAppDelegate.m
//  ServerStatus
//
//  Created by Florian Mutter on 11.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "ServerStatusAppDelegate.h"
#import "PreferenceWindowController.h"
#import "ServerListController.h"
#import "StatusItemController.h"
#import "NetworkMonitor.h"


@implementation ServerStatusAppDelegate
@synthesize serverListController, statusItemController, suupdater;

#pragma mark -
#pragma mark General functions
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	/* Start network monitoring */
	[[NetworkMonitor sharedNetworkMonitor] monitorNetwork]; 
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	/* save serverList in user preferences */
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.serverListController.serverList];
	[defaults setObject:data forKey:@"serverList"];
}

- (void)awakeFromNib {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
								 /* Just enable automatic updates and don't ask the user about it */
								 [NSNumber numberWithBool:YES], @"SUEnableAutomaticChecks",
								 nil];
	[defaults registerDefaults:appDefaults];
	
		//[self registerForLogin];
}

#pragma mark PreferenceWindowController
- (IBAction)showPreferenceWindow:(id)sender {
	if(!preferenceWindowController) {
		preferenceWindowController = [[PreferenceWindowController alloc] init];
	}
	preferenceWindowController.serverListController = self.serverListController;
	[NSApp activateIgnoringOtherApps:YES];
	[preferenceWindowController showWindow:self];
}


@end
