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
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,kLSSharedFileListSessionLoginItems, NULL);
	
	if ( !loginItems ) {
		DLog(@"Could not retrieve loginItems.");
		return NULL;
	}
	
	LSSharedFileListItemRef existingItem = NULL;
	UInt32 seedValue;
	/* Search for the login itme to delete it from the list */
	NSArray  *loginItemsArray = [NSMakeCollectable(LSSharedFileListCopySnapshot(loginItems, &seedValue)) autorelease];
	for(id itemObject in loginItemsArray){
		LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)itemObject;
		
		UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
		CFURLRef itemUrl = NULL;
		/* Resolve the item with URL */
		if (LSSharedFileListItemResolve(itemRef, resolutionFlags, &itemUrl, NULL) == noErr) {
			if ( CFEqual(url, itemUrl) ) {
				existingItem = itemRef;
			}
		}
		if (itemUrl) {
			CFRelease(itemUrl);
		}
	}

	return existingItem;
}

#pragma mark -
#pragma mark Public
- (NSInteger)isStartingAtLogin {
	return [self getApplicationsLoginItem] != NULL;
}

- (void)startAtLogin:(BOOL)enabled {
	/* Get list of users login items */
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,kLSSharedFileListSessionLoginItems, NULL);
	
	LSSharedFileListItemRef itemRef = [self getApplicationsLoginItem];
	
	if (enabled && itemRef == NULL) {
		/* Add App to login item list with icon */
		
		NSURL *url = [[NSBundle mainBundle] bundleURL];
		
		IconRef icon = [[NSApp applicationIconImage] iconRefRepresentation];
		
		LSSharedFileListInsertItemURL(loginItems,
									  kLSSharedFileListItemLast,
									  NULL /*displayName*/,
									  icon,
									  (CFURLRef)url,
									  NULL /*propertiesToSet*/, 
									  NULL /*propertiesToClear*/);
	} else if (!enabled && itemRef != NULL) {
		/* Remove App from login item list */
		LSSharedFileListItemRemove(loginItems, itemRef);
	}
}

@end
