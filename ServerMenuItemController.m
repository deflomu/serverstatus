//
//  ServerMenuItemController.m
//  ServerStatus
//
//  Created by Florian Mutter on 29.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "ServerMenuItemController.h"
#import "MenuItemView.h"

@implementation ServerMenuItemController
@synthesize serverMenuItemView;

+ (ServerMenuItemController *)serverMenuItemController {
	return [[[ServerMenuItemController alloc] init] autorelease];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		[NSBundle loadNibNamed:@"ServerMenuItem" owner:self];
	}
	return self;
}

- (void) dealloc
{
	self.serverMenuItemView = nil;
	[super dealloc];
}



@end
