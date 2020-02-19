//
//  SWGridItem.m
//  StoreWizard
//
//  Created by Daryl on 10/01/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWGridItem.h"

@implementation SWGridItem

@synthesize selected;

- (id)initWithFrame:(NSRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect 
{
    if (selected) 
	{
		[[NSColor colorWithDeviceRed:0.6 green:0.6 blue:0.6 alpha:0.5] setFill];
		NSRect bounds = [self bounds];
		bounds.size.width -= 10.0;
		bounds.size.height -= 10.0;
		bounds.origin.x += 5.0;
		bounds.origin.y += 5.0;
		NSBezierPath *path = [NSBezierPath bezierPath];
		[path setLineWidth:0];
		[path appendBezierPathWithRoundedRect:bounds xRadius:5 yRadius:5];
		[path fill];
    }
}
@end
