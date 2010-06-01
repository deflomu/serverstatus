//
//  ServerMenuItemController.h
//  ServerStatus
//
//  Created by Florian Mutter on 29.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MenuItemView.h"


@interface ServerMenuItemController : NSObject {
	IBOutlet MenuItemView *serverMenuItemView;
}
@property (retain) IBOutlet MenuItemView *serverMenuItemView;

+ (ServerMenuItemController *)serverMenuItemController;

@end
