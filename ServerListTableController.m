//
//  ServerListTableController.m
//  ServerStatus
//
//  Created by Florian Mutter on 21.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "ServerListTableController.h"
#import "Server.h"
#import "ServerTabViewController.h"
#import "ServerListController.h"

@implementation ServerListTableController
@synthesize serverListTable, serverTabViewController, serverListController;

#pragma mark -
#pragma mark Init
- (void)awakeFromNib {
	/* Notify the system that we can handle ServerItemFileType objects if they are droped on the list */
	[self.serverListTable registerForDraggedTypes:[NSArray arrayWithObject:ServerItemFileType]];
}

#pragma mark -
#pragma mark Actions
- (IBAction)pushAddServer:(NSButton *)sender {
	/* Create a new server */
	Server *server = [Server server];
	
	/* Add the new server to the server list */
    [self.serverListController addServer:server];
	
	/* Reload the data in the server list table */
	[self.serverListTable reloadData];
	
	/* Select the new server in the list */
	NSInteger index = [self.serverListController.serverList count]-1;
	[self.serverListTable selectRowIndexes:[NSIndexSet indexSetWithIndex:index]
					  byExtendingSelection:NO];
	
	/* Start editing the new servers name */
	[self.serverListTable editColumn:[self.serverListTable columnWithIdentifier:@"serverName"]
								 row:index
						   withEvent:nil
							  select:YES];
}

- (IBAction)pushRemoveServer:(NSButton *)sender {
	/* Get the indexes of all selected rows */
	NSIndexSet *serverIndexes = [self.serverListTable selectedRowIndexes];
	/* Select nothing in the server list table */
	[self.serverListTable deselectAll:self];
	/* Remove all selected servers from the list */
	[self.serverListController removeServers:serverIndexes];
	/* Notify the server list table that the number of the rows changed */
	[self.serverListTable noteNumberOfRowsChanged];
}

#pragma mark -
#pragma mark NSTableView DataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [self.serverListController.serverList count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(NSInteger)rowIndex {
	/* Get the server from the internal list that correspondets to the selected entry in the table */
	Server *server = [self.serverListController.serverList objectAtIndex:rowIndex];
	/* Return the value for the column. The column identifier and the name of the value have to be the same */
	return [server valueForKey:[aTableColumn identifier]];
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
			  row:(NSInteger)rowIndex
/* The same as the function above but to set a value */
{
	Server *server = [self.serverListController.serverList objectAtIndex:rowIndex];
	[self.serverListController modifyServer:server setObjectValue:anObject forKey:[aTableColumn identifier]];
	[self.serverTabViewController updateView];
}

#pragma mark NSTableView Delegate
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	NSTableView *view = [notification object];
	NSInteger selectedRow = [view selectedRow];
	/* Tell the tab view (the detail view of a server) which server is selected in the list */
	if (selectedRow == -1) {
		self.serverTabViewController.server = NULL;
	} else {
		self.serverTabViewController.server = [self.serverListController.serverList objectAtIndex:selectedRow];
	}
}

#pragma mark -
#pragma mark Drag and Drop
- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes
	 toPasteboard:(NSPasteboard*)pboard
/* Handle the data at the beginning of the drag */
{
	/* The data that is stored for the drag are the indexes of the selected rows */
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pboard declareTypes:[NSArray arrayWithObject:ServerItemFileType] owner:self];
	[pboard setData:data forType:ServerItemFileType];
	return YES;
}
 
- (NSDragOperation)tableView:(NSTableView*)aTableView
	validateDrop:(id<NSDraggingInfo>)info
	proposedRow:(NSInteger)row
	proposedDropOperation:(NSTableViewDropOperation)op
/* Return the action of any permitted drag operation */
{
	/* If the user trys to drop an item between two other items, tell
	 the system that this is allowed and it's a move operation. This also
	 indicates which mouse pointer should be shown */
	return ((op == NSTableViewDropAbove) ? NSDragOperationMove : NSDragOperationNone);
}

- (BOOL)tableView:(NSTableView *)aTableView
	   acceptDrop:(id <NSDraggingInfo>)info
			  row:(NSInteger)row
	dropOperation:(NSTableViewDropOperation)operation
{	
	/* Extract the indexes of selected rows from the beginning of the drag from the pasteboard */
	NSPasteboard* pboard = [info draggingPasteboard];
	NSData* rowData = [pboard dataForType:ServerItemFileType];
	NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];

	NSInteger aboveInsertIndexCount = 0;
	NSInteger removeIndex;

	// Schleife, um die Daten korrekt zu verschieben
	NSInteger dragRow = [rowIndexes lastIndex];
	while (NSNotFound != dragRow) {
		// mit den Hilfsvariablen die Offsets der Indizes im Array verändern,
		// da sich die Daten im Array während des Kopierens zwangsläufig verschieben
		if (dragRow >= row) {
			// die Zeile wird oberhalb ihrer alten Position eingefügt
			removeIndex = dragRow + aboveInsertIndexCount;
			aboveInsertIndexCount++;
		} else {
			// die Zeile wird unterhalb ihrer alten Position eingefügt
			removeIndex = dragRow;
			row--;
		}

		// jetzt das Objekt im Array verschieben, unter Beachtung der Offsets
		Server *server = [self.serverListController.serverList objectAtIndex:removeIndex];
		[server retain];
		[self.serverListController removeServerAtIndex:removeIndex];
		[self.serverListController addServer:server atIndex:row];
		[server release];

		dragRow = [rowIndexes indexLessThanIndex:dragRow]; // nächsten Index holen
	}

	// Zuletzt noch die verschobenen Zeilen markieren
	NSRange range = NSMakeRange(row, [rowIndexes count]);
	NSIndexSet* newSelection = [NSIndexSet indexSetWithIndexesInRange:range];
	[self.serverListTable selectRowIndexes:newSelection byExtendingSelection:NO];

	[self.serverListTable reloadData];

	return YES;
}

@end
