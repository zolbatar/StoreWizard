//
//  SWProductSourceListController.m
//  StoreWizard
//
//  Created by Daryl on 02/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWProductSourceListController.h"
#import "SWSourceListItem.h"

@implementation SWProductSourceListController

- (void)updateSourceList:(NSString *)selected
{
	@try 
	{
		SWSourceListItem *selectedItem = nil;
		
		// Core data
		NSManagedObjectContext *moc = [document managedObjectContext]; 
		NSError *error = nil;
		NSArray *array;
		NSFetchRequest *request;
		NSPredicate *pred;
		NSEntityDescription *entityProduct = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:moc];
		NSEntityDescription *entityCategory = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:moc];
		
		// List of source list items
		sourceListItems = [[NSMutableArray alloc] init];
		
		// Products list
		SWSourceListItem *productsItem = [SWSourceListItem itemWithTitle:@"PRODUCTS" identifier:@"PRODUCTS"];
		[sourceListItems addObject:productsItem];
		
		// Fetch list of categories
		request = [[NSFetchRequest alloc] init];
		[request setEntity:entityCategory];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
		[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		array = [moc executeFetchRequest:request error:&error];

		// Category array
		NSEnumerator *categories = [array objectEnumerator];
		SWCategory *category = nil;
		NSMutableArray *categoriesArray = [[NSMutableArray alloc] init];
		
		// All products
		SWSourceListItem *allproductsItem = [SWSourceListItem itemWithTitle:@"(All Products)" identifier:@"$AllProducts"];
		if (selected != nil)
		{
			if ([selected compare:allproductsItem.identifier] == NSOrderedSame)
			{
				selectedItem = allproductsItem;
			}
		}
		request = [[NSFetchRequest alloc] init];
		[request setEntity:entityProduct];
		array = [moc executeFetchRequest:request error:&error];
		[allproductsItem setBadgeValue:[array count]];
		[categoriesArray addObject:allproductsItem];
		
		// Products with no category
		SWSourceListItem *categorylessproductsItem = [SWSourceListItem itemWithTitle:@"(No Category)" identifier:@"$NoCategory"];
		if (selected != nil)
		{
			if ([selected compare:categorylessproductsItem.identifier] == NSOrderedSame)
			{
				selectedItem = categorylessproductsItem;
			}
		}
		request = [[NSFetchRequest alloc] init];
		[request setEntity:entityProduct];
		pred = [NSPredicate predicateWithFormat:@"Category == nil"];
		[request setPredicate:pred];
		array = [moc executeFetchRequest:request error:&error];
		[categorylessproductsItem setBadgeValue:[array count]];
		[categoriesArray addObject:categorylessproductsItem];
		
		// Populate list of categories
		while (category = [categories nextObject]) 
		{
			SWSourceListItem *categoryItem = [SWSourceListItem itemWithTitle:[category name] identifier:[@"ProductByCategory:" stringByAppendingString:[category name]]];
			if (selected != nil)
			{
				if ([selected compare:categoryItem.identifier] == NSOrderedSame)
				{
					selectedItem = categoryItem;
				}
			}
			[categoryItem setIcon:[[NSImage alloc] initWithData:[category imagethumb]]];
			request = [[NSFetchRequest alloc] init];
			[request setEntity:entityProduct];
			pred = [NSPredicate predicateWithFormat:@"Category == %@", category];
			[request setPredicate:pred];
			error = nil;
			array = [moc executeFetchRequest:request error:&error];
			[categoryItem setBadgeValue:[array count]];
			[categoriesArray addObject:categoryItem];
		}
		[productsItem setChildren:categoriesArray];
		
		[sourceList reloadData];
		
		// Set selected
		if (selectedItem != nil)
		{
			int row = [sourceList rowForItem:selectedItem];
			[sourceList selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
		}
	}
	@catch ( NSException *e )
	{
		NSLog(@"Error:SWProductSourceListController.updateSourceList");
	}
}

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems count];
	}
	else {
		return [[item children] count];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems objectAtIndex:index];
	}
	else {
		return [[item children] objectAtIndex:index];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item
{
	return [item title];
}


- (void)sourceList:(PXSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item
{
	[item setTitle:object];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
	return [item hasChildren];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item
{
	return [item hasBadge];
}


- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item
{
	return [item badgeValue];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item
{
	return [item hasIcon];
}


- (NSImage*)sourceList:(PXSourceList*)aSourceList iconForItem:(id)item
{
	return [item icon];
}

- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item
{
	if ([theEvent type] == NSRightMouseDown || ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) {
		NSMenu * m = [[NSMenu alloc] init];
		if (item != nil) {
			[m addItemWithTitle:[item title] action:nil keyEquivalent:@""];
		} else {
			[m addItemWithTitle:@"clicked outside" action:nil keyEquivalent:@""];
		}
		return [m autorelease];
	}
	return nil;
}

#pragma mark -
#pragma mark Source List Delegate Methods
- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group
{
	//	if([[group identifier] isEqualToString:@"PRODUCTS"])
	//		return YES;
	
	//	return NO;
	return YES;
}

- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
	
	if([selectedIndexes count]>1)
	{
	}
	else if([selectedIndexes count]==1)
	{
		NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
		[windowController viewChanged:identifier];
	}
}


- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
	NSIndexSet *rows = [[notification userInfo] objectForKey:@"rows"];
	
	NSLog(@"Delete key pressed on rows %@", rows);
	
	//Do something here
}

@end
