//
//  AAContactViewController.m
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "NBPhoneNumberUtil+AAAdditions.h"
#import "Phone+AAAdditions.h"
#import "Email+AAAdditions.h"
#import "AAContactNameAndImageTableViewCell.h"
#import "AAContactPhoneTableViewCell.h"
#import "AAContactEmailTableViewCell.h"
#import "AAContactViewController.h"
#import "Contact+AAAdditions.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>


@interface AAContactViewController () <UIAlertViewDelegate, ABNewPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, AAContactPhoneTableViewCellDelegate, AAContactEmailTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightToolbarButton;

@property (weak, nonatomic) UIButton* selectedButton;

@end

@implementation AAContactViewController

#pragma mark - ViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self needToLinkContact]) {
        self.rightToolbarButton.title = NSLocalizedString(@"Link Contact", @"link contact with phone contacts");
    } else if (!self.contact) {
        self.rightToolbarButton.title = NSLocalizedString(@"Create Contact", @"create new contact");
    } else {
        self.rightToolbarButton.title = NSLocalizedString(@"Edit", @"edit");
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.contact) {
        // should create a new AB contact first
        [self presentNewPersonViewControllerWithPerson:NULL];
    } else if ([self shouldShowPersonRecordNotFoundAlert]){
        [self showPersonRecordNotFoundAlert];
    }
}


#pragma mark - UI Events

- (IBAction)rightToolbarButtonTapped:(UIBarButtonItem *)sender
{
    ABRecordRef person = [[AAUserDataManager sharedManager] fetchPersonRecordForContact:self.contact];
    if (person) {
        // use new person view controller to go straight to edit screen
        [self presentNewPersonViewControllerWithPerson:person];
    } else {
        [self presentPeoplePickerViewController];
    }
    
    self.rightToolbarButton.enabled = NO;
}

- (void)presentNewPersonViewControllerWithPerson:(ABRecordRef)person
{
    ABNewPersonViewController* abnpvc = [[ABNewPersonViewController alloc] init];
    abnpvc.displayedPerson = person;
    abnpvc.title = (person) ? @"" : NSLocalizedString(@"New Contact", @"New contact");
    abnpvc.newPersonViewDelegate = self;
    [self.navigationController pushViewController:abnpvc animated:YES];
}

- (void)presentPeoplePickerViewController
{
    ABPeoplePickerNavigationController* abppnc = [[ABPeoplePickerNavigationController alloc] init];
    abppnc.peoplePickerDelegate = self;
    [self presentViewController:abppnc animated:YES completion:nil];
}

- (void)presentMessageViewWithPhone:(Phone*)phone
{
    MFMessageComposeViewController* mfcontroller = [[MFMessageComposeViewController alloc] init];
    mfcontroller.messageComposeDelegate = self;
    mfcontroller.recipients = @[phone.number];
    
    [self presentViewController:mfcontroller animated:YES completion:nil];
}

- (void)presentMailViewWithEmail:(Email*)email
{
    MFMailComposeViewController* mfcontroller = [[MFMailComposeViewController alloc] init];
    mfcontroller.mailComposeDelegate = self;
    [mfcontroller setToRecipients:@[email.address]];
    
    [self presentViewController:mfcontroller animated:YES completion:nil];
}

- (void)showPersonRecordNotFoundAlert
{
    NSString* alertTitle = NSLocalizedString(@"Person Not Found",
                                             @"Selected contact could not be found in phone");
    NSString* alertMessage = NSLocalizedString(@"Please select the person associated with this contact",
                                               @"Select the phone contact that should be linked");
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertMessage
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"cancel")
                                          otherButtonTitles:NSLocalizedString(@"Select", @"Select"), nil];
    
    [alert show];
}

- (void)showAddressBookAccessDeniedAlert
{
    NSString* alertTitle = NSLocalizedString(@"Access Denied", @"access to contacts denied by user");
    NSString* alertMessage = NSLocalizedString(@"Change your privacy settings to allow Steps to access your phonebook",
                                               @"Instructions for allowing user phone book access");
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertMessage
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                          otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
    
    [alert show];
}

- (void)showCallCouldNotBeCompletedAlert
{
    NSString* alertTitle = NSLocalizedString(@"Could not complete call", @"Couldn't call the phone number the user tapped");
    NSString* alertMessage = NSLocalizedString(@"Please check the number to make sure it is correct", @"The user needs to review the phone number they have entered into the phone to make sure it is a valid number");
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertMessage
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                          otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
    
    [alert show];
}

- (BOOL)needToLinkContact
{
    if (!self.contact) {
        return NO;
    } else if (self.newContact) {
        return NO;
    } else {
        return [self.contact.needsABLink boolValue];
    }
}

- (BOOL)shouldShowPersonRecordNotFoundAlert
{
    return ([self needToLinkContact] && ![[AAUserDataManager sharedManager] fetchPersonRecordForContact:self.contact]);
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:NSLocalizedString(@"Person Not Found",
                                                           @"Selected contact could not be found in phone")]) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            [self presentPeoplePickerViewController];
        }
    } else if ([alertView.title isEqualToString:NSLocalizedString(@"Access Denied", @"access to contacts denied by user")]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - ABViewController Delegates

#pragma mark ABNewPersonViewController Delegate
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    if (person) { // user saved contact
        [self updateContactDataWithPerson:person];
        [self.navigationController popViewControllerAnimated:YES];
    } else { // user cancelled
        if (self.newContact) { // user didn't create contact
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else { // user didn't edit contact
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    self.rightToolbarButton.enabled = YES;
}


#pragma mark - ABPeoplePickerNavigationController Delegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self updateContactDataWithPerson:person];

    [self dismissViewControllerAnimated:YES completion:^{
        if (self.newContact) {
            self.newContact = NO;
            [self presentNewPersonViewControllerWithPerson:person];
        }
    }];
    
    self.rightToolbarButton.enabled = YES;
    return NO;
}

- (void)updateContactDataWithPerson:(ABRecordRef)person
{
    if (person) {
        if (self.contact) {
            [[AAUserDataManager sharedManager] syncContact:self.contact withPersonRecord:person];
            [self.tableView reloadData];
        } else if (self.newContact && person) {
            self.contact = [[AAUserDataManager sharedManager] createContactWithPersonRecord:person];
            [self.tableView reloadData];
        }
    }
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    self.rightToolbarButton.enabled = YES;
    return NO;
}

#pragma mark - MFMessageComposeView MFMailComposeView Delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.selectedButton.enabled = YES;
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.selectedButton.enabled = YES;
    }];
}


#pragma mark - AAContactPhoneTableViewCell and AAContactEmailTableViewCell Delegate

- (void)phoneCell:(AAContactPhoneTableViewCell *)cell buttonWasPressed:(UIButton *)button
{
    self.selectedButton = button;
    self.selectedButton.enabled = NO;
    
    [self messagePhone:cell.phone];
}

- (void)emailCell:(AAContactEmailTableViewCell *)cell buttonWasPressed:(UIButton *)button
{
    self.selectedButton = button;
    self.selectedButton.enabled = NO;
    
    [self sendMessageToEmail:cell.email];
}

- (void)callPhone:(Phone*)phone
{
    BOOL success = NO;
    NSURL* phoneCallPromptURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phone.number]];
    NSURL* phoneCallNoPromptURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone.number]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneCallPromptURL]) {
        success = [[UIApplication sharedApplication] openURL:phoneCallPromptURL];
    } else if ([[UIApplication sharedApplication] canOpenURL:phoneCallNoPromptURL]){
        success = [[UIApplication sharedApplication] openURL:phoneCallNoPromptURL];
    }

    if (!success)
        [self showCallCouldNotBeCompletedAlert];
}

- (void)messagePhone:(Phone*)phone
{
    [self presentMessageViewWithPhone:phone];
//    
//    NSURL* smsMessageURL = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", phone.number]];
//    if ([[UIApplication sharedApplication] canOpenURL:smsMessageURL]) {
//        [[UIApplication sharedApplication] openURL:smsMessageURL];
//    }

}

- (void)sendMessageToEmail:(Email*)email
{
    [self presentMailViewWithEmail:email];
}


#pragma mark - UITableView Delegate and Datasource

#define CONTACT_NAME_CELL_SECTION       0
#define CONTACT_PHONES_SECTION          1
#define CONTACT_EMAILS_SECTION          2

#define CONTACT_NAME_CELL_HEIGHT        102.0f
#define CONTACT_PHONE_EMAIL_CELL_HEIGHT 52.0f
#define CONTACT_CELL_INSETS             10.0f

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == CONTACT_NAME_CELL_SECTION) {
        return 1;
    } else if (section == CONTACT_PHONES_SECTION){
        return self.contact.phones.count;
    } else {
        return self.contact.emails.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CONTACT_NAME_CELL_SECTION) {
        return CONTACT_NAME_CELL_HEIGHT;
    } else if (indexPath.row == 0) {
        return CONTACT_PHONE_EMAIL_CELL_HEIGHT + CONTACT_CELL_INSETS;
    } else {
        return CONTACT_PHONE_EMAIL_CELL_HEIGHT;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CONTACT_PHONES_SECTION) {
        AAContactPhoneTableViewCell* cell = (AAContactPhoneTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [self callPhone:cell.phone];
    } else if (indexPath.section == CONTACT_EMAILS_SECTION) {
        AAContactEmailTableViewCell* cell = (AAContactEmailTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [self sendMessageToEmail:cell.email];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CONTACT_NAME_CELL_SECTION) {
        return [self contactNameCell];
    } else if (indexPath.section == CONTACT_PHONES_SECTION){
        return [self phoneCellForIndexPath:indexPath];
    } else {
        return [self emailCellForIndexPath:indexPath];
    }

}

- (UITableViewCell*)contactNameCell
{
    AAContactNameAndImageTableViewCell* cell = (AAContactNameAndImageTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"NameCell"];
    
    cell.contactNameLabel.text = self.contact.fullName;
    cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, cell.bounds.size.width);
    
    return cell;
}

- (UITableViewCell*)phoneCellForIndexPath:(NSIndexPath*)indexPath
{
    AAContactPhoneTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PhoneCell"];
    NSSortDescriptor* sortByTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    
    
    NSArray* phones = [[self.contact.phones allObjects] sortedArrayUsingDescriptors:@[sortByTitle]];
    Phone* phone = phones[indexPath.row];

    cell.delegate = self;
    cell.phone = phone;
    cell.titleLabel.text = [phone formattedTitle];
    cell.descriptionLabel.text = phone.number;

    // last item in phones should have a separator
    if (indexPath.row != self.contact.phones.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, cell.bounds.size.width);
    }
    
    return cell;
}

- (UITableViewCell*)emailCellForIndexPath:(NSIndexPath*)indexPath
{
    AAContactEmailTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EmailCell"];
    
    NSSortDescriptor* sortByTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSArray* emails = [[self.contact.emails allObjects] sortedArrayUsingDescriptors:@[sortByTitle]];
    
    Email* email = emails[indexPath.row];
    
    cell.delegate = self;
    cell.email = email;
    cell.titleLabel.text = [email formattedTitle];
    cell.descriptionLabel.text = email.address;
    
    if (indexPath.row != self.contact.emails.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, cell.bounds.size.width);
    }
    
    return cell;
}
@end
