//
//  SWSpree.h
//  StoreWizard
//
//  Created by Daryl Dudey on 15/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SWDocument.h"

@interface SWSpree : NSObject 
{
}

+ (BOOL)checkDependencies;
+ (BOOL)createSpreeSite:(SWDocument *)document;

@end
