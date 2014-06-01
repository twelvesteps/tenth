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
#import "NBPhoneNumberUtil+AAAdditions.h"
#import "Phone.h"
#import "Email.h"

@interface AAEditContactViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AAEditContactViewController

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

#define CONTACT_NAME_CELL_HEIGHT        112.0f
#define CONTACT_PHONE_EMAIL_CELL_HEIGHT 44.0f

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == CONTACT_NAME_CELL_SECTION) {
        return 1;
    } else {
        return self.contact.phones.count + self.contact.emails.count;
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
    } else {
        return [self editContactPhoneEmailCellForIndexPath:indexPath];
    }
}

- (UITableViewCell*)editContactNameCell
{
    AAEditContactNameAndImageTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditNameCell"];
    
    if (self.contact.image) {
        cell.contactImageView.image = [UIImage imageWithData:self.contact.image];
    }
    
    cell.contactFirstNameTextField.text = self.contact.firstName;
    cell.contactLastNameTextField.text = self.contact.lastName;
    
    return cell;
}

- (UITableViewCell*)editContactPhoneEmailCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditContactPhoneAndEmailTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditPhoneEmailCell"];
    NSSortDescriptor* sortByTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];

    if (indexPath.row < self.contact.phones.count) {
        NSArray* sortedPhones = [[self.contact.phones allObjects] sortedArrayUsingDescriptors:@[sortByTitle]];
        Phone* phone = sortedPhones[indexPath.row];
        
        cell.titleLabel.text = phone.title;
        cell.descriptionTextField.text = [[NBPhoneNumberUtil sharedInstance] formattedPhoneNumberFromNumber:phone.number];
    } else {
        NSArray* sortedEmails = [[self.contact.emails allObjects] sortedArrayUsingDescriptors:@[sortByTitle]];
        Email* email = sortedEmails[indexPath.row - self.contact.phones.count];
        
        cell.titleLabel.text = email.title;
        cell.descriptionTextField.text = email.address;
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
