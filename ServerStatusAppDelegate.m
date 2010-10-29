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
@synthesize serverListController, statusItemController, suupdater, networkAvailable;

#pragma mark -
#pragma mark Network Status
- (void)sendNotificationNetworkIsAvailable {
	NSDictionary *d = [NSDictionary
					   dictionaryWithObject:[NSNumber numberWithBool:networkAvailable]
					   forKey:@"networkAvailable"];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:NetworkChangeNotification
					  object:self
					userInfo:d];
}

static void networkStatusChanged(SCNetworkReachabilityRef	network,
								 SCNetworkConnectionFlags	flags,
								 void *						info
								 )
{
	ServerStatusAppDelegate *_self = (ServerStatusAppDelegate *)info;
	
	if (flags & kSCNetworkFlagsReachable && !(flags & kSCNetworkFlagsConnectionRequired)) {
		if (!_self.networkAvailable) {
			_self.networkAvailable = YES;
			[_self sendNotificationNetworkIsAvailable];
		}
	} else {
		if (_self.networkAvailable) {
			_self.networkAvailable = NO;
			[_self sendNotificationNetworkIsAvailable];
		}
	}
}

#pragma mark -
#pragma mark General functions
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
		// load default preferences
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						   [NSKeyedArchiver archivedDataWithRootObject:[NSArray array]], @"serverList",
						   nil];
	[defaults registerDefaults:dict];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
		// save serverList in user preferences
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.serverListController.serverList];
	[defaults setObject:data forKey:@"serverList"];
}

- (void)awakeFromNib {
	SCNetworkReachabilityRef network = SCNetworkReachabilityCreateWithName(NULL, "skweez.net");
	
	SCNetworkReachabilityContext context = {0, self, NULL, NULL, NULL};
	
	SCNetworkReachabilitySetCallback(network, networkStatusChanged, &context);
	SCNetworkReachabilityScheduleWithRunLoop(network, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
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
