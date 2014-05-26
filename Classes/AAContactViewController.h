//
//  AAContactViewController.h
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAUserDataManager.h"

typedef NS_ENUM(NSUInteger, AAContactEditAction) {
    AAContactEditActionSave,
    AAContactEditActionCreate,
    AAContactEditActionCancel,
    AAContactEditActionDelete,
};

@class AAContactViewController;
@protocol AAContactViewControllerDelegate <NSObject>

- (void)viewController:(AAContactViewController*)controller didExitWithAction:(AAContactEditAction)action;

@end

@interface AAContactViewController : UIViewController

@property (strong, nonatomic) Contact* contact;
@property (weak, nonatomic) id<AAContactViewControllerDelegate>delegate;

@end
