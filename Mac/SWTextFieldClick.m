//
//  SWTextFieldClick.m
//  StoreWizard
//
//  Created by Daryl Dudey on 08/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWTextFieldClick.h"

@implementation SWTextFieldClick

- (void)mouseDown:(NSEvent *)theEvent
{
	[self sendAction:@selector(textClicked:) to:[self delegate]];
}


@end
