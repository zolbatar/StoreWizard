//
//  SWDocument.h
//  StoreWizard
//
//  Created by Daryl on 08/01/2011.
//  Copyright Daryl Dudey 2011 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SWCompany.h"
#import "SWProduct.h"
#import "SWCategory.h"
#import "SWCarriage.h"
#import "SWVariant.h"
#import "SWVariantSet.h"
#import "SWVariantType.h"
#import "SWVariantOption.h"

@class SWDocumentWindowController;

@interface SWDocument : NSPersistentDocument
{
	IBOutlet SWDocumentWindowController *windowController;
}

// Demo
- (void)createDemoData;

// Manage data model
- (SWCategory *)createCategory:(NSString *)name 
					 withImage:(NSImage *)image;
- (SWProduct *)createProduct:(NSString *)name 
				   withImage:(NSImage *)image
				  inCategory:(SWCategory *)category 
				withCarriage:(SWCarriage *)carriage
				   costprice:(NSDecimalNumber *)cost
				sellingprice:(NSDecimalNumber *)price;
- (SWCarriage *)createCarriage:(NSString *)carrier 
				withFixedPrice:(NSNumber *)fixedprice 
			 andPriceperWeight:(NSNumber *)priceperweight;

@property (readonly) SWDocumentWindowController *windowController;

@end
