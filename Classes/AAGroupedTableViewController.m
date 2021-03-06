//
//  AAGroupedTableViewController.m
//  Steps
//
//  Created by Tom on 12/14/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAGroupedTableViewController.h"
#import "AAMeetingSectionDividerView.h"

@implementation AAGroupedTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)setupTableView
{
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self setupTableViewHeaderAndFooter];
}

- (void)setupTableViewHeaderAndFooter
{
    CGFloat dummyViewHeight = self.view.bounds.size.height;
    CGRect dummyViewFrame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, dummyViewHeight);
    
    UIView* dummyHeader = [[UIView alloc] initWithFrame:dummyViewFrame]; // Allows header views to scroll
    UIView* dummyFooter = [[AAMeetingSectionDividerView alloc] initWithFrame:dummyViewFrame]; // Creates consistent color scheme
    dummyHeader.backgroundColor = [UIColor groupTableViewBackgroundColor];
    dummyFooter.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.tableHeaderView = dummyHeader;
    self.tableView.tableFooterView = dummyFooter;
    self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, -dummyViewHeight, 0); // Adjust table view insets to account for dummy views
}

- (NSString*)titleForSection:(NSInteger)section
{
    return nil;
}

- (BOOL)addSeparatorToCellAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row + 1 != [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
}

#define HEADER_VIEW_HEIGHT  30.0f

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_VIEW_HEIGHT;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect headerViewFrame = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, HEADER_VIEW_HEIGHT);
    
    AAMeetingSectionDividerView* headerView = [[AAMeetingSectionDividerView alloc] initWithFrame:headerViewFrame];
    headerView.topSeparator = (section != 0);
    
    return headerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AASeparatorTableViewCell* cell = [self separatorCellForRowAtIndexPath:indexPath];
    cell.bottomSeparator = [self addSeparatorToCellAtIndexPath:indexPath];
    return cell;
}

- (AASeparatorTableViewCell*)separatorCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
