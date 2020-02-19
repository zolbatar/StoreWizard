//
//  SWProduct.h
//  StoreWizard
//
//  Created by Daryl on 13/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <CoreData/CoreData.h>

@class SWCarriage;
@class SWCategory;
@class SWVariantSet;

@interface SWProduct :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * stock;
@property (nonatomic, retain) NSDecimalNumber * margin;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSData * imagethumb;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSDecimalNumber * costprice;
@property (nonatomic, retain) NSDecimalNumber * sellingprice;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) SWCarriage * Carriage;
@property (nonatomic, retain) NSSet* VariantSet;
@property (nonatomic, retain) SWCategory * Category;

@end


@interface SWProduct (CoreDataGeneratedAccessors)
- (void)addVariantSetObject:(SWVariantSet *)value;
- (void)removeVariantSetObject:(SWVariantSet *)value;
- (void)addVariantSet:(NSSet *)value;
- (void)removeVariantSet:(NSSet *)value;

@end

