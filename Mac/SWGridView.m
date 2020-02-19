//
//  SWGridItem.m
//  StoreWizard
//
//  Created by Daryl on 09/01/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWGridView.h"


@implementation SWGridView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect 
{
	[[NSColor colorWithDeviceRed:0.4 green:0.4 blue:0.4 alpha:1.0] setFill];
    NSRectFill(dirtyRect);
}

@end
