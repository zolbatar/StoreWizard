//
//  SWProductImageView.h
//  StoreWizard
//
//  Created by Daryl on 12/01/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SWLoadableImageView.h"
#import "SWDocumentWindowController.h"

@interface SWProductImageView : SWLoadableImageView 
{
	IBOutlet NSArrayController *arrayController;
	IBOutlet SWDocumentWindowController *windowController;
}

@end
