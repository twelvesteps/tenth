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

#define POPOVER_VIEW_HORIZONTAL_INSET   27.0f
#define POPOVER_VIEW_VERTICAL_INSET     5.0f
#define POPOVER_VIEW_TRIANGLE_INSET     5.0f
#define POPOVER_VIEW_HEIGHT             93.0f
#define POPOVER_BUTTON_INSET            8.0f
#define POPOVER_ANIMATION_DURATION      0.2f

#define AMEND_TITLE                 NSLocalizedString(@"New Amend", @"Create a new amend as described in the Big Book of Alcoholics Anonymous")
#define RESENTMENT_TITLE            NSLocalizedString(@"New Resentment", @"Create a new resentment as descibred in the Big Book of Alcoholics Anonymous")

- (IBAction)showAddItemPopoverView:(UIBarButtonItem *)sender
{
    UIFont* popoverFont = [UIFont systemFontOfSize:17.0f];
    NSArray* titles = @[AMEND_TITLE,
                        RESENTMENT_TITLE];
    CGFloat popoverWidth = [self popoverViewWidthForTitles:titles withFont:popoverFont];
    
    CGPoint triangleOrigin = CGPointMake(CGRectGetMaxX(self.view.bounds) - POPOVER_VIEW_HORIZONTAL_INSET,
                                         CGRectGetMaxY(self.navigationController.navigationBar.frame) + POPOVER_VIEW_VERTICAL_INSET);
    CGRect popoverFrame = CGRectMake(CGRectGetMaxX(self.view.bounds) - (popoverWidth + POPOVER_VIEW_TRIANGLE_INSET),
                                     CGRectGetMaxY(self.navigationController.navigationBar.frame) + POPOVER_VIEW_VERTICAL_INSET,
                                     popoverWidth,
                                     POPOVER_VIEW_HEIGHT);

    AAPopoverListView* addItemPopoverView = [[AAPopoverListView alloc] initWithFrame:popoverFrame
                                                                      withTriangleOrigin:triangleOrigin
                                                                            buttonTitles:titles];
    
    addItemPopoverView.title = @"addItemPopover";
    addItemPopoverView.buttonFont = popoverFont;
    
    [self showPopoverView:addItemPopoverView];
}

- (void)showPopoverView:(AAPopoverListView*)popoverView
{
    // grab the title of the presented popover if it exists
    // and dismiss the popover
    NSString* currentPopoverTitle = self.popoverView.title;
    if (self.popoverView) {
        
        [self animatePopoverViewFadeOut:self.popoverView];
        self.popoverView = nil;
    }
    
    // user tapped bar button twice, dismiss popover
    if (![popoverView.title isEqualToString:currentPopoverTitle]) {
        popoverView.delegate = self;
        popoverView.alpha = 0.0f;
        self.popoverView = popoverView;
        [self.view addSubview:popoverView];
        self.tableView.userInteractionEnabled = NO;
        
        [self animatePopoverViewFadeIn:popoverView];
    }
}

- (CGFloat)popoverViewWidthForTitles:(NSArray*)titles withFont:(UIFont*)font
{
    CGFloat width = 0.0f;
    
    for (NSString* title in titles) {
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: font}];
        if (titleSize.width > width) {
            width = ceilf(titleSize.width);
        }
    }
    
    return width + 2 * POPOVER_BUTTON_INSET;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.popoverView) {
        [self hidePopoverView];
    }
}

- (void)animatePopoverViewFadeIn:(AAPopoverListView*)popoverView
{
    [UIView animateWithDuration:POPOVER_ANIMATION_DURATION animations:^{
        popoverView.alpha = 1.0f;
    }];
}

- (void)animatePopoverViewFadeOut:(AAPopoverListView*)popoverView
{
    [UIView animateWithDuration:POPOVER_ANIMATION_DURATION animations:^{
        popoverView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popoverView removeFromSuperview];
    }];
}

- (void)hidePopoverView
{
    [self animatePopoverViewFadeOut:self.popoverView];
    self.popoverView = nil;
    self.tableView.userInteractionEnabled = YES;
}

#pragma mark - AAPopoverViewDelegate

- (void)popoverView:(AAPopoverListView *)pv buttonTappedAtIndex:(NSInteger)index
{
    if ([pv.title isEqualToString:@"addItemPopover"]) {
        [self addItemPopoverView:pv buttonTappedAtIndex:index];
    }
}

- (void)addItemPopoverView:(AAPopoverListView*)pv buttonTappedAtIndex:(NSInteger)index
{
    if ([[pv buttonTitleAtIndex:index] isEqualToString:AMEND_TITLE]) {
        DLog(@"<DEBUG> Add amend button tapped");
    } else if ([[pv buttonTitleAtIndex:index] isEqualToString:RESENTMENT_TITLE]){
        DLog(@"<DEBUG> Add resentment button tapped");
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
