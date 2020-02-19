//
//  SWInspectorWindowController.m
//  StoreWizard
//
//  Created by Daryl Dudey on 12/01/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWInspectorWindowController.h"
#import "SWDocument.h"

@implementation SWInspectorWindowController

-(void)awakeFromNib
{
	// Autosave
	[self setWindowFrameAutosaveName:@"SWInspectorWindowController"];
	
	[[self window] setMovableByWindowBackground:YES];
	[viewInspector addInspectorPane:viewInspectorInfo title:NSLocalizedString(@"Details", @"")];
	[viewInspector addInspectorPane:viewInspectorVariants title:NSLocalizedString(@"Options", @"")];
	[viewInspector addInspectorPane:viewInspectorPricing title:NSLocalizedString(@"Pricing", @"")];
    [viewInspector addInspectorPane:viewInspectorCarriage title:NSLocalizedString(@"Carriage", @"")];
	[viewInspector addInspectorPane:viewInspectorInventory title:NSLocalizedString(@"Inventory", @"")];
	[viewInspector addInspectorPane:viewInspectorImage title:NSLocalizedString(@"	Image", @"")];
}

@end
