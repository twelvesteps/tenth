//
//  AASettingsViewController.m
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AASettingsViewController.h"
#import "AASettingTableViewCell.h"
#import "Settings.h"

@interface AASettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary* settings;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AASettingsViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _settings = [[NSUserDefaults standardUserDefaults] objectForKey:AA_USER_SETTINGS];
    if (!_settings) {
        NSMutableDictionary* settings = [[NSMutableDictionary alloc] init];
        [settings setObject:[NSNumber numberWithBool:NO] forKey:AA_USER_SETTING_LOCK_SCREEN];
        [settings setObject:[NSNumber numberWithBool:NO] forKey:AA_USER_SETTING_USE_ADDRESS_BOOK];
    }
}


#pragma mark - Tableview Delegate and Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settings.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    
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
