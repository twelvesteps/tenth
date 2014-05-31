//
//  AAEditContactViewController.m
//  Steps
//
//  Created by tom on 5/31/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditContactViewController.h"

@interface AAEditContactViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AAEditContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


#pragma mark - UI Events

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
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
