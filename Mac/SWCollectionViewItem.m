//
//  SWCollectionViewItem.m
//  StoreWizard
//
//  Created by Daryl on 10/01/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import "SWCollectionViewItem.h"
#import "SWGridItem.h"

@implementation SWCollectionViewItem

- (void)setSelected:(BOOL)flag
{
    [super setSelected:flag];
    [(SWGridItem *)[self view] setSelected:flag];
    [(SWGridItem *)[self view] setNeedsDisplay:YES];
}

@end
