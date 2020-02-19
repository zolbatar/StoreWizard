//
//  SWProductSourceListController.h
//  StoreWizard
//
//  Created by Daryl on 02/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

@class SWDocumentWindowController;

#import <Cocoa/Cocoa.h>
#import "SWDocument.h"
#import "PXSourceList.h"

@interface SWProductSourceListController : NSObject <PXSourceListDataSource, PXSourceListDelegate>
{
	// Document
	IBOutlet SWDocument *document;

	// Source list
	IBOutlet PXSourceList *sourceList;
	NSMutableArray *sourceListItems;
	
	// Other controllers
	IBOutlet SWDocumentWindowController *windowController;
}

- (void)updateSourceList:(NSString *)selected;

@end
