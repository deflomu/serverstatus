//
//  GrowlController.h
//  ServerStatus
//
//  Created by Florian Mutter on 09.06.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>
#import "Server.h"


@interface GrowlController : NSObject <GrowlApplicationBridgeDelegate> {

}

- (void)growlServerFailed:(Server *)server;
- (void)growlServerError:(Server *)server;

@end
