//
//  AATenthStepTableViewController.m
//  Steps
//
//  Created by Tom on 5/4/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AATenthStepTableViewController.h"
#import "AATenthStepItemViewController.h"
#import "AATenthStepItem.h"

#define AA_ITEM_VIEW_SEGUE_ID   @"setItem"
#define AA_TENTH_STEP_CELL_ID   @"tenthStepItem"
#define AA_TENTH_STEP_ITEMS     @"tenthStepItems"
@interface AATenthStepTableViewController () <AATenthStepItemViewControllerDelegate>

@property (strong, nonatomic) NSIndexPath* selectedItemIndexPath;

@end

@implementation AATenthStepTableViewController

- (NSArray*)getTenthStepItems
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* tenthStepItems = [defaults objectForKey:AA_TENTH_STEP_ITEMS];
    
    if (!tenthStepItems) {
        tenthStepItems = [[NSArray alloc] init];
        [defaults setObject:tenthStepItems forKey:AA_TENTH_STEP_ITEMS];
    }
    
    return tenthStepItems;
}

- (AATenthStepItem*)getTenthStepItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray* tenthStepItems = [self getTenthStepItems];
    NSData* encodedItem = [tenthStepItems objectAtIndex:indexPath.row];
    AATenthStepItem* item = [NSKeyedUnarchiver unarchiveObjectWithData:encodedItem];
    
    return item;
}

- (void)removeTenthStepItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSMutableArray* tenthStepItems = [[self getTenthStepItems] mutableCopy];
    
    [tenthStepItems removeObjectAtIndex:indexPath.row];
    
    [self setTenthStepItems:tenthStepItems];
}

- (void)saveTenthStepItem:(AATenthStepItem*)item
{
    NSMutableArray* tenthStepItems = [[self getTenthStepItems] mutableCopy];
    NSData* encodedItem = [NSKeyedArchiver archivedDataWithRootObject:item];
    if (self.selectedItemIndexPath) {
        [tenthStepItems removeObjectAtIndex:self.selectedItemIndexPath.row];
        [tenthStepItems insertObject:encodedItem atIndex:self.selectedItemIndexPath.row];
    } else {
        [tenthStepItems addObject:encodedItem];
    }
    
    [self setTenthStepItems:tenthStepItems];
    [self.tableView reloadData];
}

- (void)setTenthStepItems:(NSArray*)tenthStepItems
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:tenthStepItems forKey:AA_TENTH_STEP_ITEMS];
    [defaults synchronize];
}

#pragma mark - UI Events
- (IBAction)addButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:AA_ITEM_VIEW_SEGUE_ID sender:sender];
}

#pragma mark - Item view delegate
-(void)viewControllerDidSave:(AATenthStepItemViewController*)vc
{
    [self saveTenthStepItem:vc.item];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self getTenthStepItems] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AA_TENTH_STEP_CELL_ID forIndexPath:indexPath];
    AATenthStepItem* item = [self getTenthStepItemAtIndexPath:indexPath];
    
    cell.textLabel.text = item.title;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeTenthStepItemAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"User selected an undefined edit action in table view\n");
    }
    
    [self.tableView reloadData];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:AA_ITEM_VIEW_SEGUE_ID]) {
        if ([segue.destinationViewController isKindOfClass:[AATenthStepItemViewController class]]) {
            AATenthStepItemViewController* ivc = (AATenthStepItemViewController*) segue.destinationViewController;
            AATenthStepItem* item = nil;
            if ([sender isKindOfClass:[UITableViewCell class]]) {
                UITableViewCell* cell = (UITableViewCell*)sender;
                NSIndexPath* cellIndexPath = [self.tableView indexPathForCell:cell];
                item = [self getTenthStepItemAtIndexPath:cellIndexPath];
                self.selectedItemIndexPath = cellIndexPath;
            } else {
                item = [[AATenthStepItem alloc] init];
                self.selectedItemIndexPath = nil;
            }
            
            ivc.delegate = self;
            ivc.item = item;
        }
    }
}

@end
