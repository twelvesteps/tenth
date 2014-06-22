//
//  AADailyInventoryViewController.m
//  Steps
//
//  Created by Tom on 5/8/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "NSDate+AAAdditions.h"
#import "AADailyInventoryViewController.h"
#import "AAEditDailyInventoryViewController.h"
#import "AAUserDataManager.h"
#import "DailyInventory.h"
#import "AAPopoverListView.h"

@interface AADailyInventoryViewController () <UINavigationControllerDelegate, AAPopoverListViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, weak) AAPopoverListView* popoverView;

@property (nonatomic, strong) NSArray* dailyInventories;

@end

@implementation AADailyInventoryViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
}

#pragma mark - Properties

- (NSArray*)dailyInventories
{
    // always refetch from AAUserDataManager
    return [[AAUserDataManager sharedManager] fetchUserDailyInventories];
}

#pragma mark - UI Events

#define AMEND_TITLE                 NSLocalizedString(@"New Amend", @"Create a new amend as described in the Big Book of Alcoholics Anonymous")
#define RESENTMENT_TITLE            NSLocalizedString(@"New Resentment", @"Create a new resentment as descibred in the Big Book of Alcoholics Anonymous")

- (IBAction)showAddItemPopoverView:(UIBarButtonItem *)sender
{
    NSArray* titles = @[AMEND_TITLE,
                        RESENTMENT_TITLE];
    AAPopoverListView* addItemPopoverView = [AAPopoverListView popoverViewPointToNavigationItem:sender
                                                                                  navigationBar:self.navigationController.navigationBar
                                                                               withButtonTitles:titles];
    addItemPopoverView.title = @"addItemPopover";
    
    [self showPopoverView:addItemPopoverView];
}

- (void)showPopoverView:(AAPopoverListView*)popoverView
{
    // grab the title of the presented popover if it exists
    // and dismiss the popover
    NSString* currentPopoverTitle = self.popoverView.title;
    if (self.popoverView) {
        
        [self.popoverView hide:YES];
        self.popoverView = nil;
    }
    
    // user tapped bar button twice, dismiss popover
    if (![popoverView.title isEqualToString:currentPopoverTitle]) {
        popoverView.delegate = self;
        popoverView.alpha = 0.0f;
        self.popoverView = popoverView;
        
        [popoverView showInView:self.view animated:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.popoverView) {
        [self hidePopoverView];
    }
}

- (void)hidePopoverView
{
    [self.popoverView hide:YES];
    self.popoverView = nil;
}

#pragma mark - AAPopoverViewDelegate

- (void)popoverViewWasDismissed:(AAPopoverListView *)pv
{
    [self hidePopoverView];
}

- (void)popoverView:(AAPopoverListView *)pv buttonTappedAtIndex:(NSInteger)index
{
    if ([pv.title isEqualToString:@"addItemPopover"]) {
        [self addItemPopoverView:pv buttonTappedAtIndex:index];
    }
    
    [self hidePopoverView];
}

- (void)addItemPopoverView:(AAPopoverListView*)pv buttonTappedAtIndex:(NSInteger)index
{
    if ([[pv buttonTitleAtIndex:index] isEqualToString:AMEND_TITLE]) {
        DLog(@"<DEBUG> New Amend button tapped");
    } else if ([[pv buttonTitleAtIndex:index] isEqualToString:RESENTMENT_TITLE]){
        DLog(@"<DEBUG> New Resentment button tapped");
    }
}

#pragma mark - NavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isEqual:self]) {
        [self.tableView reloadData];
    }
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - Tableview Datasource and Delegate

- (NSString*)titleForInventory:(DailyInventory*)inventory
{
    if ([NSDate dateIsSameDayAsToday:inventory.date]) {
        return @"Today";
    } else {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMM d, yyy";
        
        return [formatter stringFromDate:inventory.date];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dailyInventories.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[AAUserDataManager sharedManager] removeDailyInventory:self.dailyInventories[indexPath.row]];
    }
    
    [self.tableView reloadData];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"inventoryItem"];
    
    cell.textLabel.text = [self titleForInventory:self.dailyInventories[indexPath.row]];
    if ([cell.textLabel.text isEqualToString:@"Today"]) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    }
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[AAEditDailyInventoryViewController class]]) {
        AAEditDailyInventoryViewController* edivc = (AAEditDailyInventoryViewController*)segue.destinationViewController;
        
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath* cellPath = [self.tableView indexPathForCell:(UITableViewCell*)sender];
            edivc.dailyInventory = self.dailyInventories[cellPath.row];
        }
    }
}


@end
