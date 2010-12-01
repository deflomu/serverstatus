//
//  AutostartManager.h
//  ServerStatus
//
//  Created by Florian Mutter on 01.12.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AutostartManager : NSObject {

}

+ (AutostartManager *)sharedAutostartManager;

- (NSInteger)isStartingAtLogin;
- (void)startAtLogin:(BOOL)enabled;

@end
