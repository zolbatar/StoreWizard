//
//  SWLoadableImageView.m
//  StoreWizard
//
//  Created by Daryl Dudey on 08/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWLoadableImageView.h"

@implementation SWLoadableImageView

- (void)setImage:(NSImage *)image
{
	[textField setHidden:(image != 0)];
	[super setImage:image];
}

- (void)mouseDown:(NSEvent *)theEvent
{
	if ([theEvent clickCount] == 2)
	{
		if (![self image])
		{
			NSOpenPanel *panel = [NSOpenPanel openPanel];
			[panel beginWithCompletionHandler:^void (NSInteger result)
			 {
				 if (result == NSFileHandlingPanelCancelButton)
				 {
					 return;
				 }
				 
				 // Load image
				 for (NSURL *Url in [panel URLs])
				 {
					 NSImage *image = [[NSImage alloc] initWithContentsOfURL:Url];
					 if (image)
					 {
						 [self setImage:image];
					 }
				 }
				 [panel release];
			 }];
		}	
	}
}

- (IBAction)textClicked:(id)sender
{
	[self mouseDown:nil];
}

@end
