//
//  MenuItemView.h
//  ServerStatus
//
//  Created by Florian Mutter on 01.06.10.
//  Copyright 2010 skweez.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MenuItemView : NSView {
	BOOL progressIndicatorSpinning;
}
@property (assign) BOOL progressIndicatorSpinning;

@property (assign) IBOutlet NSProgressIndicator *progressIndicator;
@property (assign) IBOutlet NSImageView *statusImage;

- (void)startSpinning;
- (void)stopSpinning;

@end
