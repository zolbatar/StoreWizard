//
//  SWVariantTableViewController.m
//  StoreWizard
//
//  Created by Daryl Dudey on 09/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWVariantTableViewController.h"
#import "SWProduct.h"
#import "SWVariant.h"

@implementation SWVariantTableViewController

- (IBAction)manageVariants:(id)sender
{
	[windowManageVariants makeKeyAndOrderFront:self];
}

- (IBAction)closeManageVariants:(id)sender
{
	[windowManageVariants orderOut:self];
}

#pragma mark
#pragma Data Model Helpers

- (NSArray *)getAllVariantTypes
{
	NSManagedObjectContext *moc = [document managedObjectContext]; 
	NSFetchRequest *request = [NSFetchRequest new];
	[request setEntity:[NSEntityDescription entityForName:@"VariantType" inManagedObjectContext:moc]];
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	return [[moc executeFetchRequest:request error:nil] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}

- (NSArray *)getVariantOptionsForType:(NSString *)typeName
{
	NSManagedObjectContext *moc = [document managedObjectContext]; 
	NSFetchRequest *request = [NSFetchRequest new];
	[request setEntity:[NSEntityDescription entityForName:@"VariantOption" inManagedObjectContext:moc]];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"VariantType.name == %@", typeName];
	[request setPredicate:pred];
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	return [[moc executeFetchRequest:request error:nil] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}

#pragma mark -
#pragma mark Add Variant Type

- (IBAction)addVariant:(id)sender
{
	// Create variant
	NSManagedObjectContext *moc = [document managedObjectContext]; 
	variantSet = [NSEntityDescription insertNewObjectForEntityForName:@"VariantSet" inManagedObjectContext:moc];
	SWProduct *product = [[arrayProducts selectedObjects] lastObject];
	variantSet.Product = product;
	product.VariantSet = [product.VariantSet setByAddingObject:variantSet];
	[moc processPendingChanges];
	[variantAddTable reloadData];

	// Populate type popup
	[popupType removeAllItems];
	for (SWVariantType *type in [self getAllVariantTypes])
	{
		[popupType addItemWithTitle:type.name];
	}
	
	// Show
	[buttonAcceptAddVariant setEnabled:NO];
	[self variantTypeChange:nil];
	[NSApp beginSheet:windowAddVariant modalForWindow:windowMain modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (IBAction)deleteVariant:(id)sender
{
	if ([tableVariants selectedRow] != -1)
	{
		SWProduct *product = [[arrayProducts selectedObjects] lastObject];
		SWVariantSet *set = [[product.VariantSet allObjects] objectAtIndex:[tableVariants selectedRow]];
		
		// Delete
		NSManagedObjectContext *moc = [document managedObjectContext]; 
		[moc deleteObject:set];
		[moc processPendingChanges];
		
		[tableVariants reloadData];
	}
}

- (IBAction)variantTypeChange:(id)sender
{
	[popupOption removeAllItems];
	for (SWVariantOption *type in [self getVariantOptionsForType:[[popupType selectedItem] title]])
	{
		[popupOption addItemWithTitle:type.name];
	}
}

- (IBAction)addVariantOptionToSet:(id)sender
{
	NSManagedObjectContext *moc = [document managedObjectContext]; 
	SWVariant *variant = [NSEntityDescription insertNewObjectForEntityForName:@"Variant" inManagedObjectContext:moc];
	variant.VariantSet = variantSet;
	for (SWVariantOption *type in [self getVariantOptionsForType:[[popupType selectedItem] title]])
	{
		if ([type.name compare:[[popupOption selectedItem] title]] == NSOrderedSame)
		{
			variant.VariantOption = type;
			break;
		}
	}
	[moc processPendingChanges];
	variantSet.Variant = [variantSet.Variant setByAddingObject:variant];
	[variantAddTable reloadData];
	[self checkAddVariantButton];
}

- (IBAction)acceptAddVariantOption:(id)sender
{
	variantSet.stock = [NSNumber numberWithInt:[textfieldStock intValue]];
	NSManagedObjectContext *moc = [document managedObjectContext]; 
	[moc processPendingChanges];
	[NSApp endSheet:windowAddVariant returnCode:NSOKButton];
	[windowAddVariant orderOut:nil];
	[tableVariants reloadData];
}

- (IBAction)cancelAddVariantOption:(id)sender
{
	// Delete variant
	SWProduct *product = [[arrayProducts selectedObjects] lastObject];
	NSMutableSet *productSets = [NSMutableSet setWithSet:product.VariantSet];
	[productSets removeObject:variantSet];
	product.VariantSet = [NSSet setWithSet:productSets];
	NSManagedObjectContext *moc = [document managedObjectContext]; 
	[moc deleteObject:variantSet];
	variantSet = nil;

	[NSApp endSheet:windowAddVariant returnCode:NSCancelButton];
	[windowAddVariant orderOut:nil];
}

- (void)checkAddVariantButton
{
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNotANumberSymbol:@"*"];
	NSNumber *stk = [formatter numberFromString:[textfieldStock stringValue]];
	if (stk != nil)
	{
		if ([variantSet.Variant count] > 0)
		{
			[buttonAcceptAddVariant setEnabled:TRUE];
		}
		else 
		{
			[buttonAcceptAddVariant setEnabled:FALSE];
		}
		
	}
	else 
	{
		[buttonAcceptAddVariant setEnabled:FALSE];
	}
}

#pragma mark -
#pragma mark New Variant Type

- (IBAction)newVariantType:(id)sender
{
	[buttonAcceptNewVariantType setEnabled:FALSE];
	[textfieldNewVariantType setStringValue:@""];
	[NSApp beginSheet:windowNewVariantType modalForWindow:windowManageVariants modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (IBAction)acceptNewVariantType:(id)sender
{
	[NSApp endSheet:windowNewVariantType returnCode:NSOKButton];
	[windowNewVariantType orderOut:nil];

	// Create variant type
	NSManagedObjectContext *moc = [document managedObjectContext]; 
	SWVariantType *type = [NSEntityDescription insertNewObjectForEntityForName:@"VariantType" inManagedObjectContext:moc];
	type.name = [textfieldNewVariantType stringValue];
	[moc processPendingChanges];
	
	// Refresh
	[variantTypeTable reloadData];
	
	// Find new row and select to refresh the options
	int i = 0;
	for (SWVariantType *listType in [self getAllVariantTypes])
	{
		if (type == listType)
		{
			[variantTypeTable selectRowIndexes:[NSIndexSet indexSetWithIndex:i] byExtendingSelection:NO];
			break;
		}
		i++;
	}
}

- (IBAction)cancelNewVariantType:(id)sender
{
	[NSApp endSheet:windowNewVariantType returnCode:NSCancelButton];
	[windowNewVariantType orderOut:nil];
}

#pragma mark -
#pragma mark Delete Variant Type

- (IBAction)deleteVariantType:(id)sender
{
	if ([self getSelectedVariantType] != nil)
	{
		NSManagedObjectContext *moc = [document managedObjectContext]; 
		[moc deleteObject:[self getSelectedVariantType]];
		[moc processPendingChanges];
		[variantTypeTable reloadData];
	}
}

#pragma mark -
#pragma mark New Variant Option

- (IBAction)newVariantOption:(id)sender
{
	[buttonAcceptNewVariantOption setEnabled:FALSE];
	[textfieldNewVariantOption setStringValue:@""];
	[NSApp beginSheet:windowNewVariantOption modalForWindow:windowManageVariants modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (IBAction)acceptNewVariantOption:(id)sender
{
	[NSApp endSheet:windowNewVariantOption returnCode:NSOKButton];
	[windowNewVariantOption orderOut:nil];
	
	// Create variant option
	NSManagedObjectContext *moc = [document managedObjectContext]; 
	SWVariantOption *option = [NSEntityDescription insertNewObjectForEntityForName:@"VariantOption" inManagedObjectContext:moc];
	option.VariantType = [self getSelectedVariantType];
	option.name = [textfieldNewVariantOption stringValue];
	option.index = [NSNumber numberWithInt:[[self getSelectedVariantType].VariantOption count]];
	[moc processPendingChanges];
	
	// Refresh
	[variantOptionTable reloadData];
}

- (IBAction)cancelNewVariantOption:(id)sender
{
	[NSApp endSheet:windowNewVariantOption returnCode:NSCancelButton];
	[windowNewVariantOption orderOut:nil];
}

#pragma mark -
#pragma mark Delete Variant Option

- (IBAction)deleteVariantOption:(id)sender
{
	SWVariantOption *sel = [self getSelectedVariantOption];
	if (sel != nil)
	{
		NSManagedObjectContext *moc = [document managedObjectContext]; 
		NSMutableSet *set = [NSMutableSet setWithSet:[self getSelectedVariantType].VariantOption];
		[set removeObject:sel];
		[self getSelectedVariantType].VariantOption = [NSSet setWithSet:set];
		[moc deleteObject:sel];
		[moc processPendingChanges];
		[variantOptionTable reloadData];
	}
}

#pragma mark -
#pragma mark Delegate Methods

- (void)controlTextDidChange:(NSNotification *)nd
{
	NSTextField *field = [nd object];
	if (field == textfieldNewVariantType) 
	{
		if ([[field stringValue] length] > 0)
		{
			for (SWVariantType *type in [self getAllVariantTypes])
			{
				if ([type.name compare:[field stringValue]] == NSOrderedSame)
				{
					[buttonAcceptNewVariantType setEnabled:FALSE];
					return;
				}
			}
			[buttonAcceptNewVariantType setEnabled:TRUE];
		}
		else 
		{
			[buttonAcceptNewVariantType setEnabled:FALSE];
		}
	}
	else if (field == textfieldNewVariantOption) 
	{
		if ([[field stringValue] length] > 0)
		{
			for (SWVariantOption *option in [self getSelectedVariantType].VariantOption)
			{
				if ([option.name compare:[field stringValue]] == NSOrderedSame)
				{
					[buttonAcceptNewVariantOption setEnabled:FALSE];
					return;
				}
			}
			[buttonAcceptNewVariantOption setEnabled:TRUE];
		}
		else 
		{
			[buttonAcceptNewVariantOption setEnabled:FALSE];
		}
	}
	else if (field == textfieldStock) 
	{
		[self checkAddVariantButton];
	}
}

#pragma mark -
#pragma mark Table Management

- (SWVariantType *)getVariantType:(int)rowIndex
{
	return [[self getAllVariantTypes] objectAtIndex:rowIndex];
}

- (SWVariantOption *)getVariantOption:(int)rowIndex withOptions:(NSSet *)variantOptions
{
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	return [[variantOptions sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] objectAtIndex:rowIndex];
}

- (SWVariantType *)getSelectedVariantType
{
	if ([variantTypeTable selectedRow] != -1)
	{
		return [self getVariantType:[variantTypeTable selectedRow]];
	}
	else 
	{
		return nil;
	}
}

- (SWVariantOption *)getSelectedVariantOption
{
	if ([variantOptionTable selectedRow] != -1)
	{
		return [self getVariantOption:[variantOptionTable selectedRow] withOptions:[self getSelectedVariantType].VariantOption];
	}
	else 
	{
		return nil;
	}
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
	@try 
	{
		if (aTableView == variantTypeTable)
		{
			return [[self getAllVariantTypes] count];
		}
		else if (aTableView == variantOptionTable)
		{
			if ([self getSelectedVariantType] != nil)
			{
				return [[self getSelectedVariantType].VariantOption count];
			}
			else 
			{
				[buttonVariantOptionUp setEnabled:NO];
				[buttonVariantOptionDown setEnabled:NO];
			}
		}
		else if (aTableView == variantAddTable)
		{
			return [variantSet.Variant count];
		}
		else if (aTableView == tableVariants)
		{
			SWProduct *product = [[arrayProducts selectedObjects] lastObject];
			return [product.VariantSet count];
		}
	}
	@catch (NSException * e) 
	{
		NSLog(@"Error:SWVariantTableViewController.numberOfRowsInTableView");
	}
	
	return 0;	
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
	@try
	{
		if (aTableView == variantTypeTable)
		{
			SWVariantType *variant = [self getVariantType:rowIndex];
			return variant.name;
		}
		else if (aTableView == variantOptionTable)
		{
			SWVariantOption *variant = [self getVariantOption:rowIndex withOptions:[self getSelectedVariantType].VariantOption];
			if ([@"index" compare:[aTableColumn identifier]] == NSOrderedSame)
			{
				return variant.index;
			}
			else if ([@"option" compare:[aTableColumn identifier]] == NSOrderedSame)
			{
				return variant.name;
			}
		}
		else if (aTableView == variantAddTable)
		{
			NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"VariantOption.VariantType.name" ascending:YES];
			NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"VariantOption.name" ascending:YES];
			SWVariant *variant = [[[variantSet Variant] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort1, sort2, nil]] objectAtIndex:rowIndex];
			if ([@"type" compare:[aTableColumn identifier]] == NSOrderedSame)
			{
				return variant.VariantOption.VariantType.name;
			}
			else if ([@"option" compare:[aTableColumn identifier]] == NSOrderedSame)
			{
				return variant.VariantOption.name;
			}
		}
		else if (aTableView == tableVariants)
		{
			if ([[arrayProducts selectedObjects] count] == 1)
			{
				SWProduct *product = [[arrayProducts selectedObjects] lastObject];
				SWVariantSet *set = [[product.VariantSet allObjects] objectAtIndex:rowIndex];
				if ([@"list" compare:[aTableColumn identifier]] == NSOrderedSame)
				{
					NSMutableString *list = [[NSMutableString alloc] init];
					for (SWVariant *variant in set.Variant)
					{
						[list appendFormat:@"%@:%@ ", variant.VariantOption.VariantType.name, variant.VariantOption.name];
					}
					return list;
				}
				else if ([@"stock" compare:[aTableColumn identifier]] == NSOrderedSame)
				{
					return set.stock;
				}
			}
		}
	}
	@catch (NSException * e) 
	{
		NSLog(@"Error:SWVariantTableViewController.tableView");
	}

	return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	@try
	{
		NSTableView *table = [aNotification object];
		if (table == variantTypeTable)
		{
			[variantOptionTable reloadData];
		}
		else if (table == variantOptionTable)
		{
			if ([[self getSelectedVariantType].VariantOption count] > 0)
			{
				if ([variantOptionTable selectedRow] == -1)
				{
					[buttonVariantOptionDown setEnabled:NO];
					[buttonVariantOptionUp setEnabled:NO];
					return;
				}
				SWVariantOption *variant = [self getVariantOption:[variantOptionTable selectedRow] withOptions:[self getSelectedVariantType].VariantOption];
				
				// Top row?
				if ([variant.index intValue] != 1)
				{
					[buttonVariantOptionDown setEnabled:YES];
				}
				else
				{
					[buttonVariantOptionDown setEnabled:NO];
				}
				
				// Bottom row?
				if ([variant.index intValue] != [[self getSelectedVariantType].VariantOption count])
				{
					[buttonVariantOptionUp setEnabled:YES];
				}
				else
				{
					[buttonVariantOptionUp setEnabled:NO];
				}
			}
			else 
			{
				[buttonVariantOptionUp setEnabled:NO];
				[buttonVariantOptionDown setEnabled:NO];
			}
		}
	}
	@catch (NSException * e) 
	{
		NSLog(@"Error:SWVariantTableViewController.tableViewSelectionDidChange");
	}
}

#pragma mark -
#pragma mark Reordering

- (IBAction)variantoptionUp:(id)sender
{
	// Swap indexes over
	SWVariantOption *variant1 = [self getVariantOption:[variantOptionTable selectedRow] withOptions:[self getSelectedVariantType].VariantOption];
	SWVariantOption *variant2 = [self getVariantOption:([variantOptionTable selectedRow] - 1) withOptions:[self getSelectedVariantType].VariantOption];
	NSNumber *var1index = variant1.index;
	variant1.index = variant2.index;
	variant2.index = var1index;
	[variantOptionTable reloadData];
	[variantOptionTable selectRowIndexes:[NSIndexSet indexSetWithIndex:([variantOptionTable selectedRow] - 1)] byExtendingSelection:NO];
}

- (IBAction)variantoptionDown:(id)sender
{
	// Swap indexes over
	SWVariantOption *variant1 = [self getVariantOption:[variantOptionTable selectedRow] withOptions:[self getSelectedVariantType].VariantOption];
	SWVariantOption *variant2 = [self getVariantOption:([variantOptionTable selectedRow] + 1) withOptions:[self getSelectedVariantType].VariantOption];
	NSNumber *var1index = variant1.index;
	variant1.index = variant2.index;
	variant2.index = var1index;
	[variantOptionTable reloadData];
	[variantOptionTable selectRowIndexes:[NSIndexSet indexSetWithIndex:([variantOptionTable selectedRow] + 1)] byExtendingSelection:NO];
}

@end
