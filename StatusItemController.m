//
//  StatusItemController.m
//  ServerStatus
//
//  Created by Florian Mutter on 20.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "StatusItemController.h"
#import "Server.h"
#import "ServerMenuItemController.h"
#import "MenuItemView.h"
#import "GrowlController.h"


@implementation StatusItemController
@synthesize statusItem, activeServerList, statusMenu;



#pragma mark Private
- (NSString *)getStatusString:(ServerStatus) serverStatus {
	NSString *status;
	switch (serverStatus) {
		case SERVER_OK:
			status = NSLocalizedString(@"Server is reachable",@"Server is reachable");
			break;
		case SERVER_FAIL:
			status = NSLocalizedString(@"Server is unreachable",@"Server is unreachable");
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

- (NSImage *)getStatusImage:(ServerStatus) serverStatus {
    NSImage *statusImage;
    switch (serverStatus) {
		case SERVER_FAIL:
			statusImage = serversFail;
			break;
		case SERVER_UNKNOWN:
			statusImage = serversWarning;
			break;
		case SERVER_ERROR:
			statusImage = serversWarning;
			break;
		default:
			statusImage = nil;
			break;
	}
	return statusImage;
}

- (void)serverDidFail:(Server *)server {
	[self.statusItem setImage:serversFail];
	[self.statusItem setAlternateImage:serversFailAlternate];
	
	if (server) {
		[growlController growlServerFailed:server];
	}
}

- (void)serverDidError {
	if (serversDownCounter == 0) {
		[self.statusItem setImage:serversWarning];
		[self.statusItem setAlternateImage:serversWarningAlternate];
	}
}

- (void)serverDidOk {
	if (hasConnection && [activeServerList count] != 0) {
		if (serversDownCounter == 0 && serversErrorCounter == 0) {
			[self.statusItem setImage:serversOk];
			[self.statusItem setAlternateImage:serversOkAlternate];
		} else if (serversDownCounter == 0) {
			[self serverDidError];
		} else {
			[self serverDidFail:nil];
		}
	} else {
		[self.statusItem setImage:serversInactive];
		[self.statusItem setAlternateImage:serversInactiveAlternate];
	}
}

- (void)statusOfServerDidChange:(Server *)server {
	NSInteger index = [self.activeServerList indexOfObject:server];
	NSMenuItem *item = [self.statusMenu itemAtIndex:index];
	ServerStatus status = server.serverStatus;
	ServerStatus previousStatus = server.previousStatus;
	[[[item view] viewWithTag:STATUS_TEXTFIELD] setStringValue:[self getStatusString:status]];
    
    // Show icon for status
    [[[item view] viewWithTag:STATUS_ICON] setImage:[self getStatusImage:status]];
    
	if (status != previousStatus) {
		switch (status) {
			case SERVER_FAIL:
				serversDownCounter++;
				[self serverDidFail:server];
				break;
			case SERVER_ERROR:
				serversErrorCounter++;
				[self serverDidError];
			default:
				break;
		}
		switch (previousStatus) {
			case SERVER_FAIL:
				serversDownCounter--;
				[self serverDidOk];
				break;
			case SERVER_ERROR:
				serversErrorCounter--;
				[self serverDidOk];
				break;
			default:
				break;
		}
	}

}

- (void)serverIsPinging:(Server *)server {
	NSInteger index = [self.activeServerList indexOfObject:server];
	NSMenuItem *item = [self.statusMenu itemAtIndex:index];
	if (server.pinging) {
		[(MenuItemView*)[item view] startSpinning];
	} else {
		[(MenuItemView*)[item view] stopSpinning];
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
	
	NSMenuItem *menuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]]
				initWithTitle:@"" action:NULL keyEquivalent:@""] autorelease];
	[menuItem setView:serverItemMenuView];
	[menuItem setTarget:self];
	
	return menuItem;
}

#pragma mark -
#pragma mark Public
- (void)addServer:(Server *)server atIndex:(NSInteger)index {
	[server addObserver:self
			forKeyPath:@"serverStatus"
				options:0
				context:NULL];
	
	[server addObserver:self
			 forKeyPath:@"pinging"
				options:0
				context:NULL];
	
	[server addObserver:self
			 forKeyPath:@"serverName"
				options:NSKeyValueObservingOptionNew
				context:NULL];
	
	[self.activeServerList insertObject:server atIndex:index];
	NSMenuItem *item = [self createMenuItem:server];
	[self.statusMenu insertItem:item atIndex:index];
	[self serverDidOk];

	NSMenuItem *separatorMenuItem = [self.statusMenu itemWithTag:SEPARATOR_MENU_ITEM_TAG];
	separatorMenuItem.hidden = (self.statusMenu.numberOfItems == 3);
}

- (void)removeServer:(Server *)server atIndex:(NSInteger)index {
	[self.statusMenu removeItemAtIndex:index];
	[server removeObserver:self forKeyPath:@"serverStatus"];
	[server removeObserver:self forKeyPath:@"pinging"];
	[server removeObserver:self forKeyPath:@"serverName"];	
	switch (server.serverStatus) {
		case SERVER_FAIL:
			serversDownCounter--;
			break;
		case SERVER_ERROR:
			serversErrorCounter--;
			break;
		default:
			break;
	}
	[self.activeServerList removeObject:server];
	[self serverDidOk];

	NSMenuItem *separatorMenuItem = [self.statusMenu itemWithTag:SEPARATOR_MENU_ITEM_TAG];
	separatorMenuItem.hidden = (self.statusMenu.numberOfItems == 3);
}

#pragma mark Status
- (void)networkConnectionChanged:(NSNotification *)notification {
	hasConnection = [[[notification userInfo] objectForKey:@"networkAvailable"] boolValue];

	[self serverDidOk];
}

#pragma mark -
#pragma mark Observer
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context {
	if ([keyPath isEqualToString:@"serverStatus"]) {
		[self statusOfServerDidChange:object];
	}
	if ([keyPath isEqualToString:@"pinging"]) {
		[self serverIsPinging:object];
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
        NSMenu *menu = [[NSMenu alloc] init];
        
        NSMenuItem *separatorItem = [NSMenuItem separatorItem];
        separatorItem.tag = SEPARATOR_MENU_ITEM_TAG;
        separatorItem.hidden = YES;
        [menu addItem:separatorItem];
        
        NSMenuItem *prefsItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Preferences…", nil)
                                                           action:@selector(openPreferences:)
                                                    keyEquivalent:@""];
        prefsItem.target = [NSApp delegate];
        [menu addItem:prefsItem];
        [prefsItem release];
        
        NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Quit", nil)
                                                          action:@selector(terminate:)
                                                   keyEquivalent:@""];
        quitItem.target = NSApp;
        [menu addItem:quitItem];
        [quitItem release];
        
        self.statusMenu = menu;
        [menu release];
        
		self.activeServerList = [NSMutableArray array];
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self
			   selector:@selector(networkConnectionChanged:)
				   name:NetworkChangeNotification
				 object:nil];
		
		growlController = [[[GrowlController alloc] init] autorelease];
	}
	return self;
}


- (void) dealloc
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	self.activeServerList = nil;
	self.statusItem = nil;
	[super dealloc];
}

- (void)awakeFromNib {
	NSStatusBar *bar = [NSStatusBar systemStatusBar];
	self.statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
	
	[self loadStatusItemImages];
    
	[self.statusItem setMenu:statusMenu];
	[self.statusItem setImage:serversInactive];
	[self.statusItem setAlternateImage:serversInactiveAlternate];
	[self.statusItem setHighlightMode:YES];
}
@end
