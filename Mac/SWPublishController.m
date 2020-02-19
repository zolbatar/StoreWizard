//
//  SWPublishController.m
//  StoreWizard
//
//  Created by Daryl Dudey on 16/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWPublishController.h"
#import "SWSpree.h"

@implementation SWPublishController

- (IBAction)checkDependencies:(id)sender;
{
	[SWSpree checkDependencies];
}

- (IBAction)publish:(id)sender;
{
	[SWSpree createSpreeSite:document];
}

@end
