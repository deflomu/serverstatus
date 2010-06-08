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
	[self.serverListTable registerForDraggedTypes:[NSArray arrayWithObject:ServerItemFileType]];
}

#pragma mark -
#pragma mark Actions
- (IBAction)pushAddServer:(NSButton *)sender {
	Server *server = [Server server];
    [self.serverListController addServer:server];
	
	[self.serverListTable reloadData];
	
	NSInteger index = [self.serverListController.serverList count]-1;
	[self.serverListTable selectRowIndexes:[NSIndexSet indexSetWithIndex:index]
					  byExtendingSelection:NO];
	
	[self.serverListTable editColumn:[self.serverListTable columnWithIdentifier:@"serverName"]
								 row:index
						   withEvent:nil
							  select:YES];
}

- (IBAction)pushRemoveServer:(NSButton *)sender {
	NSIndexSet *serverIndexes = [self.serverListTable selectedRowIndexes];
	[self.serverListTable deselectAll:self];
	
	[self.serverListController removeServers:serverIndexes];
	
	[self.serverListTable noteNumberOfRowsChanged];
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
	[self.serverTabViewController updateView];
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

#pragma mark -
#pragma mark Drag and Drop
- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes
	 toPasteboard:(NSPasteboard*)pboard
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pboard declareTypes:[NSArray arrayWithObject:ServerItemFileType] owner:self];
	[pboard setData:data forType:ServerItemFileType];
	return YES;
}
 
- (NSDragOperation)tableView:(NSTableView*)aTableView
	validateDrop:(id<NSDraggingInfo>)info
	proposedRow:(NSInteger)row
	proposedDropOperation:(NSTableViewDropOperation)op
{
	return ((op == NSTableViewDropAbove) ? NSDragOperationMove : NSDragOperationNone);
}

- (BOOL)tableView:(NSTableView *)aTableView
	   acceptDrop:(id <NSDraggingInfo>)info
			  row:(NSInteger)row
	dropOperation:(NSTableViewDropOperation)operation
{	
	// Zunächst die Daten aus dem Pasteboard holen, dass sich im Dictionary befindet
	NSPasteboard* pboard = [info draggingPasteboard];
	NSData* rowData = [pboard dataForType:ServerItemFileType];
	NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];

	// Hilfsvariablen für das anschliessende Verschieben der Daten
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
	NSRange range = NSMakeRange(row, [rowIndexes count]); // Range ist eine Struktur, daher kein *
	NSIndexSet* newSelection = [NSIndexSet indexSetWithIndexesInRange:range];
	[self.serverListTable selectRowIndexes:newSelection byExtendingSelection:NO];

	[self.serverListTable reloadData]; // den TableView die Daten neu laden lassen

	return YES;
}

@end
