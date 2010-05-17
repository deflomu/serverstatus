//
//  Server.h
//  ServerStatus
//
//  Created by Florian Mutter on 14.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Server : NSObject {
	NSString *serverName;
	NSString *serverHost;
}

@property (readwrite, copy) NSString *serverName;
@property (readwrite, copy) NSString *serverHost;

@end
