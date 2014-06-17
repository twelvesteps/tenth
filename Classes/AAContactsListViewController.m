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

@interface AAContactsListViewController () < ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, AAPopoverListViewDelegate>

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

#define POPOVER_VIEW_HORIZONTAL_INSET   27.0f
#define POPOVER_VIEW_VERTICAL_INSET     5.0f
#define POPOVER_VIEW_TRIANGLE_INSET     5.0f
#define POPOVER_VIEW_WIDTH              200.0f
#define POPOVER_VIEW_HEIGHT             93.0f

- (IBAction)showAddContactPopoverList:(UIBarButtonItem*)sender
{
    CGPoint triangleOrigin = CGPointMake(self.view.bounds.origin.x + POPOVER_VIEW_HORIZONTAL_INSET,
                                         CGRectGetMaxY(self.navigationController.navigationBar.frame) + POPOVER_VIEW_VERTICAL_INSET);
    CGRect popoverFrame = CGRectMake(self.view.bounds.origin.x + POPOVER_VIEW_TRIANGLE_INSET,
                                     CGRectGetMaxY(self.navigationController.navigationBar.frame) + POPOVER_VIEW_VERTICAL_INSET,
                                     POPOVER_VIEW_WIDTH,
                                     POPOVER_VIEW_HEIGHT);
    NSArray* titles = @[NSLocalizedString(@"Import Existing Contact", @"Import Existing Contact from phone's address book"),
                        NSLocalizedString(@"Create New Contact", @"Create New Contact and add to phone's address book")];
    AAPopoverListView* addContactPopoverView = [[AAPopoverListView alloc] initWithFrame:popoverFrame
                                                                     withTriangleOrigin:triangleOrigin
                                                                           buttonTitles:titles];

    addContactPopoverView.title = @"addContactPopover";
    
    [self showPopoverList:addContactPopoverView];
}

- (IBAction)showCallContactPopoverList:(UIBarButtonItem*)sender
{
    CGPoint triangleOrigin = CGPointMake(CGRectGetMaxX(self.view.bounds) - POPOVER_VIEW_HORIZONTAL_INSET,
                                         CGRectGetMaxY(self.navigationController.navigationBar.frame) + POPOVER_VIEW_VERTICAL_INSET);
    CGRect popoverFrame = CGRectMake(CGRectGetMaxX(self.view.bounds) - (POPOVER_VIEW_WIDTH + POPOVER_VIEW_TRIANGLE_INSET),
                                     CGRectGetMaxY(self.navigationController.navigationBar.frame) + POPOVER_VIEW_VERTICAL_INSET,
                                     POPOVER_VIEW_WIDTH,
                                     POPOVER_VIEW_HEIGHT);
    NSArray* titles = @[NSLocalizedString(@"Call Sponsor", @"Call user's AA sponsor"),
                        NSLocalizedString(@"Call Random Contact", @"Call a random contact from the list")];
    AAPopoverListView* callContactPopoverView = [[AAPopoverListView alloc] initWithFrame:popoverFrame
                                                                     withTriangleOrigin:triangleOrigin
                                                                           buttonTitles:titles];
    
    callContactPopoverView.title = @"callContactPopover";
    
    [self showPopoverList:callContactPopoverView];
}

- (void)showPopoverList:(AAPopoverListView*)popoverView
{
    // grab the title of the presented popover if it exists
    // and dismiss the popover
    NSString* currentPopoverTitle = self.popoverView.title;
    if (self.popoverView) {

        [self animatePopoverViewFadeOut:self.popoverView];
        self.popoverView = nil;
    }
    
    // user tapped bar button twice, dismiss popover
    if (![popoverView.title isEqualToString:currentPopoverTitle]) {
        popoverView.delegate = self;
        popoverView.alpha = 0.0f;
        self.popoverView = popoverView;
        [self.view addSubview:popoverView];
        self.tableView.userInteractionEnabled = NO;
        
        [self animatePopoverViewFadeIn:popoverView];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.popoverView) {
        [self hidePopoverView:nil];
    }
}

#define POPOVER_ANIMATION_DURATION  0.2f
- (void)animatePopoverViewFadeIn:(AAPopoverListView*)popoverView
{
    [UIView animateWithDuration:POPOVER_ANIMATION_DURATION animations:^{
        popoverView.alpha = 1.0f;
    }];
}

- (void)animatePopoverViewFadeOut:(AAPopoverListView*)popoverView
{
    [UIView animateWithDuration:POPOVER_ANIMATION_DURATION animations:^{
        popoverView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popoverView removeFromSuperview];
    }];
}

- (void)hidePopoverView:(UIGestureRecognizer*)recognizer
{
    [self animatePopoverViewFadeOut:self.popoverView];
    self.popoverView = nil;
    self.tableView.userInteractionEnabled = YES;
}

- (void)showPeoplePickerViewController
{
    ABPeoplePickerNavigationController* picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - GestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self hidePopoverView:gestureRecognizer];
    return NO;
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

#pragma mark - AAPopoverListView Delegate

- (void)popoverView:(AAPopoverListView *)pv buttonTappedAtIndex:(NSInteger)index
{
    if ([pv.title isEqualToString:@"addContactPopover"]) {
        [self addContactPopoverView:pv buttonTappedAtIndex:index];
    }
    
    [pv removeFromSuperview];
}

- (void)addContactPopoverView:(AAPopoverListView*)pv buttonTappedAtIndex:(NSInteger)index
{
    if ([[pv buttonTitleAtIndex:index] isEqualToString:NSLocalizedString(@"Create New Contact", @"Import Existing Contact from phone's address book")]) {
        [self performSegueWithIdentifier:@"newContact" sender:nil];
    } else if ([[pv buttonTitleAtIndex:index] isEqualToString:NSLocalizedString(@"Import Existing Contact", @"Create New Contact and add to phone's address book")]) {
        [self showPeoplePickerViewController];
    }
}

- (void)callConactPopoverView:(AAPopoverListView*)pv buttonTappedAtIndex:(NSInteger)index
{
    
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
