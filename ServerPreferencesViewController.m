//
//  ServerPreferencesViewController.m
//  ServerStatus
//
//  Created by Florian Mutter on 12.10.12.
//  Copyright (c) 2012 skweez.net. All rights reserved.
//

#import "ServerPreferencesViewController.h"

@interface ServerPreferencesViewController ()

@end

@implementation ServerPreferencesViewController

- (id)init
{
    return [super initWithNibName:@"ServerPreferencesView" bundle:nil];
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

@end
