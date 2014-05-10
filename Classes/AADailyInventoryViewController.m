//
//  AADailyInventoryViewController.m
//  Steps
//
//  Created by Tom on 5/8/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AADailyInventoryViewController.h"
#import "AAUserDataManager.h"
#import "DailyInventory.h"

@interface AADailyInventoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray* dailyInventories;

@end

@implementation AADailyInventoryViewController

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

- (NSArray*)dailyInventories
{
    if (!_dailyInventories) _dailyInventories = [[AAUserDataManager sharedManager] fetchUserDailyInventories];
    return _dailyInventories;
}

- (IBAction)editInventory:(UIBarButtonItem *)sender
{
    
}

- (NSString*)titleForInventory:(DailyInventory*)inventory
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM d, yyy";
    
    return [formatter stringFromDate:inventory.creationDate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dailyInventories.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"inventoryItem"];
    
    cell.textLabel.text = [self titleForInventory:self.dailyInventories[indexPath.row]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
