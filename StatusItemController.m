//
//  StatusItemController.m
//  ServerStatus
//
//  Created by Florian Mutter on 20.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "StatusItemController.h"


@implementation StatusItemController
@synthesize statusItem;

#pragma mark -
#pragma mark Initialisation
- (id) init
{
	self = [super init];
	if (self != nil) {
		NSStatusBar *bar = [NSStatusBar systemStatusBar];
		statusItem = [[bar statusItemWithLength:NSVariableStatusItemLength] retain];
	}
	return self;
}

- (void) dealloc
{
	self.statusItem = NULL;
	[super dealloc];
}



- (void)awakeFromNib {
	[self loadStatusItemImages];
	
	[statusItem setMenu:statusMenu];
	[statusItem setImage:serversInactive];
	[statusItem setAlternateImage:serversInactiveAlternate];
	[statusItem setHighlightMode:YES];
	
}

#pragma mark -
#pragma mark StatusItemController
- (void)loadStatusItemImages {
	serversOk = [NSImage imageNamed:@"serverOk"];
	serversOkAlternate = [NSImage imageNamed:@"serverOkAlternate"];
	
	serversWarning = [NSImage imageNamed:@"serverWarning"];
	serversWarningAlternate = [NSImage imageNamed:@"serverWarningAlternate"];
	
	serversFail = [NSImage imageNamed:@"serverFail"];
	serversFailAlternate = [NSImage imageNamed:@"serverFailAlternate"];
	
	serversInactive = [NSImage imageNamed:@"serverInactive"];
	serversInactiveAlternate = serversOkAlternate;
}

- (void)addServersToMenu:(NSMutableArray *) serverList {
	NSData* viewCopyData = [NSArchiver archivedDataWithRootObject:statusItemMenuView];
	id viewCopy;
	NSMenuItem* menuItem;
	
	for (int i = 0; i < [serverList count]; i++) {
		viewCopy = [NSUnarchiver unarchiveObjectWithData:viewCopyData];
		
		NSTextField *serverName;
		NSTextField *serverStatusText;
		serverName = [viewCopy viewWithTag:SERVER_NAME_TEXTFIELD];
		serverStatusText = [viewCopy viewWithTag:SERVER_STATUSTEXT_TEXTFIELD];
		
		[serverName setStringValue:[[serverList objectAtIndex:i] serverName]];
		
		
		menuItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
					initWithTitle:@"Server" action:NULL keyEquivalent:@""];
		[statusMenu insertItem:menuItem atIndex:0];
		[menuItem setView: viewCopy];
		[menuItem setTarget:self];
	}
	
}

- (void)setStatusItemFail {
	[statusItem setImage:serversFail];
	[statusItem setAlternateImage:serversFailAlternate];
}

@end
