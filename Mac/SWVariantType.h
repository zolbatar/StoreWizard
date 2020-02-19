//
//  SWVariantType.h
//  StoreWizard
//
//  Created by Daryl on 13/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <CoreData/CoreData.h>

@class SWVariantOption;

@interface SWVariantType :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* VariantOption;

@end


@interface SWVariantType (CoreDataGeneratedAccessors)
- (void)addVariantOptionObject:(SWVariantOption *)value;
- (void)removeVariantOptionObject:(SWVariantOption *)value;
- (void)addVariantOption:(NSSet *)value;
- (void)removeVariantOption:(NSSet *)value;

@end

