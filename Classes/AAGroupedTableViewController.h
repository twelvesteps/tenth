//
//  AAGroupedTableViewController.h
//  Steps
//
//  Created by Tom on 12/14/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AATableViewController.h"
#import "AASeparatorTableViewCell.h"

@interface AAGroupedTableViewController : AATableViewController

- (NSString*)titleForSection:(NSInteger)section;

- (AASeparatorTableViewCell*)separatorCellForRowAtIndexPath:(NSIndexPath*)indexPath;

- (BOOL)addSeparatorToCellAtIndexPath:(NSIndexPath*)indexPath;

@end
