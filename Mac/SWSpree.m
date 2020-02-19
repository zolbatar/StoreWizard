//
//  SWSpree.m
//  StoreWizard
//
//  Created by Daryl Dudey on 15/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWSpree.h"
#import "SWGuid.h"
#import "SWDocument.h"
#import "STPrivilegedTask.h"
//#include <Security/Security.h>

@implementation SWSpree

+ (BOOL)execute:(NSString *)cmd withArgs:(NSArray *)args
{
	STPrivilegedTask *task = [STPrivilegedTask launchedPrivilegedTaskWithLaunchPath:cmd arguments:args];
	int status = [task terminationStatus];
	if (status == 0)
	{
		NSData *data = [[task outputFileHandle] readDataToEndOfFile];
		NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@", output);
	}
	else 
	{
		NSLog(@"Statement failed");
		return NO;
	}


	return YES;
}

+ (BOOL)checkDependencies
{
	[self execute:@"/usr/bin/gem" withArgs:[NSArray arrayWithObjects:@"install", @"rails", nil]];
	[self execute:@"/usr/bin/gem" withArgs:[NSArray arrayWithObjects:@"list", nil]];
	return YES;
}

+ (BOOL)createSpreeSite:(SWDocument *)document
{
	NSManagedObjectContext *moc = [document managedObjectContext];
	NSFetchRequest *request;
	
	// Get company
	request = [NSFetchRequest new];
	[request setEntity:[NSEntityDescription entityForName:@"Company" inManagedObjectContext:moc]];
	NSArray *arrayCompany = [moc executeFetchRequest:request error:nil];
	SWCompany *company = [arrayCompany lastObject];

	// Get categories
	request = [NSFetchRequest new];
	[request setEntity:[NSEntityDescription entityForName:@"Category" inManagedObjectContext:moc]];
	NSArray *thisArrayCategories = [moc executeFetchRequest:request error:nil];
	
	// Get products
	request = [NSFetchRequest new];
	[request setEntity:[NSEntityDescription entityForName:@"Product" inManagedObjectContext:moc]];
	NSArray *arrayProducts = [moc executeFetchRequest:request error:nil];
	
	// Company
	if ([company.guid length] == 0)
	{
		company.guid = [SWGuid getGuid];
	}
	
	// File actions
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSString *dotFolder = [NSString stringWithFormat:@"/Users/daryl/.storewizard"];
	NSString *folder = [NSString stringWithFormat:@"/Users/daryl/.storewizard/%@", company.guid];
	
	// Ensure dot folder is there
	if (![fileManager createDirectoryAtPath:dotFolder withIntermediateDirectories:YES attributes:nil error:nil])
	{
		NSLog(@"Unable to create root folder");
		return NO;
	}
	
	// Remove existing folder
	if (![fileManager removeItemAtPath:folder error:nil])
	{
		NSLog(@"Unable to remove old spree folder, not a fatal error");
	}
	
	// Ensure data folder is there
	if (![fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil])
	{
		NSLog(@"Unable to create new spree folder");
		return NO;
	}
	
	// Ensure preload data folder is there
	if (![fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/preload/db/data/assets", folder] withIntermediateDirectories:YES attributes:nil error:nil])
	{
		NSLog(@"Unable to create new preload data folder");
		return NO;
	}
	
	// Ensure assets folder is there
	if (![fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/data/assets", folder] withIntermediateDirectories:YES attributes:nil error:nil])
	{
		NSLog(@"Unable to create new assets folder");
		return NO;
	}

	// Ensure preload lib folder is there
	if (![fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/preload/lib/tasks", folder] withIntermediateDirectories:YES attributes:nil error:nil])
	{
		NSLog(@"Unable to create new preload lib folder");
		return NO;
	}
	
	// Create strings
	NSMutableString *assetsXML = [[NSMutableString alloc] init];
	NSMutableString *optionTypesXML = [[NSMutableString alloc] init];
	NSMutableString *optionValuesXML = [[NSMutableString alloc] init];
	NSMutableString *productsXML = [[NSMutableString alloc] init];
	NSMutableString *productOptionTypesXML = [[NSMutableString alloc] init];
	NSMutableString *taxonsXML = [[NSMutableString alloc] init];
	NSMutableString *variantsXML = [[NSMutableString alloc] init];
	
	// Products
	for (SWProduct *product in arrayProducts)
	{
		if ([product.guid length] == 0)
		{
			product.guid = [SWGuid getGuid];
		}
		
		int stock = 5;
		NSString *productID = product.guid;
		NSString *desc = @"";
		if (product.desc != 0)
		{
			desc = product.desc;
		}
		
		// Product
		[productsXML appendFormat:@"%@:\n  name: %@\n  description: %@\n  count_on_hand: %d\n  available_on: <%%= Time.zone.now.to_s(:db) %%>\n  permalink: %@\n", 
		 productID, product.name, desc, stock, product.name];
		
		// Asset
		NSString *assetFilename = [NSString stringWithFormat:@"%@.png", productID];
		NSImage *assetImage = [[NSImage alloc] initWithData:product.image];
		NSSize size = [assetImage size];
		[assetsXML appendFormat:@"%@:\n  viewable: %@\n  viewable_type: Product\n  attachment_content_type: image/png\n  attachment_file_name: %@\n  attachment_width: %0.f\n  attachment_height: %0.f\n  type: Image\n  position: 1\n",
		 productID, productID, assetFilename, size.width, size.height];
		[product.image writeToFile:[NSString stringWithFormat:@"%@/data/assets/%@", folder, assetFilename] atomically:YES];
		
		// Variant
		[variantsXML appendFormat:@"%@:\n  product: %@\n  price: %.2f\n  cost_price: %.2f\n  count_on_hand: %d\n  is_master: true\n", 
		 productID, productID, [product.sellingprice doubleValue], [product.costprice doubleValue], stock];
		
		// Variants
		/*		if ([product.option1 length] != 0)
		 {
		 [optionTypesXML appendFormat:@"%@:\n  name: %@\n  presentation: %@\n", 
		 product.option1, product.option1, product.option1];
		 [productOptionTypesXML appendFormat:@"%@_%@:\n  product: %@\n  option_type: %@\n  position: 1\n", productID, product.option1, productID, product.option1];
		 }
		 if ([product.option2 length] != 0)
		 {
		 [optionTypesXML appendFormat:@"%@:\n  name: %@\n  presentation: %@\n", 
		 product.option2, product.option2, product.option2];
		 [productOptionTypesXML appendFormat:@"%@_%@:\n  product: %@\n  option_type: %@\n  position: 2\n", productID, product.option2, productID, product.option2];
		 }
		 for (SWVariant *variant in [product.Variant allObjects])
		 {
		 NSString *varProductID = [NSString stringWithFormat:@"%@_%@_%@", productID, variant.option1, variant.option2];
		 [variantsXML appendFormat:@"%@:\n  product: %@\n  option_values: %@, %@\n  price: %.2f\n  cost_price: %.2f\n  count_on_hand: %d\n", 
		 varProductID, productID, variant.option1, variant.option2, [product.sellingprice doubleValue], [product.costprice doubleValue], variant.stock];
		 //			[assetsXML appendFormat:@"%@:\n  viewable: %@\n  viewable_type: Variant\n  attachment_content_type: image/png\n  attachment_file_name: %@\n  attachment_width: %0.f\n  attachment_height: %0.f\n  type: Image\n  position: 1\n",
		 //			 varProductID, varProductID, assetFilename, size.width, size.height];
		 if ([variant.option1 length] != 0)
		 {
		 [optionValuesXML appendFormat:@"%@:\n  name: %@\n  presentation: %@\n  position: 1\n  option_type: %@\n",
		 variant.option1, variant.option1, variant.option1, product.option1];
		 }
		 if ([variant.option2 length] != 0)
		 {
		 [optionValuesXML appendFormat:@"%@:\n  name: %@\n  presentation: %@\n  position: 1\n  option_type: %@\n",
		 variant.option2, variant.option2, variant.option2, product.option2];
		 }
		 }*/
	}
	
	// Categories
	int num = 0;
	[taxonsXML appendFormat:@"0:\n  id: 0\n  name: Categories\n  taxonomy: master_categories\n  position: %d\n  permalink: categories/\n"];
	for (SWCategory *category in thisArrayCategories)
	{
		if ([category.guid length] == 0)
		{
			category.guid = [SWGuid getGuid];
		}
		
		// List of products
		request = [NSFetchRequest new];
		[request setEntity:[NSEntityDescription entityForName:@"Product" inManagedObjectContext:moc]];
		[request setPredicate:[NSPredicate predicateWithFormat:@"category == %@", category]];
		NSArray *categoryProducts = [moc executeFetchRequest:request error:nil];
		NSMutableString *products = [[NSMutableString alloc] init];
		for (SWProduct *categoryProduct in categoryProducts)
		{
			[products appendFormat:@"%@, ", categoryProduct.guid];
		}
		[products deleteCharactersInRange:NSMakeRange([products length] - 1, 1)];
		
		[taxonsXML appendFormat:@"%@:\n  name: %@\n  parent_id: 0\n  taxonomy: master_categories\n  position: %d\n  permalink: %@\n  products: %@\n",
		 category.guid, category.name, num++, [[NSString stringWithFormat:@"categories/%@/", category.name] lowercaseString], products];
	}
	
	// Write out
	[assetsXML writeToFile:[NSString stringWithFormat:@"%@/preload/db/data/assets.yml", folder] atomically:YES encoding:NSUTF8StringEncoding error:nil];
	[optionTypesXML writeToFile:[NSString stringWithFormat:@"%@/preload/db/data/option_types.yml", folder] atomically:YES encoding:NSUTF8StringEncoding error:nil];
	[optionValuesXML writeToFile:[NSString stringWithFormat:@"%@/preload/db/data/option_values.yml", folder] atomically:YES encoding:NSUTF8StringEncoding error:nil];
	[productsXML writeToFile:[NSString stringWithFormat:@"%@/preload/db/data/products.yml", folder] atomically:YES encoding:NSUTF8StringEncoding error:nil];
	[productOptionTypesXML writeToFile:[NSString stringWithFormat:@"%@/preload/db/data/product_option_types.yml", folder] atomically:YES encoding:NSUTF8StringEncoding error:nil];
	[taxonsXML writeToFile:[NSString stringWithFormat:@"%@/preload/db/data/taxons.yml", folder] atomically:YES encoding:NSUTF8StringEncoding error:nil];
	[variantsXML writeToFile:[NSString stringWithFormat:@"%@/preload/db/data/variants.yml", folder] atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	// Save users.rb
	NSMutableString *usersRB = [[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"users.rb" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
	[usersRB replaceOccurrencesOfString:@"<$USER$>" withString:@"admin" options:NSLiteralSearch range:NSMakeRange(0, [usersRB length])];
	[usersRB replaceOccurrencesOfString:@"<$PASS$>" withString:@"password" options:NSLiteralSearch range:NSMakeRange(0, [usersRB length])];
	[usersRB writeToFile:[NSString stringWithFormat:@"%@/users.rb", folder] atomically:YES encoding:NSUTF8StringEncoding error:nil];

	// Save preload.rb
	NSMutableString *preloadRB = [[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"preload.rb" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
	[preloadRB writeToFile:[NSString stringWithFormat:@"%@/preload/lib/preload.rb", folder] atomically:YES encoding:NSUTF8StringEncoding error:nil];

	// Save install.rake
	NSMutableString *installRAKE = [[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"install.rake" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
	[installRAKE writeToFile:[NSString stringWithFormat:@"%@/preload/lib/tasks/install.rake", folder] atomically:YES encoding:NSUTF8StringEncoding error:nil];

	// Save products.rb
	NSMutableString *productsRB = [[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"products.rb" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
	[productsRB writeToFile:[NSString stringWithFormat:@"%@/preload/db/data/products.rb", folder] atomically:YES encoding:NSUTF8StringEncoding error:nil];

	// Save taxons.rb
	NSMutableString *taxonsRB = [[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"taxons.rb" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
	[taxonsRB writeToFile:[NSString stringWithFormat:@"%@/preload/db/data/taxons.rb", folder] atomically:YES encoding:NSUTF8StringEncoding error:nil];

	// Save taxonomies.yml
	NSMutableString *taxonomiesYML = [[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"taxonomies.yml" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
	[taxonomiesYML writeToFile:[NSString stringWithFormat:@"%@/preload/db/data/taxonomies.yml", folder] atomically:YES encoding:NSUTF8StringEncoding error:nil];

	// Construct script, this is the fun bit :)
	NSMutableString *script = [[NSMutableString alloc] init];
	[script appendFormat:@"cd %@\nrails new store\ncd store\necho Paperclip.options[:image_magick_path] = \\\"/usr/local/bin\\\" >> config/initializers/paperclip.rb\n"
	 "rm GemFile\necho source \\'http://rubygems.org\\' >> GemFile\necho gem \\'rails\\',\\'3.0.3\\' >> GemFile\necho gem \\'sqlite3-ruby\\', :require =\\> \\'sqlite3\\' >> GemFile\necho gem \\'spree\\',\\'0.40.2\\' >> GemFile\n"
	 "rails g spree:site\nrake spree:install\nrake db:create\nrake db:migrate\n"
	 "mv ../users.rb db/sample/users.rb\nmv ../data db\nmv ../preload vendor/plugins\n"
	 "rake preload:import\n", folder];
	NSString *scriptPath = [NSString stringWithFormat:@"%@/build.sh", folder];
	[script writeToFile:scriptPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:@"/bin/sh"];
	[task setArguments:[NSArray arrayWithObject:scriptPath]];
	[task launch];
	[task waitUntilExit];
	
	return YES;
}

@end
