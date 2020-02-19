//
//  SWDocumentWindowController.m
//  StoreWizard
//
//  Created by Daryl on 08/01/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWDocumentWindowController.h"

@implementation SWDocumentWindowController

- (id)init 
{
    self = [super initWithWindowNibName:@"SWDocument"];
	if (self) 
	{
		selectedCategory = nil;
		specialCategory = @"$AllProducts";
		[self setShouldCloseDocument:YES];
		[self setShouldCascadeWindows:YES];
	}
	return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
	[tableVariants reloadData];
}

- (void)awakeFromNib 
{
	// Notify on changed selection
	[arrayProducts addObserver:self forKeyPath:@"selection" options:0 context:nil];

	// Autosave
	[self setWindowFrameAutosaveName:@"SWDocumentWindowController"];

	// Toolbvar
	[toolbarController setupToolbar];
	
	// Initial sort
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];  
	[arrayProducts setSortDescriptors:[NSArray arrayWithObject:sort]]; 

	if ([self document])
	{
		// Update source list
		[self updateSourceList];
	}
	
	// Set first view
	[self setMainView:viewStore];
	
	// Drawer
	[drawerInspector close];
}

#pragma mark -
#pragma mark Core View Management

- (void)setMainView:(NSView *)view
{
	NSRect frame = [[self window] contentRectForFrameRect:[[self window] frame]];
	frame.origin.x = 0;
	frame.origin.y = 0;
	[view setFrame:frame];
	[viewParent setSubviews:[NSArray arrayWithObject:view]];
}

- (void)updateSourceList
{
	[self setView:viewProductViewer withBottomBarRight:viewProductBottomBarRight andBottomBarLeft:viewProductBottomBarLeft];
	if (selectedCategory == nil)
	{
		[sourceListController updateSourceList:specialCategory];
	}
	else 
	{
		[sourceListController updateSourceList:[NSString stringWithFormat:@"ProductByCategory:%@", selectedCategory.name]];
	}
}

- (void)setView:(NSView *)view
{
	[self setView:view withBottomBarRight:nil andBottomBarLeft:nil];
}

- (void)setView:(NSView *)view withBottomBarRight:(NSView *)bottomBarRight andBottomBarLeft:(NSView *)bottomBarLeft
{
	if (view != nil)
	{
		NSRect frame = [viewRightPane frame];
		frame.origin.x = 0;
		[view setFrame:frame];
		[viewRightPane setSubviews:[NSArray arrayWithObject:view]];
	}
	if (bottomBarRight != nil)
	{
		NSRect frame = [viewBottomBarRight frame];
		frame.origin.x = 0;
		[bottomBarRight setFrame:frame];
		[viewBottomBarRight setSubviews:[NSArray arrayWithObject:bottomBarRight]];
	}
	if (bottomBarLeft != nil)
	{
		[viewBottomBarLeft setSubviews:[NSArray arrayWithObject:bottomBarLeft]];
	}
}

- (void)changeCategory:(SWCategory *)category
{
	selectedCategory = category;
	NSPredicate *pred;
	if (category != nil)
	{
		[textfieldProductTitle setStringValue:[NSString stringWithFormat:@"Products for Category '%@'", category.name]];
		pred = [NSPredicate predicateWithFormat:@"Category.name == %@", category.name];
	}
	else 
	{
		[textfieldProductTitle setStringValue:@"All Products"];
		pred = [NSPredicate predicateWithFormat:nil];
	}
	[arrayProducts setFetchPredicate:pred];
	[arrayProducts rearrangeObjects];
}

- (void)viewChanged:(NSString *)view
{
	// Category selection?
	NSPredicate *pred;
	if ([view hasPrefix:@"ProductByCategory:"])
	{
		NSString *category = [view substringFromIndex:18];
		pred = [NSPredicate predicateWithFormat:@"Category.name == %@", category];
		
		NSManagedObjectContext *moc = [[self document] managedObjectContext];
		NSFetchRequest *request = [NSFetchRequest new];
		[request setEntity:[NSEntityDescription entityForName:@"Category" inManagedObjectContext:moc]];
		NSPredicate *predName = [NSPredicate predicateWithFormat:@"name == %@", category];
		[request setPredicate:predName];
		NSError *error = nil;
		NSArray *array = [moc executeFetchRequest:request error:&error];
		selectedCategory = [array lastObject];
		[textfieldProductTitle setStringValue:[NSString stringWithFormat:@"Products for Category '%@'", category]];
	}
	else 
	{
		if ([view isEqualToString:@"$AllProducts"])
		{
			[textfieldProductTitle setStringValue:@"All Products"];
			pred = [NSPredicate predicateWithFormat:nil];
		}
		else if ([view isEqualToString:@"$NoCategory"])
		{
			[textfieldProductTitle setStringValue:@"Products with no Category"];
			pred = [NSPredicate predicateWithFormat:@"Category == nil"];
		}
		selectedCategory = nil;
		specialCategory = view;
		[searchField setStringValue:@""];
		[[[searchField cell] cancelButtonCell] performClick:self];
	}
	[arrayProducts setFetchPredicate:pred];
	[arrayProducts rearrangeObjects];
}

- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification
{
	NSRect leftRect = [viewLeftPane frame];
	NSRect rightRect = [viewRightPane frame];

	NSRect bottomFrameRight = [viewBottomBarRight frame];
	bottomFrameRight.origin.x = rightRect.origin.x;
	[viewBottomBarRight setFrame:bottomFrameRight];

	NSRect bottomFrameLeft = [viewLeftPane frame];
	bottomFrameRight.size.width = leftRect.size.width;
	[viewBottomBarLeft setFrame:bottomFrameLeft];
}
-(void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize: (NSSize)oldSize
{
	CGFloat dividerThickness = [sender dividerThickness];
	NSRect leftRect = [[[sender subviews] objectAtIndex:0] frame];
	NSRect rightRect = [[[sender subviews] objectAtIndex:1] frame];
	NSRect newFrame = [sender frame];
	
	leftRect.size.height = newFrame.size.height;
	leftRect.origin = NSMakePoint(0, 0);
	rightRect.size.width = newFrame.size.width - leftRect.size.width - dividerThickness;
	rightRect.size.height = newFrame.size.height;
	rightRect.origin.x = leftRect.size.width + dividerThickness;
	
	[[[sender subviews] objectAtIndex:0] setFrame:leftRect];
	[[[sender subviews] objectAtIndex:1] setFrame:rightRect];
}

#pragma mark -
#pragma mark Delegate Methods

- (void)controlTextDidChange:(NSNotification *)nd
{
	NSTextField *field = [nd object];
	if (field == textfieldNewProduct) 
	{
		if ([[field stringValue] length] > 0)
		{
			[buttonAcceptNewProduct setEnabled:TRUE];
		}
		else 
		{
			[buttonAcceptNewProduct setEnabled:FALSE];
		}

	}
	else if (field == textfieldNewCategory) 
	{
		if ([[field stringValue] length] > 0)
		{
			[buttonAcceptNewCategory setEnabled:TRUE];
		}
		else 
		{
			[buttonAcceptNewCategory setEnabled:FALSE];
		}
		
	}
}

#pragma mark -
#pragma mark Events

/*- (IBAction)categoryChanged:(id)sender
{
	[sourceListController updateSourceList];
}*/

- (IBAction)newProduct:(id)sender
{
	[textfieldNewProduct setStringValue:@""];
	[buttonAcceptNewProduct setEnabled:FALSE];
	[NSApp beginSheet:windowNewProductSheet modalForWindow:[self window] modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (IBAction)acceptNewProduct:(id)sender
{
	[NSApp endSheet:windowNewProductSheet returnCode:NSOKButton];
	[windowNewProductSheet orderOut:nil];

	// Create product
	NSManagedObjectContext *moc = [[self document] managedObjectContext]; 
	SWProduct *product = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:moc];
	product.name = [textfieldNewProduct stringValue];
	if (selectedCategory)
	{
		product.Category = selectedCategory;
	}
	[moc processPendingChanges];
	[arrayProducts setSelectedObjects:[NSArray arrayWithObject:product]];
	[arrayProducts rearrangeObjects];
}

- (IBAction)cancelNewProduct:(id)sender
{
	[NSApp endSheet:windowNewProductSheet returnCode:NSCancelButton];
	[windowNewProductSheet orderOut:nil];
}

- (IBAction)newCategory:(id)sender
{
	[textfieldNewCategory setStringValue:@""];
	[buttonAcceptNewCategory setEnabled:FALSE];
	[NSApp beginSheet:windowNewCategorySheet modalForWindow:[self window] modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (IBAction)acceptNewCategory:(id)sender
{
	[NSApp endSheet:windowNewCategorySheet returnCode:NSOKButton];
	[windowNewCategorySheet orderOut:nil];
	
	// Create category
	NSManagedObjectContext *moc = [[self document] managedObjectContext]; 
	SWCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:moc];
	category.name = [textfieldNewCategory stringValue];
	[moc processPendingChanges];
	[self changeCategory:category];
	[self updateSourceList];
}

- (IBAction)cancelNewCategory:(id)sender
{
	[NSApp endSheet:windowNewCategorySheet returnCode:NSCancelButton];
	[windowNewCategorySheet orderOut:nil];
}

- (IBAction)deleteCategory:(id)sender
{
	if (selectedCategory != nil)
	{
		if ([selectedCategory.Product count] > 0)
		{
			[textfieldDeleteCategory setStringValue:[NSString stringWithFormat:@"Category has %d products", [selectedCategory.Product count]]];
			[NSApp beginSheet:windowDeleteCategorySheet modalForWindow:[self window] modalDelegate:self didEndSelector:NULL contextInfo:nil];
		}
		else 
		{
			NSManagedObjectContext *moc = [[self document] managedObjectContext]; 
			[moc deleteObject:selectedCategory];
			[self changeCategory:nil];
			[self updateSourceList];
		}
	}
}

- (IBAction)acceptDeleteCategory:(id)sender
{
	NSManagedObjectContext *moc = [[self document] managedObjectContext]; 
	[moc deleteObject:selectedCategory];
	[self changeCategory:nil];
	[self updateSourceList];
	
	[NSApp endSheet:windowDeleteCategorySheet returnCode:NSCancelButton];
	[windowDeleteCategorySheet orderOut:nil];
}

- (IBAction)cancelDeleteCategory:(id)sender
{
	[NSApp endSheet:windowDeleteCategorySheet returnCode:NSCancelButton];
	[windowDeleteCategorySheet orderOut:nil];
}

#pragma mark -
#pragma mark Toolbar

- (void)toolbarStore:(id)sender
{
	[self setMainView:viewStore];
	[drawerInspector close];
}

- (void)toolbarProducts:(id)sender
{
	[self setMainView:viewProducts];
	[drawerInspector openOnEdge:NSMaxXEdge];
}

- (void)toolbarShipping:(id)sender
{	
}

- (void)toolbarPayment:(id)sender
{
}

- (void)toolbarTheme:(id)sender
{
}

- (void)toolbarPublish:(id)sender
{
	[self setMainView:viewPublish];
	[drawerInspector close];
}


@end
