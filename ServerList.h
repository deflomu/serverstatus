//
//  ServerList.h
//  ServerStatus
//
//  Created by Florian Mutter on 16.05.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServerList : NSObject {
	NSMutableArray *serverList;
}

- (void)setServerList:(NSMutableArray *)a;

@end
