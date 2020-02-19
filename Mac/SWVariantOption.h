//
//  SWVariantOption.h
//  StoreWizard
//
//  Created by Daryl on 13/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <CoreData/CoreData.h>

@class SWVariantType;

@interface SWVariantOption :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) SWVariantType * VariantType;

@end



