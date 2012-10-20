//
//  ServerPreferencesViewController.m
//  ServerStatus
//
//  Created by Florian Mutter on 12.10.12.
//  Copyright (c) 2012 skweez.net. All rights reserved.
//

#import "ServerPreferencesViewController.h"
#import "ServerListTableController.h"

@interface ServerPreferencesViewController ()

@end

@implementation ServerPreferencesViewController

@synthesize serverListTableController, serverListController;

- (id)init
{
    self = [super initWithNibName:@"ServerPreferencesView" bundle:nil];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"ServerPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"ServerStatus.icns"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Server", @"Toolbar item name for the Server preference pane");
}
- (void)viewWillAppear {
    serverListTableController.serverListController = serverListController;
}

@end
