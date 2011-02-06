//
//  AutostartManager.m
//  ServerStatus
//
//  Created by Florian Mutter on 01.12.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "AutostartManager.h"
#import "SynthesizeSingleton.h"
#import "NSImage+IconRef.h"


@implementation AutostartManager
SYNTHESIZE_SINGLETON_FOR_CLASS(AutostartManager)

#pragma mark -
#pragma mark Private
- (LSSharedFileListItemRef)getApplicationsLoginItem {
	/* Get url to app bundle */
	NSURL *url = [[NSBundle mainBundle] bundleURL];
	
	/* Get list of users login items */
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
															kLSSharedFileListSessionLoginItems,
															NULL);
	
	if (!loginItems) {
		NSLog(@"Could not retrieve session login items.");
		return NULL;
	}
	
	UInt32 seedValue;
	/* Search for the login itme to delete it from the list */
	NSArray  *loginItemsArray = [NSMakeCollectable(LSSharedFileListCopySnapshot(loginItems, &seedValue)) autorelease];
	CFRelease(loginItems);
	
	for(id item in loginItemsArray){		
		CFURLRef itemURLRef;
		/* Resolve the item with URL */
		if (LSSharedFileListItemResolve((LSSharedFileListItemRef)item, 0, &itemURLRef, NULL) == noErr) {
			NSURL *itemURL = (NSURL *)[NSMakeCollectable(itemURLRef) autorelease];
			if ( [itemURL isEqual:url] ) {
				CFRetain(item);
				return (LSSharedFileListItemRef)item;
			}
		}
	}
	
	return NULL;
}

#pragma mark -
#pragma mark Public
- (NSInteger)isStartingAtLogin {
	/* Check if application is starting at login */
	LSSharedFileListItemRef item = [self getApplicationsLoginItem];
	if (item) {
		CFRelease(item);
		return TRUE;
	}
	return FALSE;
}

- (void)startAtLogin:(BOOL)enabled {
	/* Get list of users login items */
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,kLSSharedFileListSessionLoginItems, NULL);
	
	if (!loginItems) {
		NSLog(@"Could not retrieve session login items.");
		return;
	}
	
	if (enabled) {
		/* Add App to login item list with icon */
		NSURL *url = [[NSBundle mainBundle] bundleURL];
		
		/* Get the applictions icon */
		IconRef icon = [[NSApp applicationIconImage] iconRefRepresentation];
		
		CFRelease(LSSharedFileListInsertItemURL(loginItems,
									  kLSSharedFileListItemLast,
									  NULL /*displayName*/,
									  icon,
									  (CFURLRef)url,
									  NULL /*propertiesToSet*/, 
									  NULL /*propertiesToClear*/));
	} else if (!enabled) {
		/* Remove App from login item list */
		LSSharedFileListItemRef item = [self getApplicationsLoginItem];
		if (item) {
			LSSharedFileListItemRemove(loginItems, item);
			CFRelease(item);
		}
	}
	
	CFRelease(loginItems);
}

@end
