//
//  SWCompany.h
//  StoreWizard
//
//  Created by Daryl Dudey on 15/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface SWCompany :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * logo;

@end



