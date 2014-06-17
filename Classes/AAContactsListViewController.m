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
#import "AAPopoverListView.h"

@interface AAContactsListViewController () < ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, AAPopoverListViewDelegate>

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

//- (IBAction)addContactButtonPressed:(UIBarButtonItem *)sender
//{
//    [self showAddContactActionSheet];
//}

//- (void)showAddContactActionSheet
//{
//    UIActionSheet* addContactSheet = [[UIActionSheet alloc] initWithTitle:@"Add Contact"
//                                                                 delegate:self
//                                                        cancelButtonTitle:@"Cancel"
//                                                   destructiveButtonTitle:nil
//                                                        otherButtonTitles:@"Create New Contact",
//                                                                          @"Import Existing Contact", nil];
//    [addContactSheet showInView:self.view];
//}

- (IBAction)showAddContactPopoverList:(UIBarButtonItem*)sender
{
    CGPoint triangleOrigin = CGPointMake(self.view.bounds.origin.x + 20.0f,
                                         CGRectGetMaxY(self.navigationController.navigationBar.frame) + 5.0f);
    CGRect popoverFrame = CGRectMake(self.view.bounds.origin.x + 5.0f,
                                     CGRectGetMaxY(self.navigationController.navigationBar.frame) + 5.0f,
                                     200.0f,
                                     93.0f);
    NSArray* titles = @[NSLocalizedString(@"Import Existing Contact", @"Import Existing Contact from phone's address book"),
                        NSLocalizedString(@"Create New Contact", @"Create New Contact and add to phone's address book")];
    AAPopoverListView* addContactPopoverView = [[AAPopoverListView alloc] initWithFrame:popoverFrame
                                                                     withTriangleOrigin:triangleOrigin
                                                                           buttonTitles:titles];
    
    addContactPopoverView.title = @"addContactPopover";
    addContactPopoverView.delegate = self;
    [self.view addSubview:addContactPopoverView];
}

- (void)showPeoplePickerViewController
{
    ABPeoplePickerNavigationController* picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - UIActionSheet Delegate
//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if ([actionSheet.title isEqualToString:@"Add Contact"]) {
//        [self addContactActionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
//    }
//    
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//}

//- (void)addContactActionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//
//}


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

#pragma mark - AAPopoverListView Delegate

- (void)popoverView:(AAPopoverListView *)pv buttonTappedAtIndex:(NSInteger)index
{
    if ([pv.title isEqualToString:@"addContactPopover"]) {
        [self addContactPopoverView:pv buttonTappedAtIndex:index];
    }
}

- (void)addContactPopoverView:(AAPopoverListView*)pv buttonTappedAtIndex:(NSInteger)index
{
    if ([[pv buttonTitleAtIndex:index] isEqualToString:NSLocalizedString(@"Create New Contact", @"Import Existing Contact from phone's address book")]) {
        [self performSegueWithIdentifier:@"newContact" sender:nil];
    } else if ([[pv buttonTitleAtIndex:index] isEqualToString:NSLocalizedString(@"Import Existing Contact", @"Create New Contact and add to phone's address book")]) {
        [self showPeoplePickerViewController];
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
