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
#pragma mark Network Status
static void networkStatusChanged(SCNetworkReachabilityRef	network,
								 SCNetworkConnectionFlags	flags,
								 void *                      info
								 ) {
	if (flags & kSCNetworkFlagsReachable && !(flags & kSCNetworkFlagsConnectionRequired)) {
		NSLog(@"Network avaiable");
	} else {
		NSLog(@"Network not available");
	}

}

#pragma mark -
#pragma mark General functions
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						   [NSKeyedArchiver archivedDataWithRootObject:[NSArray array]], @"serverList",
						   nil];
	[defaults registerDefaults:dict];
	
	SCNetworkReachabilityRef network = SCNetworkReachabilityCreateWithName(NULL, "skweez.net");
	SCNetworkReachabilitySetCallback(network, networkStatusChanged, NULL);
	SCNetworkReachabilityScheduleWithRunLoop(network, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
	CFRunLoopRun();
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.serverListController.serverList];
	[defaults setObject:data forKey:@"serverList"];
}

#pragma mark PreferenceWindowController
- (IBAction)showPreferenceWindow:(id)sender {
	if(!preferenceWindowController) {
		preferenceWindowController = [[PreferenceWindowController alloc] init];
	}
	preferenceWindowController.serverListController = self.serverListController;
	[preferenceWindowController showWindow:self];
	[preferenceWindowController.window orderFrontRegardless];
}


@end
