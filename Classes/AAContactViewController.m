//
//  AAContactViewController.m
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAContactViewController.h"
// Frameworks
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
// CoreData Objects
#import "Phone+AAAdditions.h"
#import "Email+AAAdditions.h"
#import "Contact+AAAdditions.h"
// Table View Cells
#import "AAContactNameAndImageTableViewCell.h"
#import "AAContactPhoneTableViewCell.h"
#import "AAContactEmailTableViewCell.h"
#import "AAContactSobrietyDateTableViewCell.h"
#import "AAContactSelectSobrietyDateTableViewCell.h"

@interface AAContactViewController () <UIAlertViewDelegate, ABNewPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, AAContactPhoneTableViewCellDelegate, AAContactEmailTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightToolbarButton;

@property (weak, nonatomic) UIButton* selectedButton;
@property (weak, nonatomic) UIDatePicker* sobrietyDatePicker;

@property (nonatomic) BOOL selectDateMode;

@end

@implementation AAContactViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectDateMode = NO;
}

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

- (void)sobrietyDateDoneButtonTapped:(UIButton*)sender
{
    self.contact.sobrietyDate = self.sobrietyDatePicker.date;
    [self.sobrietyDatePicker removeFromSuperview];
    self.sobrietyDatePicker = nil;
    self.selectDateMode = NO;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
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
                                          cancelButtonTitle:nil
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
                                          cancelButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
    
    [alert show];
}

#define PHONE_CAPABILITY_KEY    @"phone"
#define SMS_CAPABILITY_KEY      @"sms"
#define EMAIL_CAPABILITY_KEY    @"email"

- (void)showDeviceDoesNotHaveCapabilityAlert:(NSString*)capabilityName
{
    NSString* alertTitle = nil;
    NSString* alertMessage = nil;
    if ([capabilityName isEqualToString:PHONE_CAPABILITY_KEY]) {
        alertTitle = NSLocalizedString(@"Failed to Complete Call", @"The call could not be completed");
        alertMessage = NSLocalizedString(@"Your device can not make phone calls", @"");
    } else if ([capabilityName isEqualToString:SMS_CAPABILITY_KEY]) {
        alertTitle = NSLocalizedString(@"Failed To Send Message", @"The application could not send the sms message");
        alertMessage = NSLocalizedString(@"Your device can not send SMS messages", @"");
    } else if ([capabilityName isEqualToString:EMAIL_CAPABILITY_KEY]) {
        alertTitle = NSLocalizedString(@"Failed To Send Message", @"The application could not send the email");
        alertMessage = NSLocalizedString(@"Your device can not send Email", @"");
    } else {
        alertTitle = NSLocalizedString(@"Could Not Complete Request", @"The user's recent request is unkown, but could not be completed");
        alertMessage = NSLocalizedString(@"You are using an unsupported device for the given operation",
                                         @"The failed operation is unknown, but the device can not complete it.");
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMessage
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
    [alertView show];
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
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
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
    } else {
        [self showDeviceDoesNotHaveCapabilityAlert:PHONE_CAPABILITY_KEY];
    }
}

- (void)messagePhone:(Phone*)phone
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]]) {
        [self presentMessageViewWithPhone:phone];
    } else {
        [self showDeviceDoesNotHaveCapabilityAlert:SMS_CAPABILITY_KEY];
    }
//
//    NSURL* smsMessageURL = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", phone.number]];
//    if ([[UIApplication sharedApplication] canOpenURL:smsMessageURL]) {
//        [[UIApplication sharedApplication] openURL:smsMessageURL];
//    }

}

- (void)sendMessageToEmail:(Email*)email
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mailto://"]]) {
        [self presentMailViewWithEmail:email];
    } else {
        [self showDeviceDoesNotHaveCapabilityAlert:EMAIL_CAPABILITY_KEY];
    }
}

#pragma mark - UITableView Delegate and Datasource

#define CONTACT_NAME_CELL_SECTION       0
#define CONTACT_PHONES_SECTION          1
#define CONTACT_EMAILS_SECTION          2
#define CONTACT_SOBRIETY_DATE_SECTION   3

#define CONTACT_NAME_CELL_HEIGHT        102.0f
#define CONTACT_PROPERTY_CELL_HEIGHT    52.0f
#define ADD_PROPERTY_CELL_HEIGHT        44.0f
#define DATE_PICKER_HEIGHT              216.0f

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == CONTACT_NAME_CELL_SECTION) {
        return 1;
    } else if (section == CONTACT_PHONES_SECTION){
        return self.contact.phones.count;
    } else if (section == CONTACT_EMAILS_SECTION){
        return self.contact.emails.count;
    } else if (section == CONTACT_SOBRIETY_DATE_SECTION) {
        return 1;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CONTACT_NAME_CELL_SECTION) {
        return CONTACT_NAME_CELL_HEIGHT;
    } else if (indexPath.section == CONTACT_PHONES_SECTION || indexPath.section == CONTACT_EMAILS_SECTION) {
        return CONTACT_PROPERTY_CELL_HEIGHT;
    } else if (indexPath.section == CONTACT_SOBRIETY_DATE_SECTION) {
        return [self heightForSobrietyDateCell];
    } else {
        return 0;
    }
}

- (CGFloat)heightForSobrietyDateCell
{
    if (self.selectDateMode) {
        return ADD_PROPERTY_CELL_HEIGHT + DATE_PICKER_HEIGHT;
    } else if (!self.contact.sobrietyDate) {
        return ADD_PROPERTY_CELL_HEIGHT;
    } else {
        return CONTACT_PROPERTY_CELL_HEIGHT;
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
    } else if (indexPath.section == CONTACT_SOBRIETY_DATE_SECTION) {
        if (self.selectDateMode) {
            [self sobrietyDateDoneButtonTapped:nil];
        } else {
            self.selectDateMode = YES;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:CONTACT_SOBRIETY_DATE_SECTION] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CONTACT_NAME_CELL_SECTION) {
        return [self contactNameCell];
    } else if (indexPath.section == CONTACT_PHONES_SECTION){
        return [self phoneCellForIndexPath:indexPath];
    } else if (indexPath.section == CONTACT_EMAILS_SECTION){
        return [self emailCellForIndexPath:indexPath];
    } else if (indexPath.section == CONTACT_SOBRIETY_DATE_SECTION) {
        return [self sobrietyDateCell];
    } else {
        return nil;
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

- (UITableViewCell*)sobrietyDateCell
{
    if (self.selectDateMode) {
        return [self selectSobrietyDateCell];
    } else {
        if (self.contact.sobrietyDate) {
            AAContactSobrietyDateTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"SobrietyDateCell"];
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMM dd yyyy" options:0 locale:[NSLocale autoupdatingCurrentLocale]];
            cell.descriptionLabel.text = [formatter stringFromDate:self.contact.sobrietyDate];
            
            return cell;
        } else {
            return [self selectSobrietyDateCell];
        }
    }
}

- (AAContactSelectSobrietyDateTableViewCell*)selectSobrietyDateCell
{
    AAContactSelectSobrietyDateTableViewCell* cell = (AAContactSelectSobrietyDateTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"SelectSobrietyDateCell"];
    
    if (!self.selectDateMode) {
        cell.editButton.hidden = YES;
        cell.titleLabel.text = NSLocalizedString(@"Add Sobriety Date", @"Add the sobriety date for the current contact");
        cell.titleLabel.textColor = [self.view tintColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    } else {
        cell.editButton.hidden = NO;
        cell.titleLabel.text = NSLocalizedString(@"Select Sobriety Date", @"Select the sobriety date for the current contact");
        cell.titleLabel.textColor = [UIColor darkTextColor];
        [cell.editButton addTarget:self action:@selector(sobrietyDateDoneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!self.sobrietyDatePicker) {
            UIDatePicker* sobrietyDatePicker = [self datePickerForSobrietyDateCell:cell];
            self.sobrietyDatePicker = sobrietyDatePicker;
            [cell addSubview:sobrietyDatePicker];
        }
    }
    
    return cell;
}

- (UIDatePicker*)datePickerForSobrietyDateCell:(AAContactSelectSobrietyDateTableViewCell*)cell
{
    CGRect datePickerFrame = CGRectMake(cell.bounds.origin.x,
                                        CGRectGetMaxY(cell.titleLabel.frame),
                                        cell.bounds.size.width,
                                        DATE_PICKER_HEIGHT);
    
    UIDatePicker* datePicker = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    
    if (self.contact.sobrietyDate) {
        datePicker.date = self.contact.sobrietyDate;
    } else {
        datePicker.date = [NSDate date];
    }

    return datePicker;
}
@end
