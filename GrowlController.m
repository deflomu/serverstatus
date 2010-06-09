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
#pragma mark Growl delegates
- (NSDictionary *) registrationDictionaryForGrowl {
	return nil;
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
