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
		case SERVER_ERROR:
			status = NSLocalizedString(@"An error occurred",@"An error occurred");
			break;
		default:
			status = NSLocalizedString(@"No server status is set",@"No server status is set");
			break;
	}
	return status;
}

- (void)setStatusItemFail {
	[self.statusItem setImage:serversFail];
	[self.statusItem setAlternateImage:serversFailAlternate];
}

- (void)statusOfServer:(Server *)server didChangeTo:(ServerStatus)status {
	NSInteger index = [self.activeServerList indexOfObject:server];
	NSMenuItem *item = [self.statusMenu itemAtIndex:index];
	if (status == SERVER_PINGING) {
		[(MenuItemView*)[item view] startSpinning];
	} else {
		[(MenuItemView*)[item view] stopSpinning];
		[[[item view] viewWithTag:STATUS_TEXTFIELD] setStringValue:[self getStatusString:status]];
		if (status == SERVER_FAIL) {
			NSLog(@"One Server is down");
		}
	}
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


#pragma mark Menu Item Views
- (NSMenuItem *)createMenuItem:(Server *)server {
	ServerMenuItemController *serverMenuItem = [ServerMenuItemController serverMenuItemController];
	MenuItemView *serverItemMenuView = serverMenuItem.serverMenuItemView;
	
	NSTextField *serverName = [serverItemMenuView viewWithTag:NAME_TEXTFIELD];
	NSTextField *serverStatus = [serverItemMenuView viewWithTag:STATUS_TEXTFIELD];
	
	[serverName setStringValue:server.serverName];
	[serverStatus setStringValue:[self getStatusString:server.serverStatus]];
	
	NSMenuItem *menuItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
				initWithTitle:@"" action:NULL keyEquivalent:@""];
	[menuItem setView:serverItemMenuView];
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

#pragma mark Status
- (void)networkConnectionChanged:(NSNotification *)notification {
	BOOL hasConnection = [[[notification userInfo] objectForKey:@"networkAvailable"] boolValue];
	
	if (hasConnection) {
		[self.statusItem setImage:serversOk];
		[self.statusItem setAlternateImage:serversOkAlternate];
	} else {
		[self.statusItem setImage:serversInactive];
		[self.statusItem setAlternateImage:serversInactiveAlternate];
	}
}

#pragma mark -
#pragma mark Observer
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context {
	if ([keyPath isEqualToString:@"active"]) {
		if (![[change valueForKey:NSKeyValueChangeNewKey] boolValue]) {
			[self removeServer:object];
		}
	}
	if ([keyPath isEqualToString:@"serverStatus"]) {
		ServerStatus status = [[change valueForKey:NSKeyValueChangeNewKey] intValue];
		[self statusOfServer:object didChangeTo:status];
	}
	if ([keyPath isEqualToString:@"serverName"]) {
		NSString *serverName = [change valueForKey:NSKeyValueChangeNewKey];
		NSInteger index = [self.activeServerList indexOfObject:object];
		NSMenuItem *item = [self.statusMenu itemAtIndex:index];
		[[[item view] viewWithTag:NAME_TEXTFIELD] setStringValue:serverName];
	}
}

#pragma mark -
#pragma mark Initialisation
- (id) init
{
	self = [super init];
	if (self != nil) {
		self.activeServerList = [NSMutableArray array];
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self
			   selector:@selector(networkConnectionChanged:)
				   name:NetworkChangeNotification
				 object:nil];
	}
	return self;
}


- (void) dealloc
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
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
@end