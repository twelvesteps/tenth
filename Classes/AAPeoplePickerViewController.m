//
//  AAPeoplePickerViewController.m
//  Steps
//
//  Created by tom on 7/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAPeoplePickerViewController.h"
#import "AAUserDataManager.h"
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
    if (!_people) _people = [[AAUserDataManager sharedManager] fetchPersonRecords];
    return _people;
}

- (NSMutableArray*)selectedPeople
{
    if (!_selectedPeople) _selectedPeople = [[NSMutableArray alloc] init];
    return _selectedPeople;
}

#pragma mark - UIEvents

- (void)cancelButtonTapped:(UIBarButtonItem*)sender
{
    [self.peoplePickerDelegate peoplePickerNavigationControllerDidCancel:self];
}

- (void)doneButtonTapped:(UIBarButtonItem*)sender
{
    [self.peoplePickerDelegate peoplePickerNavigationController:self didSelectPeople:[self.selectedPeople copy]];
}

#pragma mark - UITableView Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    ABRecordRef selectedPerson = (__bridge ABRecordRef)self.people[indexPath.row];
    Contact* selectedContact = [[AAUserDataManager sharedManager] createContactWithPersonRecord:selectedPerson];
    
    [self.selectedPeople addObject:selectedContact];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    ABRecordRef selectedPerson = (__bridge ABRecordRef)self.people[indexPath.row];
    Contact* selectedContact = [[AAUserDataManager sharedManager] fetchContactForPersonRecord:selectedPerson];
    
    [self.selectedPeople removeObject:selectedContact];
    [[AAUserDataManager sharedManager] removeAAContact:selectedContact];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.people.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonCell"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonCell"];
    }
    
    ABRecordRef person = (__bridge ABRecordRef)(self.people[indexPath.row]);
    
#warning not localizable
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString* name = firstName;
    
    if (lastName) {
        name = [name stringByAppendingFormat:@" %@", lastName];
    }
    
    cell.textLabel.text = name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell.selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

@end
