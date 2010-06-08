//
//  MenuItemView.m
//  ServerStatus
//
//  Created by Florian Mutter on 01.06.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import "MenuItemView.h"


@implementation MenuItemView
@synthesize progressIndicatorSpinning;

- (void)viewDidMoveToWindow {
	if (self.progressIndicatorSpinning) {
		[self startSpinning];
	} else {
		[self stopSpinning];
	}
	[super viewDidMoveToWindow];
}

- (void)startSpinning {
	[[[self subviews] objectAtIndex:2] startAnimation:self];
	self.progressIndicatorSpinning = YES;
}

- (void)stopSpinning {
	[[[self subviews] objectAtIndex:2] stopAnimation:self];
	self.progressIndicatorSpinning = NO;
}

@end
