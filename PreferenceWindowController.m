//
//  PreferenceWindowController.m
//  ServerStatus
//
//  Created by Florian Mutter on 24.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "PreferenceWindowController.h"


@implementation PreferenceWindowController
@synthesize serverListController, serverListTableController;

#pragma mark -
#pragma mark init
- (id)init {
	if (![super initWithWindowNibName:@"Preferences"]) {
		return nil;
	}
	return self;
}

- (void)awakeFromNib {
	self.serverListTableController.serverListController = self.serverListController;
}

- (void)windowDidLoad {
	NSLog(@"Nib loaded");
}

#pragma mark -
#pragma mark Actions
- (IBAction)pushClose:(NSButton *)sender {
	NSLog(@"Close window");
	[self.window performClose:self];
}

@end
