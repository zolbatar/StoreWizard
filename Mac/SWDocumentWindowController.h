//
//  SWDocumentWindowController.h
//  StoreWizard
//
//  Created by Daryl on 08/01/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SWDocument.h"
#import "SWProductSourceListController.h"
#import "SWToolbarController.h"

@interface SWDocumentWindowController : NSWindowController
{
	// Document
	IBOutlet SWDocument *document;

	// Views
	IBOutlet NSView *viewParent;
	IBOutlet NSView *viewProducts;
	IBOutlet NSView *viewStore;
	IBOutlet NSView *viewPublish;
	
	// State
	SWCategory *selectedCategory;
	NSString *specialCategory;
	
	// Views
	IBOutlet NSView *viewLeftPane;
	IBOutlet NSView *viewRightPane;
	IBOutlet NSView *viewBottomBarLeft;
	IBOutlet NSView *viewBottomBarRight;

	// Products
	IBOutlet NSTextField *textfieldProductTitle;
	IBOutlet NSView *viewProductViewer;
	IBOutlet NSView *viewProductBottomBarRight;
	IBOutlet NSView *viewProductBottomBarLeft;
	IBOutlet NSSearchField *searchField;

	// Variants
	IBOutlet NSTableView *tableVariants;
	
	// Inspector
	IBOutlet NSDrawer *drawerInspector; 

	// New Product
	IBOutlet NSWindow *windowNewProductSheet;
	IBOutlet NSTextField *textfieldNewProduct;
	IBOutlet NSButton *buttonAcceptNewProduct;

	// New Category
	IBOutlet NSWindow *windowNewCategorySheet;
	IBOutlet NSTextField *textfieldNewCategory;
	IBOutlet NSButton *buttonAcceptNewCategory;

	// Delete Category
	IBOutlet NSWindow *windowDeleteCategorySheet;
	IBOutlet NSTextField *textfieldDeleteCategory;

	// Array controllers
	IBOutlet NSArrayController *arrayProducts;
	IBOutlet NSArrayController *arrayCategory;
	
	// Other controllers
	IBOutlet SWProductSourceListController *sourceListController;
	IBOutlet SWToolbarController *toolbarController;
}

#pragma mark -
#pragma mark Core View Management
- (void)setMainView:(NSView *)view;
- (void)updateSourceList;
- (void)setView:(NSView *)view;
- (void)setView:(NSView *)view withBottomBarRight:(NSView *)bottomBarRight andBottomBarLeft:(NSView *)bottomBarLeft;
- (void)changeCategory:(SWCategory *)category;
- (void)viewChanged:(NSString *)view;

#pragma mark -
#pragma mark Events
//- (IBAction)categoryChanged:(id)sender;
- (IBAction)newProduct:(id)sender;
- (IBAction)acceptNewProduct:(id)sender;
- (IBAction)cancelNewProduct:(id)sender;
- (IBAction)newCategory:(id)sender;
- (IBAction)acceptNewCategory:(id)sender;
- (IBAction)cancelNewCategory:(id)sender;
- (IBAction)deleteCategory:(id)sender;
- (IBAction)acceptDeleteCategory:(id)sender;
- (IBAction)cancelDeleteCategory:(id)sender;

#pragma mark -
#pragma mark Toolbar
- (void)toolbarStore:(id)sender;
- (void)toolbarProducts:(id)sender;
- (void)toolbarShipping:(id)sender;
- (void)toolbarPayment:(id)sender;
- (void)toolbarTheme:(id)sender;
- (void)toolbarPublish:(id)sender;

@end
