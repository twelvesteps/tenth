//
//  AAPeoplePickerViewController.m
//  Steps
//
//  Created by tom on 7/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAPeoplePickerViewController.h"
#import "AAUserDataManager.h"
#import "Contact+AAAdditions.h"
#import <QuartzCore/QuartzCore.h>

@interface AAPeoplePickerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UINavigationBar* navBar;
@property (weak, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSArray* people;
@property (strong, nonatomic) NSMutableArray* selectedPeople;

@end

@implementation AAPeoplePickerViewController


#pragma mark - Controller Lifecycle and Properties
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationBar];
    [self setupTableView];
}


#define NAV_BAR_HEIGHT      44.0f

- (void)setupNavigationBar
{
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect navBarRect = CGRectMake(self.view.bounds.origin.x,
                                   self.view.bounds.origin.y,
                                   self.view.bounds.size.width,
                                   NAV_BAR_HEIGHT + statusBarHeight);
    
    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:navBarRect];
    UINavigationItem* navItem = [[UINavigationItem alloc] init];
    [navBar pushNavigationItem:navItem animated:YES];
    
    navBar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [self addBarButtonsToNavItem:navItem];
    
    self.navBar = navBar;
    [self.view addSubview:navBar];
    
}

- (void)addBarButtonsToNavItem:(UINavigationItem*)navItem
{
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    navItem.leftBarButtonItem = cancelButton;
    navItem.rightBarButtonItem = doneButton;
}

- (void)setupTableView
{
    CGFloat navBarMaxY = CGRectGetMaxY(self.navBar.frame);
    CGRect tableViewRect = CGRectMake(self.view.bounds.origin.x,
                                      navBarMaxY,
                                      self.view.bounds.size.width,
                                      self.view.bounds.size.height - navBarMaxY);
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:tableViewRect];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsMultipleSelection = YES;
    
    [self.view insertSubview:tableView belowSubview:self.navBar];
}

- (NSArray*)people
{
    if (!_people) {
        _people = [self partitionPersonRecords:[[AAUserDataManager sharedManager] fetchPersonRecords]];
        
    }
    return _people;
}

- (NSMutableArray*)selectedPeople
{
    if (!_selectedPeople) _selectedPeople = [[NSMutableArray alloc] init];
    return _selectedPeople;
}


#pragma mark - Partition And Organize Contacts

- (NSArray*)partitionPersonRecords:(NSArray*)records
{
    UILocalizedIndexedCollation* collation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray* partitionedRecords = [self emptyPartitioningArrayForCollation:collation];
    
    // partition records
    for (id obj in records) {
        ABRecordRef person = (__bridge ABRecordRef)obj;
        NSString* indexingString = [self indexingStringForPersonRecord:person];
        
        NSInteger section = [collation sectionForObject:indexingString collationStringSelector:@selector(self)];
        NSMutableArray* sectionArray = partitionedRecords[section];
        [sectionArray addObject:(__bridge id)person];
    }
    
    for (NSUInteger i = 0; i < partitionedRecords.count; i++) {
        NSArray* sortedArray = [partitionedRecords[i] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            ABRecordRef person1 = (__bridge ABRecordRef)obj1;
            ABRecordRef person2 = (__bridge ABRecordRef)obj2;
            return [self comparePerson:person1 withPersonInSameSection:person2];
        }];
        
        [partitionedRecords setObject:sortedArray atIndexedSubscript:i];
    }
    
    return [partitionedRecords copy];
}

- (NSString*)indexingStringForPersonRecord:(ABRecordRef)person
{
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString* organizationName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
    
    
    if (ABRecordCopyValue(person, kABPersonKindProperty) == kABPersonKindPerson) {
        if (ABPersonGetSortOrdering() == kABPersonSortByLastName) {
            if (lastName) return lastName;
            if (firstName) return firstName;
        } else {
            if (firstName) return firstName;
            if (lastName) return lastName;
        }
    } else {
        if (organizationName) return organizationName;
    }
    
    ALog(@"<DEBUG> Unable to determine name for contact");
    return nil;
}

- (NSComparisonResult)comparePerson:(ABRecordRef)person withPersonInSameSection:(ABRecordRef)otherPerson
{
    CFComparisonResult result = ABPersonComparePeopleByName(person, otherPerson, ABPersonGetSortOrdering());
    if (result == kCFCompareLessThan) return NSOrderedAscending;
    else if (result == kCFCompareGreaterThan) return NSOrderedDescending;
    else return NSOrderedSame;
}

- (NSMutableArray*)emptyPartitioningArrayForCollation:(UILocalizedIndexedCollation*)collation
{
    NSMutableArray* emptyArray = [[NSMutableArray alloc] initWithCapacity:[collation sectionIndexTitles].count];
    for (NSInteger i = 0; i < [collation sectionIndexTitles].count; i++) {
        [emptyArray addObject:[NSMutableArray array]];
    }
    
    return emptyArray;
}

#pragma mark - UIEvents

- (void)cancelButtonTapped:(UIBarButtonItem*)sender
{
    // objects have been stored in core data
    for (Contact* contact in self.selectedPeople) {
        [[AAUserDataManager sharedManager] removeAAContact:contact];
    }
    
    [self.peoplePickerDelegate peoplePickerNavigationControllerDidCancel:self];
}

- (void)doneButtonTapped:(UIBarButtonItem*)sender
{
    [self.peoplePickerDelegate peoplePickerNavigationController:self didSelectPeople:[self.selectedPeople copy]];
}

#pragma mark - UITableView Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    UILocalizedIndexedCollation* collation = [UILocalizedIndexedCollation currentCollation];
    return [collation sectionForSectionIndexTitleAtIndex:index];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[UILocalizedIndexedCollation currentCollation] sectionTitles][section];
}

- (ABRecordRef)personAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray* peopleInSelectedSection = self.people[indexPath.section];
    ABRecordRef person = (__bridge ABRecordRef)peopleInSelectedSection[indexPath.row];
    
    return person;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    ABRecordRef selectedPerson = [self personAtIndexPath:indexPath];
    Contact* selectedContact = [[AAUserDataManager sharedManager] createContactWithPersonRecord:selectedPerson];
    
    [self.selectedPeople addObject:selectedContact];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    ABRecordRef selectedPerson = [self personAtIndexPath:indexPath];
    Contact* selectedContact = [[AAUserDataManager sharedManager] fetchContactForPersonRecord:selectedPerson];
    
    [self.selectedPeople removeObject:selectedContact];
    [[AAUserDataManager sharedManager] removeAAContact:selectedContact];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* peopleInSection = self.people[section];
    return peopleInSection.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonCell"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonCell"];
    }
    
    ABRecordRef person = [self personAtIndexPath:indexPath];
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyCompositeName(person);
    
    cell.textLabel.text = name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (![self recordShouldBeSelectable:person]) {
        cell.userInteractionEnabled = NO;
        cell.textLabel.enabled = NO;
    }
    
    if (cell.selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (BOOL)recordShouldBeSelectable:(ABRecordRef)person
{
    Contact* contact = [[AAUserDataManager sharedManager] fetchContactForPersonRecord:person];

    // contact has not been added to database
    if (!contact) {
        return YES;
    } else {
        DLog(@"<DEBUG> Contact's Name: %@", [contact fullName]);
    // contact has recently been added by user, should be deselectable
        return [self.selectedPeople containsObject:contact];
    }
}

@end
