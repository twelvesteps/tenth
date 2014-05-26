//
//  AAContactViewController.m
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAContactViewController.h"

@interface AAContactViewController ()

@property (nonatomic) BOOL newContact;

@end

@implementation AAContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.contact) {
        self.contact = [[AAUserDataManager sharedManager] contactWithFirstName:nil lastName:nil contactID:nil];
        self.newContact = YES;
        self.navigationItem.title = @"New Contact";
    } else {
        self.newContact = NO;
        self.navigationItem.title = @"View Contact";
    }
}

- (IBAction)saveButtonTapped:(UIBarButtonItem*)sender
{
    if (self.newContact) {
        [self.delegate viewController:self didExitWithAction:AAContactEditActionCreate];
    } else {
        [self.delegate viewController:self didExitWithAction:AAContactEditActionSave];
    }
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
