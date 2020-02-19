//
//  SWCategory.h
//  StoreWizard
//
//  Created by Daryl on 13/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <CoreData/CoreData.h>

@class SWProduct;

@interface SWCategory :  NSManagedObject  
{
}

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSData * imagethumb;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSSet* Product;

@end


@interface SWCategory (CoreDataGeneratedAccessors)
- (void)addProductObject:(SWProduct *)value;
- (void)removeProductObject:(SWProduct *)value;
- (void)addProduct:(NSSet *)value;
- (void)removeProduct:(NSSet *)value;

@end

