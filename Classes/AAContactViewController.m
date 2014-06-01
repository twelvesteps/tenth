//
//  AAContactViewController.m
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "NBPhoneNumberUtil+AAAdditions.h"
#import "Phone.h"
#import "Email.h"
#import "AAContactNameAndImageTableViewCell.h"
#import "AAContactPhoneAndEmailTableViewCell.h"
#import "AAContactViewController.h"
#import "AAEditContactViewController.h"
#import "Contact+AAAdditions.h"

@interface AAContactViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIBarButtonItem* leftToolbarButton;

@end

@implementation AAContactViewController

#pragma mark - UI Events

- (IBAction)editButtonTapped:(UIBarButtonItem *)sender
{
    AAEditContactViewController* ecvc = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"EditContact"];
    ecvc.contact = self.contact;
    [self.navigationController pushViewController:ecvc animated:NO];
}


#pragma mark - UITableView Delegate and Datasource

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
        return self.contact.emails.count + self.contact.phones.count;
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
        return [self contactNameCell];
    } else {
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
    
    if (indexPath.row < self.contact.phones.count) {
        NSArray* phones = [[self.contact.phones allObjects] sortedArrayUsingDescriptors:@[sortByTitle]];
        Phone* phone = phones[indexPath.row];
        
        cell.titleLabel.text = [phone.title stringByAppendingString:@":"];
        cell.descriptionLabel.text = [[NBPhoneNumberUtil sharedInstance] formattedPhoneNumberFromNumber:phone.number];
    } else {
        NSArray* emails = [[self.contact.emails allObjects] sortedArrayUsingDescriptors:@[sortByTitle]];
        Email* email = emails[indexPath.row - self.contact.phones.count];
        
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
