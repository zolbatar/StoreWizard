//
//  SWVariantSet.h
//  StoreWizard
//
//  Created by Daryl on 14/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <CoreData/CoreData.h>

@class SWProduct;
@class SWVariant;

@interface SWVariantSet :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * stock;
@property (nonatomic, retain) SWProduct * Product;
@property (nonatomic, retain) NSSet* Variant;

@end


@interface SWVariantSet (CoreDataGeneratedAccessors)
- (void)addVariantObject:(SWVariant *)value;
- (void)removeVariantObject:(SWVariant *)value;
- (void)addVariant:(NSSet *)value;
- (void)removeVariant:(NSSet *)value;

@end

