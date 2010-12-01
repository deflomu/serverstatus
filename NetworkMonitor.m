//
//  NetworkMonitor.m
//  ServerStatus
//
//  Created by Florian Mutter on 30.11.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "NetworkMonitor.h"
#import "SynthesizeSingleton.h"
#import <SystemConfiguration/SystemConfiguration.h>


@implementation NetworkMonitor
SYNTHESIZE_SINGLETON_FOR_CLASS(NetworkMonitor)

#pragma mark -
#pragma mark Network Status
- (void)sendNotificationNetworkChanged {
	/* Create the data that is send with the notification */
	NSDictionary *d = [NSDictionary
					   dictionaryWithObject:[NSNumber numberWithBool:networkAvailable]
					   forKey:@"networkAvailable"];
	/* Post the notification */
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:NetworkChangeNotification
					  object:self
					userInfo:d];
}

- (void)networkStatusChanged:(SCNetworkReachabilityRef)network withFlags:(SCNetworkConnectionFlags)flags {	
	/**
	 * If the network is capable of reaching skweez.net and this is not an
	 * inactive dialup connection, we are on
	 **/
	if (flags & kSCNetworkFlagsReachable && !(flags & kSCNetworkFlagsConnectionRequired)) {
		if (!networkAvailable) {
			DLog(@"A network connection is available");
			networkAvailable = YES;
			[self sendNotificationNetworkChanged];
		}
	} else {
		if (networkAvailable) {
			DLog(@"No network connection is available");
			networkAvailable = NO;
			[self sendNotificationNetworkChanged];
		}
	}
}

static void networkStatusCallback(SCNetworkReachabilityRef	network,
								 SCNetworkConnectionFlags	flags,
								 void *						info
								 )
{
	NetworkMonitor *_self = (NetworkMonitor *)info;
	
	[_self networkStatusChanged:network withFlags:flags];
}

/* We want to be notified if the network status of the machine is changing */
- (void)monitorNetwork {
	SCNetworkReachabilityRef network = SCNetworkReachabilityCreateWithName(NULL, "skweez.net");
	
	SCNetworkReachabilityContext context = {0, self, NULL, NULL, NULL};
	
	SCNetworkReachabilitySetCallback(network, networkStatusCallback, &context);
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL);
	SCNetworkReachabilitySetDispatchQueue(network, queue);
}

@end
