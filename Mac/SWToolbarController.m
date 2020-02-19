//
//  SWToolbarController.m
//  StoreWizard
//
//  Created by Daryl on 02/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWToolbarController.h"

@implementation SWToolbarController

static NSString *StoreToolbarItemIdentifier = @"StoreToolbarItem";
static NSString *ProductsToolbarItemIdentifier = @"ProductsToolbarItem";
static NSString *ShippingToolbarItemIdentifier = @"ShippingToolbarItem";
static NSString *PaymentToolbarItemIdentifier = @"PaymentToolbarItem";
static NSString *ThemeToolbarItemIdentifier = @"ThemeToolbarItem";
static NSString *PublishToolbarItemIdentifier = @"PublishToolbarItem";

- (void)setupToolbar
{
	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"SWToolbar"];
	[toolbar setAllowsUserCustomization:NO];
	[toolbar setAutosavesConfiguration:YES];
	[toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
	[toolbar setSizeMode:NSToolbarSizeModeRegular];
	[toolbar setDelegate:self];
	[toolbar setSelectedItemIdentifier:StoreToolbarItemIdentifier];
	[window setToolbar:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	NSToolbarItem *item = nil;
	if ([itemIdentifier isEqualTo:StoreToolbarItemIdentifier]) 
	{
        item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        [item setLabel:@"Store"];
        [item setPaletteLabel:[item label]];
        [item setToolTip:@"Setup your store & company details"];
        [item setImage:[NSImage imageNamed:@"store.png"]];
        [item setTarget:windowController];
        [item setAction:@selector(toolbarStore:)];
	}
	else if ([itemIdentifier isEqualTo:ProductsToolbarItemIdentifier]) 
	{
        item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        [item setLabel:@"Products"];
        [item setPaletteLabel:[item label]];
        [item setToolTip:@"Maintain your products"];
        [item setImage:[NSImage imageNamed:@"products.png"]];
        [item setTarget:windowController];
        [item setAction:@selector(toolbarProducts:)];
	}
	else if ([itemIdentifier isEqualTo:ShippingToolbarItemIdentifier]) 
	{
        item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        [item setLabel:@"Shipping"];
        [item setPaletteLabel:[item label]];
        [item setToolTip:@"Setup shipping"];
        [item setImage:[NSImage imageNamed:@"shipping.png"]];
        [item setTarget:windowController];
        [item setAction:@selector(toolbarShipping:)];
	}
	else if ([itemIdentifier isEqualTo:PaymentToolbarItemIdentifier]) 
	{
        item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        [item setLabel:@"Payment"];
        [item setPaletteLabel:[item label]];
        [item setToolTip:@"Setup payment options"];
        [item setImage:[NSImage imageNamed:@"payment.png"]];
        [item setTarget:windowController];
        [item setAction:@selector(toolbarPayment:)];
	}
	else if ([itemIdentifier isEqualTo:ThemeToolbarItemIdentifier]) 
	{
        item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        [item setLabel:@"Theme"];
        [item setPaletteLabel:[item label]];
        [item setToolTip:@"Choose a theme for your store"];
        [item setImage:[NSImage imageNamed:@"theme.png"]];
        [item setTarget:windowController];
        [item setAction:@selector(toolbarTheme:)];
	}
	else if ([itemIdentifier isEqualTo:PublishToolbarItemIdentifier]) 
	{
        item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        [item setLabel:@"Publish"];
        [item setPaletteLabel:[item label]];
        [item setToolTip:@"Publish your changes"];
        [item setImage:[NSImage imageNamed:@"publish.png"]];
        [item setTarget:windowController];
        [item setAction:@selector(toolbarPublish:)];
	}
	
    return [item autorelease];
}
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar 
{
    return [NSArray arrayWithObjects:
			StoreToolbarItemIdentifier,
			ProductsToolbarItemIdentifier,
			ShippingToolbarItemIdentifier,
			PaymentToolbarItemIdentifier,
			ThemeToolbarItemIdentifier,
			PublishToolbarItemIdentifier,
			nil];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *) toolbar 
{
    return [NSArray arrayWithObjects:
			NSToolbarFlexibleSpaceItemIdentifier, 
			NSToolbarSpaceItemIdentifier,
			NSToolbarSeparatorItemIdentifier, 
			StoreToolbarItemIdentifier,
			ProductsToolbarItemIdentifier,
			ShippingToolbarItemIdentifier,
			PaymentToolbarItemIdentifier,
			ThemeToolbarItemIdentifier,
			PublishToolbarItemIdentifier,
			nil];
}
		 
- (NSArray *)toolbarSelectableItemIdentifiers: (NSToolbar *)toolbar;
{
	// Optional delegate method: Returns the identifiers of the subset of
	// toolbar items that are selectable. In our case, all of them
	return [NSArray arrayWithObjects:
			StoreToolbarItemIdentifier,
			ProductsToolbarItemIdentifier,
			ShippingToolbarItemIdentifier,
			PaymentToolbarItemIdentifier,
			ThemeToolbarItemIdentifier,
			PublishToolbarItemIdentifier,
			nil];
}

@end
