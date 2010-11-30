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
@synthesize serverListController, statusItemController, suupdater;

#pragma mark Login Item
- (IBAction)registerForLogin:(id)sender {
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
		CFURLRef itemUrl = NULL;
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
			CFRelease(itemUrl);
			
		}
		[loginItemsArray release];
		
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
