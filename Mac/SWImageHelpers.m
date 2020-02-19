//
//  SWImageHelpers.m
//  StoreWizard
//
//  Created by Daryl on 12/01/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWImageHelpers.h"

@implementation SWImageHelpers

+ (NSImage *)makeThumbnail:(NSImage *)image
{
	// Calculate resizing factor
	NSSize oldSize = [image size];
	float max = oldSize.width;
	if (oldSize.height > max)
		max = oldSize.height;
	float factor = 200.0 / max;
	NSSize newSize = oldSize;
	if (factor < 1.0)
	{
		newSize.width *= factor;
		newSize.height *= factor;
	}
	
	NSImage *smallImage = [[NSImage alloc] initWithSize:newSize];
	[smallImage lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	[image drawInRect:NSMakeRect(0.0, 0.0, newSize.width, newSize.height) 
			 fromRect:NSMakeRect(0.0, 0.0, oldSize.width, oldSize.height) 
			operation:NSCompositeCopy 
			 fraction:1.0];
	[smallImage unlockFocus];
	return smallImage;
}

@end
