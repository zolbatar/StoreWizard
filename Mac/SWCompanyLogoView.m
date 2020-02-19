//
//  SWCompanyLogoView.m
//  StoreWizard
//
//  Created by Daryl Dudey on 08/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWCompanyLogoView.h"
#import "SWCompany.h"

@implementation SWCompanyLogoView

- (void)setImage:(NSImage *)image
{
	SWCompany *company = [[objectController selectedObjects] lastObject];
	if (image)
	{
		company.logo = [image TIFFRepresentation];
	}
	else 
	{
		company.logo = nil;
	}
	
	[super setImage:image];
}

@end
