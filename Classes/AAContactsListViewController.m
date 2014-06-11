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

@interface AAContactsListViewController () < ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
    return [[AAUserDataManager sharedManager] fetchUserAAContacts];
}


#pragma mark - UI Events

- (IBAction)addContactButtonPressed:(UIBarButtonItem *)sender
{
    [self showAddContactActionSheet];
}

- (void)showAddContactActionSheet
{
    UIActionSheet* addContactSheet = [[UIActionSheet alloc] initWithTitle:@"Add Contact"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Create New Contact",
                                                                          @"Import Existing Contact", nil];
    [addContactSheet showInView:self.view];
}

- (void)showPeoplePickerViewController
{
    ABPeoplePickerNavigationController* picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"Add Contact"]) {
        [self addContactActionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)addContactActionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Create New Contact"]) {
        [self performSegueWithIdentifier:@"newContact" sender:nil];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Import Existing Contact"]) {
        [self showPeoplePickerViewController];
    }
}


#pragma mark - Peoplepicker Delegate

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    
    Contact* contact = [[AAUserDataManager sharedManager] fetchContactForPersonRecord:person];
    
    if (!contact) { // person record not stored
        contact = [[AAUserDataManager sharedManager] createContactWithPersonRecord:person];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self performSegueWithIdentifier:@"setContact" sender:contact];
    
    [self.tableView reloadData];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Personview Delegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    return YES;
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
        [self.tableView reloadData];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[AAContactViewController class]]) {
        AAContactViewController* aacvc = (AAContactViewController*)segue.destinationViewController;
        
        if ([segue.identifier isEqualToString:@"setContact"]) {
            if ([sender isKindOfClass:[UITableViewCell class]]) {
                // user selected contact from tableview
                UITableViewCell* cell = (UITableViewCell*)sender;
                NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
                aacvc.contact = self.contacts[indexPath.row];
                aacvc.newContact = NO;
            } else if ([sender isKindOfClass:[Contact class]]) {
                // user selected contact from people picker
                aacvc.contact = (Contact*)sender;
                aacvc.newContact = NO;
            }
        } else if ([segue.identifier isEqualToString:@"newContact"]) {
            aacvc.newContact = YES;
        }
    }
}


@end
