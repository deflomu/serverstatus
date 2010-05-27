//
//  ServerStatusAppDelegate.m
//  ServerStatus
//
//  Created by Florian Mutter on 11.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "ServerStatusAppDelegate.h"
#import "PreferenceWindowController.h"

@implementation ServerStatusAppDelegate

@synthesize serverListController;

#pragma mark -
#pragma mark General functions
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						   [NSKeyedArchiver archivedDataWithRootObject:[NSArray array]], @"serverList",
						   nil];
	[defaults registerDefaults:dict];
	
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.serverListController.serverList];
	[defaults setObject:data forKey:@"serverList"];
}

#pragma mark PreferenceWindowController
- (IBAction)showPreferenceWindow:(id)sender {
	NSLog(@"preferences");
	if(!preferenceWindowController) {
		preferenceWindowController = [[PreferenceWindowController alloc] init];
	}
	preferenceWindowController.serverListController = self.serverListController;
	[preferenceWindowController showWindow:self];
	[preferenceWindowController.window orderFrontRegardless];
}

@end
