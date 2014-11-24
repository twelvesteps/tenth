//
//  AAContactViewController.m
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAContactViewController.h"
#import "AATelPromptDelegate.h"
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
#import "AAContactSetSponsorTableViewCell.h"

@interface AAContactViewController () <UIAlertViewDelegate, UIActionSheetDelegate, ABNewPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, AAContactPhoneTableViewCellDelegate, AAContactEmailTableViewCellDelegate, AATelPromptDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightToolbarButton;

@property (weak, nonatomic) UIButton* selectedButton;
@property (weak, nonatomic) UIDatePicker* sobrietyDatePicker;

@property (nonatomic) BOOL selectDateMode;

@end

@implementation AAContactViewController

#define CANCEL_BUTTON_TITLE             NSLocalizedString(@"Cancel", @"Cancel")
#define LINK_CONTACT_BUTTON_TITLE       NSLocalizedString(@"Link Contact", @"link contact with phone contacts")
#define CREATE_CONTACT_BUTTON_TITLE     NSLocalizedString(@"Create Contact", @"create new contact")
#define EDIT_BUTTON_TITLE               NSLocalizedString(@"Edit", @"edit")

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
        self.rightToolbarButton.title = LINK_CONTACT_BUTTON_TITLE;
    } else if (!self.contact) {
        self.rightToolbarButton.title = CREATE_CONTACT_BUTTON_TITLE;
    } else {
        self.rightToolbarButton.title = EDIT_BUTTON_TITLE;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.contact) {
        // should create a new AB contact first
        [self presentNewPersonViewControllerWithPerson:NULL];
    } else if (self.shouldShowContactNotLinkedWarning){
        [self showPersonRecordNotFoundAlert];
        self.shouldShowContactNotLinkedWarning = NO;
    } else if (self.mode == AAContactViewConrollerCallContactMode) {
        if (self.contact.phones.count == 1) {
            [self callPhone:[[self.contact phones] anyObject]];
        } else {
            [self showCallActionSheetWithContact:self.contact];
        }
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
    self.selectDateMode = NO;
    [self removeSobrietyDatePickerFromView];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)removeSobrietyDatePickerFromView
{
    [self.sobrietyDatePicker removeFromSuperview];
    self.sobrietyDatePicker = nil;
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

#define PERSON_NOT_FOUND_TITLE      NSLocalizedString(@"Person Not Found",@"Selected contact could not be found in phone")
#define ACCESS_DENIED_TITLE         NSLocalizedString(@"Access Denied", @"access to contacts denied by user")
#define CALL_NOT_COMPLETED_TITLE    NSLocalizedString(@"Could not complete call", @"Couldn't call the phone number the user tapped")

- (void)showPersonRecordNotFoundAlert
{
    NSString* alertTitle = PERSON_NOT_FOUND_TITLE;
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
    NSString* alertTitle = ACCESS_DENIED_TITLE;
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
    NSString* alertTitle = CALL_NOT_COMPLETED_TITLE;
    NSString* alertMessage = NSLocalizedString(@"Please check the number to make sure it is correct", @"The user needs to review the phone number they have entered into the phone to make sure it is a valid number");
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertMessage
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
    
    [alert show];
}

- (void)showCallActionSheetWithContact:(Contact*)contact
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:contact.fullName
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    NSArray* sortedPhones = [[self.contact.phones allObjects] sortedArrayUsingSelector:@selector(comparePhoneNumbers:)];
    
    for (Phone* phone in sortedPhones) {
        NSString* phoneTitle = [phone.formattedTitle stringByAppendingFormat:@": %@", phone.number];
        [actionSheet addButtonWithTitle:phoneTitle];
    }
    
    [actionSheet addButtonWithTitle:CANCEL_BUTTON_TITLE];
    actionSheet.cancelButtonIndex = contact.phones.count;
    
    [actionSheet showInView:self.view];
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
    self.selectedButton.enabled = YES;
}

- (BOOL)needToLinkContact
{
    if (!self.contact) {
        return NO;
    } else if (self.mode == AAContactViewConrollerNewContactMode) {
        return NO;
    } else {
        return [self.contact.needsABLink boolValue];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:PERSON_NOT_FOUND_TITLE]) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            [self presentPeoplePickerViewController];
        }
    } else {
        if (self.mode == AAContactViewConrollerCallContactMode) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSArray* sortedPhones = [[self.contact.phones allObjects] sortedArrayUsingSelector:@selector(comparePhoneNumbers:)];
        Phone* phone = sortedPhones[buttonIndex];
        [self callPhone:phone];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ABViewController Delegates

#pragma mark ABNewPersonViewController Delegate
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView
       didCompleteWithNewPerson:(ABRecordRef)person
{
    if (person) { // user saved contact
        [self updateContactDataWithPerson:person];
        [self.navigationController popViewControllerAnimated:YES];
    } else { // user cancelled
        if (self.mode == AAContactViewConrollerNewContactMode) { // user didn't create contact
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
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.mode != AAContactViewConrollerExistingContactMode) {
            dispatch_async(dispatch_get_main_queue(), ^ {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
               self.rightToolbarButton.enabled = YES;
            });
        }
    }];

}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self updateContactDataWithPerson:person];

    [self dismissViewControllerAnimated:YES completion:^{
        if (self.mode == AAContactViewConrollerNewContactMode) {
            self.mode = AAContactViewConrollerExistingContactMode;
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
        } else if (self.mode == AAContactViewConrollerNewContactMode && person) {
            self.contact = [[AAUserDataManager sharedManager] createContactWithPersonRecord:person];
            [self.tableView reloadData];
        }
    }
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    self.rightToolbarButton.enabled = YES;
    return NO;
}

#pragma mark - MFMessageComposeView MFMailComposeView Delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.selectedButton.enabled = YES;
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
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
        NSString* cleanedNumber = [phone.number stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSURL* phoneCallPromptURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", cleanedNumber]];
        NSURL* phoneCallNoPromptURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", cleanedNumber]];
        if ([[UIApplication sharedApplication] canOpenURL:phoneCallPromptURL]) {
            [AATelPromptDelegate sharedDelegate].telPromptDelegate = self;
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

#pragma mark - AATelPromptDelegate

- (void)telPromptDidCancel
{
    [AATelPromptDelegate sharedDelegate].telPromptDelegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)telPromptDidCall
{
    [AATelPromptDelegate sharedDelegate].telPromptDelegate = nil;
}

#pragma mark - UITableView Delegate and Datasource

#define CONTACT_NAME_CELL_SECTION       0
#define CONTACT_PHONES_SECTION          1
#define CONTACT_EMAILS_SECTION          2
#define CONTACT_SOBRIETY_DATE_SECTION   3
#define CONTACT_SET_SPONSOR_SECTION     4

#define CONTACT_NAME_CELL_HEIGHT        72.0f
#define CONTACT_PROPERTY_CELL_HEIGHT    44.0f
#define ADD_PROPERTY_CELL_HEIGHT        44.0f
#define DATE_PICKER_HEIGHT              216.0f

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case CONTACT_NAME_CELL_SECTION:
            return 1;
        
        case CONTACT_PHONES_SECTION:
            return self.contact.phones.count;
            
        case CONTACT_EMAILS_SECTION:
            return self.contact.emails.count;
        
        case CONTACT_SOBRIETY_DATE_SECTION:
            return 1;
        
        case CONTACT_SET_SPONSOR_SECTION:
            return 1;
            
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case CONTACT_NAME_CELL_SECTION:
            return CONTACT_NAME_CELL_HEIGHT;
        
        case CONTACT_PHONES_SECTION:
            return CONTACT_PROPERTY_CELL_HEIGHT;
            
        case CONTACT_EMAILS_SECTION:
            return CONTACT_PROPERTY_CELL_HEIGHT;
            
        case CONTACT_SOBRIETY_DATE_SECTION:
            return [self heightForSobrietyDateCell];
            
        case CONTACT_SET_SPONSOR_SECTION:
            return ADD_PROPERTY_CELL_HEIGHT;
            
        default:
            return 0.0f;
            break;
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
    if (self.selectDateMode) {
        [self removeSobrietyDatePickerFromView];
        self.selectDateMode = NO;
    } else {
        switch (indexPath.section) {
            case CONTACT_PHONES_SECTION: {
                AAContactPhoneTableViewCell* cell = (AAContactPhoneTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                [self callPhone:cell.phone];
                break;
            }
                
            case CONTACT_EMAILS_SECTION: {
                AAContactEmailTableViewCell* cell = (AAContactEmailTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                [self sendMessageToEmail:cell.email];
                break;
            }
                
            case CONTACT_SOBRIETY_DATE_SECTION:
                self.selectDateMode = YES;
                break;
                
            case CONTACT_SET_SPONSOR_SECTION: {
                if ([self.contact.isSponsor boolValue]) {
                    self.contact.isSponsor = [NSNumber numberWithBool:NO];
                } else {
                    [[AAUserDataManager sharedManager] setContactAsSponsor:self.contact];
                }
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:CONTACT_NAME_CELL_SECTION],
                                                         [NSIndexPath indexPathForRow:0 inSection:CONTACT_SET_SPONSOR_SECTION]]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
                
            default:
                break;
        }
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:CONTACT_SOBRIETY_DATE_SECTION]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case CONTACT_NAME_CELL_SECTION:
            return [self contactNameCell];

        case CONTACT_PHONES_SECTION:
            return [self phoneCellForIndexPath:indexPath];
            
        case CONTACT_EMAILS_SECTION:
            return [self emailCellForIndexPath:indexPath];
            
        case CONTACT_SOBRIETY_DATE_SECTION:
            return [self sobrietyDateCell];
            
        case CONTACT_SET_SPONSOR_SECTION:
            return [self setSponsorCell];
            
        default:
            return nil;
    }
}

- (UITableViewCell*)contactNameCell
{
    AAContactNameAndImageTableViewCell* cell = (AAContactNameAndImageTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"NameCell"];
    
    cell.contactNameLabel.text = self.contact.fullName;
    cell.sponsorLabel.hidden = ![self.contact.isSponsor boolValue];
    
    cell.separatorInset = UIEdgeInsetsMake(0.0f, cell.bounds.size.width, 0.0f, 0.0f);
        
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
        cell.separatorInset = UIEdgeInsetsMake(0.0f, cell.bounds.size.width, 0.0f, 0.0f);
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

- (UITableViewCell*)setSponsorCell
{
    AAContactSetSponsorTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"SetSponsorCell"];
    
    if ([self.contact.isSponsor boolValue]) {
        cell.changeSponsorLabel.text = NSLocalizedString(@"Remove as Sponsor",
                                                         @"Change the selected contact so that he or she is no longer listed as the user's sponsor");
    } else {
        cell.changeSponsorLabel.text = NSLocalizedString(@"Set as Sponsor",
                                                         @"Change the selected contact so that he or she is now listed as the user's sponsor");
    }
    
    return cell;
}

- (UITableViewCell*)sobrietyDateCell
{
    if (self.selectDateMode || !self.contact.sobrietyDate) {
        return [self selectSobrietyDateCell];
    } else {
        AAContactSobrietyDateTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"SobrietyDateCell"];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMM dd yyyy" options:0 locale:[NSLocale autoupdatingCurrentLocale]];
        cell.descriptionLabel.text = [formatter stringFromDate:self.contact.sobrietyDate];
        
        return cell;
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
