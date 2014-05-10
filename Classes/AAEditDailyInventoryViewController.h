//
//  AAEditDailyInventoryViewController.h
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyInventory+AAAdditions.h"

@class AAEditDailyInventoryViewController;
@protocol AAEditDailyInventoryViewControllerDelegate <NSObject>

- (void)viewController:(AAEditDailyInventoryViewController*)controller didEditDailyInventory:(DailyInventory*)dailyInventory;

@end

@interface AAEditDailyInventoryViewController : UIViewController

@property (strong, nonatomic) DailyInventory* dailyInventory;

@end
