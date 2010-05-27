//
//  StatusItemController.m
//  ServerStatus
//
//  Created by Florian Mutter on 20.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "StatusItemController.h"


@implementation StatusItemController
@synthesize statusItem, serverMenuItems, activeServerList, statusMenu;

#pragma mark -
#pragma mark Initialisation
- (id) init
{
	self = [super init];
	if (self != nil) {
		self.activeServerList = [NSMutableArray array];
	}
	return self;
}


- (void) dealloc
{
	self.activeServerList =NULL;
	self.statusItem = NULL;
	[super dealloc];
}

- (void)awakeFromNib {
	NSStatusBar *bar = [NSStatusBar systemStatusBar];
	self.statusItem = [[bar statusItemWithLength:NSVariableStatusItemLength] retain];
	
	[self loadStatusItemImages];
	
	[self.statusItem setMenu:statusMenu];
	[self.statusItem setImage:serversInactive];
	[self.statusItem setAlternateImage:serversInactiveAlternate];
	[self.statusItem setHighlightMode:YES];
	
}

#pragma mark Private
- (NSString *)getStatusString:(ServerStatus) serverStatus {
	NSString *status;
	switch (serverStatus) {
		case SERVER_OK:
			status = NSLocalizedString(@"Server is reachable",@"Server is reachable");
			break;
		case SERVER_FAIL:
			status = NSLocalizedString(@"Server is down",@"Server is down");
			break;
		case SERVER_UNKNOWN:
			status = NSLocalizedString(@"Server status is unknown",@"Server status is unknown");
			break;
		default:
			status = NSLocalizedString(@"No server status is set",@"No server status is set");
			break;
	}
	return status;
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


- (void)setStatusItemFail {
	[self.statusItem setImage:serversFail];
	[self.statusItem setAlternateImage:serversFailAlternate];
}

#pragma mark Menu Item Views
- (NSMenuItem *)createMenuItem:(Server *)server {
	NSData *viewCopyData = [NSArchiver archivedDataWithRootObject:serverItemMenuView];
	id viewCopy = [NSUnarchiver unarchiveObjectWithData:viewCopyData];
	NSTextField *serverName = [viewCopy viewWithTag:NAME_TEXTFIELD];
	NSTextField *serverStatus = [viewCopy viewWithTag:STATUS_TEXTFIELD];
	
	[serverName setStringValue:server.serverName];
	[serverStatus setStringValue:[self getStatusString:server.serverStatus]];
	
	NSMenuItem *menuItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
				initWithTitle:@"" action:NULL keyEquivalent:@""];
	[menuItem setView: viewCopy];
	[menuItem setTarget:self];
	return menuItem;
}

#pragma mark -
#pragma mark Public
- (void)addServer:(Server *)server atIndex:(NSInteger)index {
	if (index > [activeServerList count]) {
		index = [activeServerList count];
	}
	[self.activeServerList insertObject:server atIndex:index];
	
	[server addObserver:self
			forKeyPath:@"serverStatus"
				options:NSKeyValueObservingOptionNew
				context:NULL];
	
	[server addObserver:self
			 forKeyPath:@"serverName"
				options:NSKeyValueObservingOptionNew
				context:NULL];
	
	[server addObserver:self
			 forKeyPath:@"active"
				options:NSKeyValueObservingOptionNew
				context:NULL];
		
	NSMenuItem *item = [self createMenuItem:server];
	[self.statusMenu insertItem:item atIndex:index];
}

- (void)removeServer:(Server *)server {
	[server removeObserver:self forKeyPath:@"serverStatus"];
	[server removeObserver:self forKeyPath:@"serverName"];
	[server removeObserver:self forKeyPath:@"active"];
	[self.statusMenu removeItemAtIndex:[self.activeServerList indexOfObject:server]];
	[self.activeServerList removeObject:server];
}

#pragma mark -
#pragma mark Observer
- (void)observeValueForKeyPath:(NSString *)keyPath 
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context {
	NSInteger index = [self.activeServerList indexOfObject:object];
	if ([keyPath isEqualToString:@"serverStatus"]) {
		ServerStatus status = [[change valueForKey:NSKeyValueChangeNewKey] intValue];
		NSMenuItem *item = [self.statusMenu itemAtIndex:index];
		[[[item view] viewWithTag:STATUS_TEXTFIELD] setStringValue:[self getStatusString:status]];
	}
	if ([keyPath isEqualToString:@"serverName"]) {
		NSString *serverName = [change valueForKey:NSKeyValueChangeNewKey];
		NSMenuItem *item = [self.statusMenu itemAtIndex:index];
		[[[item view] viewWithTag:NAME_TEXTFIELD] setStringValue:serverName];
	}
	if ([keyPath isEqualToString:@"active"]) {
		if (![[change valueForKey:NSKeyValueChangeNewKey] boolValue]) {
			[self removeServer:object];
		}
		
	}
}

@end
