//
//  SWProductImageView.m
//  StoreWizard
//
//  Created by Daryl on 12/01/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWProductImageView.h"
#import "SWImageHelpers.h"
#import "SWProduct.h"

@implementation SWProductImageView

- (void)setImage:(NSImage *)image
{
	if ([[arrayController selectedObjects] count] != 1)
	{
		[super setImage:image];
		return;
	}

	SWProduct *product = [[arrayController selectedObjects] lastObject];
	if (image)
	{
		NSImage *smallimage = [SWImageHelpers makeThumbnail:image];
		product.imagethumb = [smallimage TIFFRepresentation];
		product.image = [image TIFFRepresentation];
		
		// Is there just one product in this category? If so, set the category picture
		if ([[arrayController arrangedObjects] count] == 1)
		{
			product.Category.imagethumb = [smallimage TIFFRepresentation];
			product.Category.image = [image TIFFRepresentation];
			[windowController updateSourceList];
		}
	}
	else 
	{
		product.image = nil;
		product.imagethumb = nil;
	}

	[super setImage:image];
}

@end
