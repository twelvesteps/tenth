//
//  AATableViewController.h
//  Steps
//
//  Created by tom on 5/31/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AATableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView* tableView;

@end
