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
- (void)sendNotificationNetworkChanged {
	/* Create the data that is send with the notification */
	NSDictionary *d = [NSDictionary
					   dictionaryWithObject:[NSNumber numberWithBool:networkAvailable]
					   forKey:@"networkAvailable"];
	/* Post the notification */
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
	
	/**
	 * If the network is capable of reaching skweez.net and this is not a
	 * inactive dialup connection, we are on
	 **/
	if (flags & kSCNetworkFlagsReachable && !(flags & kSCNetworkFlagsConnectionRequired)) {
		if (!_self.networkAvailable) {
			_self.networkAvailable = YES;
			[_self sendNotificationNetworkChanged];
		}
	} else {
		if (_self.networkAvailable) {
			_self.networkAvailable = NO;
			[_self sendNotificationNetworkChanged];
		}
	}
}

/* We want to be notified if the network status of the machine is changing */
- (void)monitorNetwork {
	SCNetworkReachabilityRef network = SCNetworkReachabilityCreateWithName(NULL, "skweez.net");
	
	SCNetworkReachabilityContext context = {0, self, NULL, NULL, NULL};
	
	SCNetworkReachabilitySetCallback(network, networkStatusChanged, &context);
	SCNetworkReachabilityScheduleWithRunLoop(network, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
}

#pragma mark Login Item
- (void)registerForLogin {
	/* Get url to app bundle */
	NSURL *url = [[NSBundle mainBundle] bundleURL];
	
	/* Get list of users login items */
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,kLSSharedFileListSessionLoginItems, NULL);
	
	if ( !loginItems ) {
		DLog(@"Could not retrieve loginItems.");
		return;
	}
	
	if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"startAtLogin"] ) {
		
		/* Add app to login items list */
		LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemLast, NULL, NULL, url, NULL, NULL);
		
	} else {
		
		UInt32 seedValue;
        /* Search for the login itme to delete it from the list */
		NSArray  *loginItemsArray = (NSArray *)LSSharedFileListCopySnapshot(loginItems, &seedValue);
		CFURLRef itemUrl;
		int i = 0;
		for(i; i < [loginItemsArray count]; i++){
			LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)[loginItemsArray
																		objectAtIndex:i];
			/* Resolve the item with URL */
			if (LSSharedFileListItemResolve(itemRef, 0, &itemUrl, NULL) == noErr) {
				if ( [url isEqual:itemUrl] ) {
					LSSharedFileListItemRemove(loginItems, itemRef);
				}
			}
		}
		[loginItemsArray release];
		CFRelease(&itemUrl);

	}
	
	CFRelease(loginItems);

}

#pragma mark -
#pragma mark General functions
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	/* save serverList in user preferences */
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.serverListController.serverList];
	[defaults setObject:data forKey:@"serverList"];
}

- (void)awakeFromNib {
	/* Just enable automatic updates and don't ask the user about it */
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
															forKey:@"SUEnableAutomaticChecks"];
	[defaults registerDefaults:appDefaults];
	
	[self monitorNetwork];
}

#pragma mark PreferenceWindowController
- (IBAction)showPreferenceWindow:(id)sender {
	if(!preferenceWindowController) {
		preferenceWindowController = [[PreferenceWindowController alloc] init];
	}
	preferenceWindowController.serverListController = self.serverListController;
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[preferenceWindowController showWindow:self];
}


@end
