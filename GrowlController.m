//
//  GrowlController.m
//  ServerStatus
//
//  Created by Florian Mutter on 09.06.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "GrowlController.h"


@implementation GrowlController

#pragma mark -
#pragma mark Public
- (void)growlServerFailed:(Server *)server {
	if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"showGrowlNotifications"] ) {
		[GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:@"%@ is down", server.serverName]
									description:[server.serverError localizedDescription]
							   notificationName:@"Fail"
									   iconData:[NSData
												 dataWithData:[[NSImage
																imageNamed:@"ServerStatus.icns"] TIFFRepresentation]]
									   priority:1
									   isSticky:[[NSUserDefaults standardUserDefaults]
												 boolForKey:@"growlNotificationSticky"]
								   clickContext:nil];
	}
}

- (void)growlServerError:(Server *)server {
	
}

#pragma mark -
#pragma mark Growl delegates
- (NSDictionary *) registrationDictionaryForGrowl {
	NSArray* defaults = [NSArray arrayWithObjects:@"Fail", @"Error", nil];
	
    NSDictionary* growlRegDict = [NSDictionary dictionaryWithObjectsAndKeys:
								  defaults, GROWL_NOTIFICATIONS_DEFAULT,
								  defaults, GROWL_NOTIFICATIONS_ALL,
								  nil];
	
    return growlRegDict;
}

- (NSString *) applicationNameForGrowl {
	return @"Server Status";
}

#pragma mark -
#pragma mark Init
- (id) init
{
	self = [super init];
	if (self != nil) {
		[GrowlApplicationBridge setGrowlDelegate:self];
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
									 [NSNumber numberWithBool:YES], @"showGrowlNotifications",
									 [NSNumber numberWithBool:NO], @"growlNotificationSticky",
									 nil];
		
		[defaults registerDefaults:appDefaults];
		
	}
	return self;
}


@end
