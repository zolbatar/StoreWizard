//
//  SWDocument.m
//  StoreWizard
//
//  Created by Daryl on 08/01/2011.
//  Copyright Daryl Dudey 2011 . All rights reserved.
//

#import "SWDocument.h"
#import "SWImageHelpers.h"

@implementation SWDocument

@synthesize windowController;

- (id)init 
{
    self = [super init];
    if (self != nil) 
	{
    }
    return self;
}

- (id)initWithType:(NSString *)type error:(NSError **)error 
{
    self = [super initWithType:type error:error];
    if (self != nil) 
	{
		[self createDemoData];
	}
    return self;
}

- (id)initWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
	self = [super initWithContentsOfURL:absoluteURL ofType:typeName error:outError];
	if (self != nil)
	{
	}
	return self;
}

- (NSError *)willPresentError:(NSError *)inError 
{
	// The error is a Core Data validation error if its domain is
    // NSCocoaErrorDomain and it is between the minimum and maximum
    // for Core Data validation error codes.
    if (!([[inError domain] isEqualToString:NSCocoaErrorDomain])) 
	{
        return inError;
    }
	
	// If single error, return it
    NSInteger errorCode = [inError code];
    if ((errorCode < NSValidationErrorMinimum) || (errorCode > NSValidationErrorMaximum)) 
	{
        return inError;
    }
	
    // If there are multiple validation errors, inError is an
    // NSValidationMultipleErrorsError. If it's not, return it
    if (errorCode != NSValidationMultipleErrorsError) 
	{
        return inError;
    }
	
    // For an NSValidationMultipleErrorsError, the original errors
    // are in an array in the userInfo dictionary for key NSDetailedErrorsKey
    // For this example, only present error messages for up to 3 validation errors at a time.
    NSArray *detailedErrors = [[inError userInfo] objectForKey:NSDetailedErrorsKey];
    unsigned numErrors = [detailedErrors count];
    NSMutableString *errorString = [NSMutableString stringWithFormat:@"%u validation errors have occurred", numErrors];
	
    if (numErrors > 3) 
	{
        [errorString appendFormat:@".\nThe first 3 are:\n"];
    }
    else 
	{
        [errorString appendFormat:@":\n"];
    }
    NSUInteger i, displayErrors = numErrors > 3 ? 3 : numErrors;
    for (i = 0; i < displayErrors; i++) 
	{
        [errorString appendFormat:@"%@\n",
		 [[detailedErrors objectAtIndex:i] localizedDescription]];
    }
	
    // Create a new error with the new userInfo
    NSMutableDictionary *newUserInfo = [NSMutableDictionary dictionaryWithDictionary:[inError userInfo]];
    [newUserInfo setObject:errorString forKey:NSLocalizedDescriptionKey];
    NSError *newError = [NSError errorWithDomain:[inError domain] code:[inError code] userInfo:newUserInfo];
	
    return newError;
}

- (void)createDemoData
{
	// Company
	NSManagedObjectContext *moc = [self managedObjectContext]; 
	SWCompany *company = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:moc];
	company.name = @"Demo Company";
	company.currency = @"GBP (£)";
	[moc processPendingChanges];
/*	if (image != nil)
	{
		product.image = [image TIFFRepresentation];
		product.imagethumb = [[SWImageHelpers makeThumbnail:image] TIFFRepresentation];
	}*/

	// Categories
	SWCategory *clothing = [self createCategory:@"Clothing" withImage:[NSImage imageNamed:@"Clothing.jpg"]];
	SWCategory *decorative = [self createCategory:@"Decorative" withImage:[NSImage imageNamed:@"Decorative.jpg"]];
	SWCategory *garden = [self createCategory:@"Garden" withImage:[NSImage imageNamed:@"Garden.jpg"]];
	SWCategory *kitchen = [self createCategory:@"Kitchen" withImage:[NSImage imageNamed:@"Kitchen.jpg"]];
	
	// Carriage
	SWCarriage *carriage = [self createCarriage:@"National Mail" withFixedPrice:[NSNumber numberWithDouble:2.50] andPriceperWeight:[NSNumber numberWithDouble:0.75]];

	// Products
	[self createProduct:@"Bag" withImage:[NSImage imageNamed:@"CProduct1.jpg"] inCategory:clothing withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Shoes" withImage:[NSImage imageNamed:@"CProduct2.jpg"] inCategory:clothing withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Belt" withImage:[NSImage imageNamed:@"CProduct3.jpg"] inCategory:clothing withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Sunglasses" withImage:[NSImage imageNamed:@"CProduct4.jpg"] inCategory:clothing withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Tie" withImage:[NSImage imageNamed:@"CProduct5.jpg"] inCategory:clothing withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];

	[self createProduct:@"Bottles" withImage:[NSImage imageNamed:@"DProduct1.jpg"] inCategory:decorative withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Boxes" withImage:[NSImage imageNamed:@"DProduct2.jpg"] inCategory:decorative withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Vases" withImage:[NSImage imageNamed:@"DProduct3.jpg"] inCategory:decorative withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Frame" withImage:[NSImage imageNamed:@"DProduct4.jpg"] inCategory:decorative withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Stones" withImage:[NSImage imageNamed:@"DProduct5.jpg"] inCategory:decorative withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	
	[self createProduct:@"Sign" withImage:[NSImage imageNamed:@"GProduct1.jpg"] inCategory:garden withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Barbecue" withImage:[NSImage imageNamed:@"GProduct2.jpg"] inCategory:garden withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Twine" withImage:[NSImage imageNamed:@"GProduct3.jpg"] inCategory:garden withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Pots" withImage:[NSImage imageNamed:@"GProduct4.jpg"] inCategory:garden withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Box" withImage:[NSImage imageNamed:@"GProduct5.jpg"] inCategory:garden withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];

	[self createProduct:@"Tray" withImage:[NSImage imageNamed:@"KProduct1.jpg"] inCategory:kitchen withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Whisk" withImage:[NSImage imageNamed:@"KProduct2.jpg"] inCategory:kitchen withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Pan" withImage:[NSImage imageNamed:@"KProduct3.jpg"] inCategory:kitchen withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Knife" withImage:[NSImage imageNamed:@"KProduct4.jpg"] inCategory:kitchen withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
	[self createProduct:@"Pin" withImage:[NSImage imageNamed:@"KProduct5.jpg"] inCategory:kitchen withCarriage:carriage costprice:[NSDecimalNumber decimalNumberWithString:@"1.90"] sellingprice:[NSDecimalNumber decimalNumberWithString:@"2.99"]];
}

- (SWCategory *)createCategory:(NSString *)name 
					 withImage:(NSImage *)image
{
	NSManagedObjectContext *moc = [self managedObjectContext]; 
	SWCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:moc];
	category.name = name;
	if (image != nil)
	{
		category.image = [image TIFFRepresentation];
		category.imagethumb = [[SWImageHelpers makeThumbnail:image] TIFFRepresentation];
	}
	[moc processPendingChanges];
	return category;
}

- (SWProduct *)createProduct:(NSString *)name 
				   withImage:(NSImage *)image 
				  inCategory:(SWCategory *)category
				withCarriage:(SWCarriage *)carriage
				   costprice:(NSDecimalNumber *)cost
				sellingprice:(NSDecimalNumber *)price;
{
	NSManagedObjectContext *moc = [self managedObjectContext]; 
	SWProduct *product = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:moc];
	product.name = name;
	if (image != nil)
	{
		product.image = [image TIFFRepresentation];
		product.imagethumb = [[SWImageHelpers makeThumbnail:image] TIFFRepresentation];
	}
	product.Category = category;
	product.Carriage = carriage;
	product.costprice = cost;
	product.sellingprice = price;
	[moc processPendingChanges];
	return product;
}

- (SWCarriage *)createCarriage:(NSString *)carrier 
				withFixedPrice:(NSNumber *)fixedprice 
			 andPriceperWeight:(NSNumber *)priceperweight
{
	NSManagedObjectContext *moc = [self managedObjectContext]; 
	SWCarriage *carriage = [NSEntityDescription insertNewObjectForEntityForName:@"Carriage" inManagedObjectContext:moc];
	carriage.carrier = carrier;
	carriage.fixedprice = fixedprice;
	carriage.priceperweight = priceperweight;
	[moc processPendingChanges];
	return carriage;
}

- (NSString *)windowNibName
{
	return @"SWDocument";
}

@end
