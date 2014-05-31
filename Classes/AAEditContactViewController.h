//
//  AAEditContactViewController.h
//  Steps
//
//  Created by tom on 5/31/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAUserDataManager.h"

@interface AAEditContactViewController : UIViewController

@property (nonatomic) BOOL newContact;
@property (strong, nonatomic) Contact* contact;

@end
