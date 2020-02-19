//
//  SWPublishController.h
//  StoreWizard
//
//  Created by Daryl Dudey on 16/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SWDocument.h"

@interface SWPublishController : NSObject 
{
	// Document
	IBOutlet SWDocument *document;
}

- (IBAction)checkDependencies:(id)sender;;
- (IBAction)publish:(id)sender;;

@end
