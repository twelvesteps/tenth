//
//  AAContactViewController.m
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAContactNameAndImageTableViewCell.h"
#import "AAContactViewController.h"
#import "Contact+AAAdditions.h"

@interface AAContactViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) BOOL newContact;
@property (nonatomic) BOOL editMode;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AAContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.contact) {
        self.contact = [[AAUserDataManager sharedManager] contactWithFirstName:nil lastName:nil contactID:nil];
        self.newContact = YES;
        self.editMode = YES;
        self.navigationItem.title = @"New Contact";
    } else {
        self.newContact = NO;
        self.editMode = NO;
        self.navigationItem.title = [self.contact fullName];
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (IBAction)saveButtonTapped:(UIBarButtonItem*)sender
{
    if (self.newContact) {
        [self.delegate viewController:self didExitWithAction:AAContactEditActionCreate];
    } else {
        [self.delegate viewController:self didExitWithAction:AAContactEditActionSave];
    }
}

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender
{
    if (self.newContact) {
        [[AAUserDataManager sharedManager] removeAAContact:self.contact];
    }
    
    [self.delegate viewController:self didExitWithAction:AAContactEditActionCancel];
}

#pragma mark - UITableView Delegate and Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#define CONTACT_NAME_CELL_ROW   0

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case CONTACT_NAME_CELL_ROW:
            return [self contactNameCell];
            break;
            
        default:
            return nil;
            break;
    }
}

- (UITableViewCell*)contactNameCell
{
    AAContactNameAndImageTableViewCell* cell = (AAContactNameAndImageTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"nameCell"];
    
    UIImage* image = nil;
    if (self.contact.image) {
        image = [UIImage imageWithData:self.contact.image];
    } else {
        image = [UIImage imageNamed:@"AA_Blue_Circle.jpg"];
    }
    cell.contactImageView.image = image;
    
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
