//
//  NetworkMonitor.h
//  ServerStatus
//
//  Created by Florian Mutter on 30.11.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NetworkMonitor : NSObject {
	BOOL networkAvailable;
}

+ (NetworkMonitor *) sharedNetworkMonitor;

- (void)monitorNetwork;

@end
