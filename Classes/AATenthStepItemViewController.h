//
//  AATenthStepItemViewController.h
//  Steps
//
//  Created by Tom on 5/4/14.
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

@class AATenthStepItemViewController;
@protocol AATenthStepItemViewControllerDelegate <NSObject>

-(void)viewController:(AATenthStepItemViewController*)vc didExitWithAction:(AAStepItemEditAction)action;

@end

@interface AATenthStepItemViewController : UIViewController

@property (weak, nonatomic) id<AATenthStepItemViewControllerDelegate> delegate;
@property (strong, nonatomic) AATenthStepItem* item;

@end
