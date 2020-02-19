//
//  SWGuid.m
//  StoreWizard
//
//  Created by Daryl Dudey on 15/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWGuid.h"

@implementation SWGuid

+ (NSString *)getGuid
{
	CFUUIDRef uuidObj = CFUUIDCreate(nil);
	NSString *guid = (NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return guid;
}

@end
