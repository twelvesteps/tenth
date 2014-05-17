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

@interface AADailyInventoryViewController () <UITableViewDataSource, UITableViewDelegate, AAEditDailyInventoryViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray* dailyInventories;

@end

@implementation AADailyInventoryViewController

#pragma mark - View Controller Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.dailyInventories = nil;
}

#pragma mark - Properties

- (NSArray*)dailyInventories
{
    // always refetch from AAUserDataManager
    return [[AAUserDataManager sharedManager] fetchUserDailyInventories];
}

#pragma mark - UI Events

- (IBAction)editInventory:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"setDailyInventory" sender:sender];
}

#pragma mark - EditDailyInventoryView Delegate

- (void)viewController:(AAEditDailyInventoryViewController *)controller didEditDailyInventory:(DailyInventory *)dailyInventory
{
    if (dailyInventory) {
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
        [[AAUserDataManager sharedManager] deleteDailyInventory:self.dailyInventories[indexPath.row]];
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
        
        edivc.delegate = self;
    }
}


@end
