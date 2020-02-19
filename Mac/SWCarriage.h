//
//  SWCarriage.h
//  StoreWizard
//
//  Created by Daryl on 13/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <CoreData/CoreData.h>

@class SWProduct;

@interface SWCarriage :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * fixedprice;
@property (nonatomic, retain) NSString * carrier;
@property (nonatomic, retain) NSNumber * priceperweight;
@property (nonatomic, retain) NSSet* Product;

@end


@interface SWCarriage (CoreDataGeneratedAccessors)
- (void)addProductObject:(SWProduct *)value;
- (void)removeProductObject:(SWProduct *)value;
- (void)addProduct:(NSSet *)value;
- (void)removeProduct:(NSSet *)value;

@end

