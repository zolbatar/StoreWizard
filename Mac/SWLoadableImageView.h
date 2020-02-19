//
//  SWLoadableImageView.h
//  StoreWizard
//
//  Created by Daryl Dudey on 08/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SWLoadableImageView : NSImageView 
{
	IBOutlet NSTextField *textField;
}

- (IBAction)textClicked:(id)sender;

@end
