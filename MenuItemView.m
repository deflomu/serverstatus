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
	[self.progressIndicator startAnimation:self];
    [self.statusImage setHidden:YES];
	self.progressIndicatorSpinning = YES;
}

- (void)stopSpinning {
	[self.progressIndicator stopAnimation:self];
    [self.statusImage setHidden:NO];
	self.progressIndicatorSpinning = NO;
}

@end
