//
//  SWInspectorWindowController.h
//  StoreWizard
//
//  Created by Daryl Dudey on 12/01/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SFBInspectorView.h"

@interface SWInspectorWindowController : NSWindowController 
{
	IBOutlet SFBInspectorView *viewInspector;
	IBOutlet NSView *viewInspectorInfo;
	IBOutlet NSView *viewInspectorVariants;
	IBOutlet NSView *viewInspectorPricing;
	IBOutlet NSView *viewInspectorCarriage;
	IBOutlet NSView *viewInspectorInventory;
	IBOutlet NSView *viewInspectorImage;
}

@end
