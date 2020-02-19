//
//  SWVariantTableViewController.h
//  StoreWizard
//
//  Created by Daryl Dudey on 09/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SWDocument.h"

@interface SWVariantTableViewController : NSObject 
{
	IBOutlet SWDocument *document;
	IBOutlet NSTableView *variantTypeTable;
	IBOutlet NSTableView *variantOptionTable;
	IBOutlet NSArrayController *arrayProducts;

	// Variants inspector
	IBOutlet NSTableView *tableVariants;

	// Windows
	IBOutlet NSWindow *windowMain;
	IBOutlet NSWindow *windowManageVariants;
	
	// Add Variant
	IBOutlet NSWindow *windowAddVariant;
	IBOutlet NSPopUpButton *popupType;
	IBOutlet NSPopUpButton *popupOption;
	IBOutlet NSTextField *textfieldStock;
	IBOutlet NSButton *buttonAcceptAddVariant;
	SWVariantSet *variantSet;
	IBOutlet NSTableView *variantAddTable;

	// New Variant Type
	IBOutlet NSWindow *windowNewVariantType;
	IBOutlet NSTextField *textfieldNewVariantType;
	IBOutlet NSButton *buttonAcceptNewVariantType;

	// New Variant Option
	IBOutlet NSWindow *windowNewVariantOption;
	IBOutlet NSTextField *textfieldNewVariantOption;
	IBOutlet NSButton *buttonAcceptNewVariantOption;
	
	// Ordering change
	IBOutlet NSButton *buttonVariantOptionUp;
	IBOutlet NSButton *buttonVariantOptionDown;
}

- (SWVariantType *)getSelectedVariantType;
- (SWVariantOption *)getSelectedVariantOption;

- (IBAction)manageVariants:(id)sender;
- (IBAction)closeManageVariants:(id)sender;
- (IBAction)deleteVariantType:(id)sender;
- (IBAction)deleteVariantOption:(id)sender;

// New Variant Type
- (IBAction)newVariantType:(id)sender;
- (IBAction)acceptNewVariantType:(id)sender;
- (IBAction)cancelNewVariantType:(id)sender;

// New Variant Option
- (IBAction)newVariantOption:(id)sender;
- (IBAction)acceptNewVariantOption:(id)sender;
- (IBAction)cancelNewVariantOption:(id)sender;

// Ordering change
- (IBAction)variantoptionUp:(id)sender;
- (IBAction)variantoptionDown:(id)sender;

// Add variant
- (IBAction)addVariant:(id)sender;
- (IBAction)deleteVariant:(id)sender;
- (IBAction)variantTypeChange:(id)sender;
- (IBAction)acceptAddVariantOption:(id)sender;
- (IBAction)cancelAddVariantOption:(id)sender;
- (IBAction)addVariantOptionToSet:(id)sender;
- (void)checkAddVariantButton;

@end
