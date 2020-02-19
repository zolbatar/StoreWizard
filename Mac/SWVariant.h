//
//  SWVariant.h
//  StoreWizard
//
//  Created by Daryl on 14/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <CoreData/CoreData.h>

@class SWVariantOption;
@class SWVariantSet;

@interface SWVariant :  NSManagedObject  
{
}

@property (nonatomic, retain) SWVariantOption * VariantOption;
@property (nonatomic, retain) SWVariantSet * VariantSet;

@end



