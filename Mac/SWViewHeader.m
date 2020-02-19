//
//  SWViewHeader.m
//  StoreWizard
//
//  Created by Daryl on 09/01/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWViewHeader.h"

@implementation SWViewHeader

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	NSGradient *aGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.5 alpha:1.0]
														  endingColor:[NSColor colorWithDeviceRed:0.32 green:0.32 blue:0.32 alpha:1.0]];
	[aGradient drawInRect:[self bounds] angle:270];
}

@end
