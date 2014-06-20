//
//  AAContactViewController.h
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAUserDataManager.h"
#import "AATableViewController.h"

@interface AAContactViewController : AATableViewController

@property (nonatomic) BOOL newContact;
@property (nonatomic) BOOL shouldShowContactNotLinkedWarning;
@property (strong, nonatomic) Contact* contact;

@end
