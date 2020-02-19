//
//  SWToolbarController.h
//  StoreWizard
//
//  Created by Daryl on 02/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

@class SWDocumentWindowController;

#import <Cocoa/Cocoa.h>

@interface SWToolbarController : NSObject <NSToolbarDelegate>
{
	IBOutlet NSWindow *window;
	IBOutlet SWDocumentWindowController *windowController;
}

- (void)setupToolbar;

@end
