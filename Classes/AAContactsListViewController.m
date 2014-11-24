//
//  AAContactsListViewController.m
//  Steps
//
//  Created by tom on 5/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import "AAContactsListViewController.h"
#import "AAContactViewController.h"
#import "AAUserDataManager.h"
#import "Contact+AAAdditions.h"
#import "Phone+AAAdditions.h"
#import "AAPopoverListView.h"
#import "AAPeoplePickerViewController.h"

@interface AAContactsListViewController () <ABPersonViewControllerDelegate, UINavigationControllerDelegate, AAPopoverListViewDelegate, AAPeoplePickerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) AAPopoverListView* popoverView;
@property (strong, nonatomic) NSArray* contacts;
@property (strong, nonatomic) NSIndexPath* deletedContactIndexPath;

@end

@implementation AAContactsListViewController

#pragma mark - Viewcontroller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadContacts];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.tableView reloadData];
}


#pragma mark - Properties

- (NSArray*)contacts
{
    if (!_contacts) {
        [self reloadContacts];
    }
    
    return _contacts;
}

- (void)reloadContacts
{
    _contacts = [[AAUserDataManager sharedManager] fetchUserAAContacts];
}


#pragma mark - UI Events

#define CREATE_NEW_CONTACT_TITLE        NSLocalizedString(@"Create New Contact", @"Create New Contact and add to phone's address book")
#define IMPORT_CONTACT_TITLE            NSLocalizedString(@"Import Existing Contact", @"Import Existing Contact from phone's address book")
#define CALL_SPONSOR_TITLE              NSLocalizedString(@"Call Sponsor", @"Call user's AA sponsor")
#define CALL_RANDOM_TITLE               NSLocalizedString(@"Call Random Contact", @"Call a random contact from the list")
#define CANCEL_BUTTON_TITLE             NSLocalizedString(@"Cancel", @"Cancel")
#define OK_BUTTON_TITLE                 NSLocalizedString(@"Ok", @"Ok")

- (IBAction)showAddContactPopoverList:(UIBarButtonItem*)sender
{
    NSArray* titles = @[CREATE_NEW_CONTACT_TITLE,
                        IMPORT_CONTACT_TITLE];
    AAPopoverListView* addContactPopoverView = [AAPopoverListView popoverViewPointToNavigationItem:sender
                                                                                     navigationBar:self.navigationController.navigationBar
                                                                                  withButtonTitles:titles];
    addContactPopoverView.title = @"addContactPopover";
    
    [self showPopoverView:addContactPopoverView];
}

- (IBAction)showCallContactPopoverList:(UIBarButtonItem*)sender
{
    NSArray* titles = @[CALL_SPONSOR_TITLE,
                        CALL_RANDOM_TITLE];

    AAPopoverListView* callContactPopoverView = [AAPopoverListView popoverViewPointToNavigationItem:sender
                                                                                      navigationBar:self.navigationController.navigationBar
                                                                                   withButtonTitles:titles];
    callContactPopoverView.title = @"callContactPopover";
    
    [self showPopoverView:callContactPopoverView];
}

- (void)showPopoverView:(AAPopoverListView*)popoverView
{
    // grab the title of the presented popover if it exists
    // and dismiss the popover
    NSString* currentPopoverTitle = self.popoverView.title;
    if (self.popoverView) {
        [self.popoverView hide:YES];
        self.popoverView = nil;
    }
    
    // user tapped bar button twice, dismiss popover
    if (![popoverView.title isEqualToString:currentPopoverTitle]) {
        popoverView.delegate = self;
        popoverView.alpha = 0.0f;
        self.popoverView = popoverView;
        
        [popoverView showInView:self.view animated:YES];
    }
}

- (void)hidePopoverView
{
    [self.popoverView hide:YES];
    self.popoverView = nil;
}

- (void)showSponsorNotSetAlert
{
    NSString* alertTitle = NSLocalizedString(@"Sponsor has not been set", @"The user has not designated a contact as his or her sponsor");
    NSString* alertMessage = NSLocalizedString(@"To set your sponsor choose a contact and press the \"Set as sponsor\" button", @"Direct the user to choose one\
                                               of his or her contacts and then click the button to set him or her as the sponsor");
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMessage
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:OK_BUTTON_TITLE, nil];
    [alertView show];
}

- (void)showPeoplePickerViewController
{
    AAPeoplePickerViewController* picker = [[AAPeoplePickerViewController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - Personview Delegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    return YES;
}


#pragma mark - AAPeoplePicker Delegate

- (void)peoplePickerNavigationControllerDidCancel:(AAPeoplePickerViewController *)peoplePicker
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)peoplePickerNavigationController:(AAPeoplePickerViewController *)peoplePicker didSelectPeople:(NSArray *)people
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [self.tableView reloadData];
}


#pragma mark - AAPopoverListView Delegate

- (void)popoverViewWasDismissed:(AAPopoverListView *)pv
{
    [self hidePopoverView];
}

- (void)popoverView:(AAPopoverListView *)pv buttonTappedAtIndex:(NSInteger)index
{
    if ([pv.title isEqualToString:@"addContactPopover"]) {
        [self addContactPopoverView:pv buttonTappedAtIndex:index];
    } else if ([pv.title isEqualToString:@"callContactPopover"]) {
        [self callConactPopoverView:pv buttonTappedAtIndex:index];
    }
    
    [self hidePopoverView];
}

- (void)addContactPopoverView:(AAPopoverListView*)pv buttonTappedAtIndex:(NSInteger)index
{
    if ([[pv buttonTitleAtIndex:index] isEqualToString:CREATE_NEW_CONTACT_TITLE]) {
        [self performSegueWithIdentifier:@"newContact" sender:nil];
    } else if ([[pv buttonTitleAtIndex:index] isEqualToString:IMPORT_CONTACT_TITLE]) {
        [self showPeoplePickerViewController];
    }
}

- (void)callConactPopoverView:(AAPopoverListView*)pv buttonTappedAtIndex:(NSInteger)index
{
    if ([[pv buttonTitleAtIndex:index] isEqualToString:CALL_SPONSOR_TITLE]) {
        Contact* sponsor = [[AAUserDataManager sharedManager] fetchSponsor];
        if (sponsor) {
            [self performSegueWithIdentifier:@"callContact" sender:sponsor];
        } else {
            [self showSponsorNotSetAlert];
        }
    } else if ([[pv buttonTitleAtIndex:index] isEqualToString:CALL_RANDOM_TITLE]) {
        NSUInteger randomNumber = arc4random() % self.contacts.count;
        Contact* contact = self.contacts[randomNumber];
        [self performSegueWithIdentifier:@"callContact" sender:contact];
    }
}

#pragma mark - Tableview Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    cell.textLabel.text = [self titleForCellAtIndexPath:indexPath];
    
    return cell;
}

- (NSString*)titleForCellAtIndexPath:(NSIndexPath*)indexPath
{
    Contact* contact = self.contacts[indexPath.row];
    return [contact fullName];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.deletedContactIndexPath = indexPath;
        [[AAUserDataManager sharedManager] removeAAContact:self.contacts[indexPath.row]];
        [self reloadContacts];
        [self.tableView reloadData];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[AAContactViewController class]]) {
        AAContactViewController* aacvc = (AAContactViewController*)segue.destinationViewController;
        
        if ([segue.identifier isEqualToString:@"setContact"]) {
            if ([sender isKindOfClass:[UITableViewCell class]]) {
                // user selected contact from tableview
                UITableViewCell* cell = (UITableViewCell*)sender;
                NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
                
                Contact* contact = self.contacts[indexPath.row];
                
                aacvc.contact = contact;
                aacvc.mode = AAContactViewConrollerExistingContactMode;
                aacvc.shouldShowContactNotLinkedWarning = [self contactViewControllerShouldShowNotLinkedWarningForContact:contact];
            } else if ([sender isKindOfClass:[Contact class]]) {
                // user selected contact from people picker
                Contact* contact = (Contact*)sender;
                
                aacvc.contact = contact;
                aacvc.mode = AAContactViewConrollerExistingContactMode;
                aacvc.shouldShowContactNotLinkedWarning = [self contactViewControllerShouldShowNotLinkedWarningForContact:contact];
            }
        } else if ([segue.identifier isEqualToString:@"newContact"]) {
            aacvc.shouldShowContactNotLinkedWarning = NO;
            aacvc.mode = AAContactViewConrollerNewContactMode;
        } else if ([segue.identifier isEqualToString:@"callContact"]) {
            if ([sender isKindOfClass:[Contact class]]) {
                Contact* contact = (Contact*)sender;
                aacvc.shouldShowContactNotLinkedWarning = NO;
                aacvc.mode = AAContactViewConrollerCallContactMode;
                aacvc.contact = contact;
            } else {
                ALog(@"<ERROR> Object sent to prepareForSegue was not a contact");
            }
        }
    }
}

- (BOOL)contactViewControllerShouldShowNotLinkedWarningForContact:(Contact*)contact
{
    BOOL contactNeedsLink = [contact.needsABLink boolValue];
    BOOL contactWasSynced = [[AAUserDataManager sharedManager] syncContactWithAssociatedPersonRecord:contact];
    if (!contactNeedsLink && !contactWasSynced) {
        return YES;
    } else {
        return NO;
    }
}


@end
