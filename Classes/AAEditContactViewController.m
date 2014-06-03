//
//  AAEditContactViewController.m
//  Steps
//
//  Created by tom on 5/31/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditContactViewController.h"
#import "AAEditContactNameAndImageTableViewCell.h"
#import "AAEditContactPhoneAndEmailTableViewCell.h"
#import "AAContactAddPhoneAndEmailTableViewCell.h"
#import "NBPhoneNumberUtil+AAAdditions.h"
#import "Phone.h"
#import "Email.h"

@interface AAEditContactViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString* contactFirstName;
@property (strong, nonatomic) NSString* contactLastName;
@property (strong, nonatomic) NSData* contactImageData;
@property (strong, nonatomic) NSArray* contactPhones;
@property (strong, nonatomic) NSArray* contactEmails;

@end

@implementation AAEditContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSSortDescriptor* sortByTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSArray* sortedPhones = [[self.contact.phones allObjects] sortedArrayUsingDescriptors:@[sortByTitle]];
    NSArray* sortedEmails = [[self.contact.emails allObjects] sortedArrayUsingDescriptors:@[sortByTitle]];

    self.contactFirstName = self.contact.firstName;
    self.contactLastName = self.contact.lastName;
    self.contactImageData = self.contact.image;
    self.contactPhones = sortedPhones;
    self.contactEmails = sortedEmails;
}

#pragma mark - UI Events

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender
{
    
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - Tableview Delegate and Datasource

#define CONTACT_NAME_CELL_SECTION       0
#define CONTACT_PHONE_CELL_SECTION      1
#define CONTACT_EMAIL_CELL_SECTION      2

#define CONTACT_NAME_CELL_HEIGHT        112.0f
#define CONTACT_PHONE_EMAIL_CELL_HEIGHT 44.0f

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == CONTACT_NAME_CELL_SECTION) {
        return 1;
    } else if (section == CONTACT_PHONE_CELL_SECTION) {
        return self.contactPhones.count + 1;
    } else {
        return self.contactEmails.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CONTACT_NAME_CELL_SECTION) {
        return CONTACT_NAME_CELL_HEIGHT;
    } else {
        return CONTACT_PHONE_EMAIL_CELL_HEIGHT;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CONTACT_NAME_CELL_SECTION) {
        return [self editContactNameCell];
    } else if (indexPath.section == CONTACT_PHONE_CELL_SECTION) {
        return [self editContactPhoneCellForIndexPath:indexPath];
    } else {
        return [self editContactEmailCellForIndexPath:indexPath];
    }
}

- (UITableViewCell*)editContactNameCell
{
    AAEditContactNameAndImageTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditNameCell"];
    
    if (self.contact.image) {
        UIImage* image = [UIImage imageWithData:self.contactImageData];
        cell.contactImageView.image = image;
    }
    
    cell.contactFirstNameTextField.text = self.contactFirstName;
    cell.contactLastNameTextField.text = self.contactLastName;
    
    return cell;
}

- (UITableViewCell*)editContactPhoneCellForIndexPath:(NSIndexPath*)indexPath
{

    if (indexPath.row < self.contact.phones.count) {
        AAEditContactPhoneAndEmailTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditPhoneEmailCell"];
        Phone* phone = self.contactPhones[indexPath.row];
        
        cell.titleLabel.text = phone.title;
        cell.descriptionTextField.text = [[NBPhoneNumberUtil sharedInstance] formattedPhoneNumberFromNumber:phone.number];
        
        return cell;
    } else {
        AAContactAddPhoneAndEmailTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddPhoneEmailCell"];

        cell.addPhoneAndEmailLabel.text = @"Add Phone";
        
        return cell;
    }
    
}

- (UITableViewCell*)editContactEmailCellForIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row < self.contactEmails.count) {
        AAEditContactPhoneAndEmailTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditPhoneEmailCell"];
        Email* email = self.contactEmails[indexPath.row];
        
        cell.titleLabel.text = email.title;
        cell.descriptionTextField.text = email.address;
        
        return cell;
    } else {
        AAContactAddPhoneAndEmailTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddPhoneEmailCell"];
        
        cell.addPhoneAndEmailLabel.text = @"Add Email";
        
        return cell;
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
