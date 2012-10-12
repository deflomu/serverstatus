//
//  GeneralPreferencesViewController.m
//  ServerStatus
//
//  Created by Florian Mutter on 12.10.12.
//  Copyright (c) 2012 skweez.net. All rights reserved.
//

#import "GeneralPreferencesViewController.h"

@interface GeneralPreferencesViewController ()

@end

@implementation GeneralPreferencesViewController

- (id)init
{
    return [super initWithNibName:@"GeneralPreferencesView" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

@end
