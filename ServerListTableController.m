//
//  ServerListTableController.m
//  ServerStatus
//
//  Created by Florian Mutter on 21.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "ServerListTableController.h"


@implementation ServerListTableController
@synthesize serverListTable, serverTabViewController, serverListController;

#pragma mark -
#pragma mark Init
- (void)awakeFromNib {
	
}

#pragma mark -
#pragma mark Actions
- (IBAction)pushAddServer:(NSButton *)sender {
	Server *server = [Server server];
    [self.serverListController addServer:server];
	[self.serverListTable reloadData];
}

- (IBAction)pushRemoveServer:(NSButton *)sender {
	NSIndexSet *serverIndexes = [self.serverListTable selectedRowIndexes];
	
	[self.serverListController removeServers:serverIndexes];
	
	[self.serverListTable reloadData];
}

#pragma mark -
#pragma mark NSTableView DataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [self.serverListController.serverList count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(NSInteger)rowIndex {
	Server *server = [self.serverListController.serverList objectAtIndex:rowIndex];
	return [server valueForKey:[aTableColumn identifier]];
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
			  row:(NSInteger)rowIndex {
	Server *server = [self.serverListController.serverList objectAtIndex:rowIndex];
	[self.serverListController modifyServer:server setObjectValue:anObject forKey:[aTableColumn identifier]];
}

#pragma mark NSTableView Delegate
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	NSTableView *view = [notification object];
	NSInteger selectedRow = [view selectedRow];
	if (selectedRow == -1) {
		self.serverTabViewController.server = NULL;
	} else {
		self.serverTabViewController.server = [self.serverListController.serverList objectAtIndex:selectedRow];
	}
}

@end
