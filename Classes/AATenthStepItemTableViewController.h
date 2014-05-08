//
//  AATenthStepItemTableViewController.h
//  Steps
//
//  Created by Tom on 5/8/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AATenthStepItem.h"

typedef NS_ENUM(int, AAStepItemEditAction) {
    AAStepItemEditActionCreated,
    AAStepItemEditActionSaved,
    AAStepItemEditActionCancelled,
    AAStepItemEditActionDeleted,
};

@class AATenthStepItemTableViewController;
@protocol AATenthStepItemViewControllerDelegate <NSObject>

-(void)viewController:(AATenthStepItemTableViewController*)vc didExitWithAction:(AAStepItemEditAction)action;

@end

@interface AATenthStepItemTableViewController : UITableViewController

@property (weak, nonatomic) id<AATenthStepItemViewControllerDelegate> delegate;
@property (strong, nonatomic) AATenthStepItem* item;

@end
