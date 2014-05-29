//
//  AAContactViewController.m
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "NBPhoneNumberUtil.h"
#import "Phone.h"
#import "Email.h"
#import "AAContactNameAndImageTableViewCell.h"
#import "AAContactPhoneAndEmailTableViewCell.h"
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

#define CONTACT_NAME_CELL_ROW           0

#define CONTACT_NAME_CELL_HEIGHT        112.0f
#define CONTACT_PHONE_EMAIL_CELL_HEIGHT 44.0f

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + self.contact.emails.count + self.contact.phones.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == CONTACT_NAME_CELL_ROW) {
        return CONTACT_NAME_CELL_HEIGHT;
    } else {
        return CONTACT_PHONE_EMAIL_CELL_HEIGHT;
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == CONTACT_NAME_CELL_ROW) {
            return [self contactNameCell];
    }
    else {
        return [self phoneEmailCellForIndexPath:indexPath];
    }

}

- (UITableViewCell*)contactNameCell
{
    AAContactNameAndImageTableViewCell* cell = (AAContactNameAndImageTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"NameCell"];
    
    cell.contactNameLabel.text = self.contact.fullName;
    
    if (self.contact.image) {
        UIImage* image = [UIImage imageWithData:self.contact.image];
        cell.contactImageView.image = image;
    }
    
    return cell;
}

- (UITableViewCell*)phoneEmailCellForIndexPath:(NSIndexPath*)indexPath
{
    AAContactPhoneAndEmailTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PhoneEmailCell"];
    NSSortDescriptor* sortByTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    
    if (indexPath.row <= self.contact.phones.count) {
        NSArray* phones = [[self.contact.phones allObjects] sortedArrayUsingDescriptors:@[sortByTitle]];
        Phone* phone = phones[indexPath.row - 1];
        
        NBPhoneNumberUtil* phoneUtil = [NBPhoneNumberUtil sharedInstance];
        NSString* regionCode = [phoneUtil getRegionCodeForCountryCode:[phoneUtil extractCountryCode:phone.number nationalNumber:nil]];
        NBPhoneNumber* phoneNumber = [phoneUtil parse:phone.number defaultRegion:regionCode error:nil];
        
        cell.titleLabel.text = [phone.title stringByAppendingString:@":"];
        cell.descriptionLabel.text = [phoneUtil format:phoneNumber numberFormat:NBEPhoneNumberTypeUNKNOWN error:nil];
    } else {
        NSArray* emails = [[self.contact.emails allObjects] sortedArrayUsingDescriptors:@[sortByTitle]];
        Email* email = emails[indexPath.row - self.contact.phones.count - 1];
        
        cell.titleLabel.text = [email.title stringByAppendingString:@":"];
        cell.descriptionLabel.text = email.address;
    }
    
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
