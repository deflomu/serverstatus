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
	[GrowlApplicationBridge notifyWithTitle:@"Server down"
								description:[NSString stringWithFormat:@"%@ is down", server.serverName]
						   notificationName:@"Fail"
								   iconData:nil
								   priority:1
								   isSticky:NO
							   clickContext:nil];
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
	}
	return self;
}


@end
