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
#import "AAItemManager.h"

#define AA_ITEM_VIEW_SEGUE_ID   @"setItem"
#define AA_TENTH_STEP_CELL_ID   @"tenthStepItem"
#define AA_TENTH_STEP_ITEMS     @"tenthStepItems"
@interface AATenthStepTableViewController () <AATenthStepItemViewControllerDelegate>

@property (strong, nonatomic) NSIndexPath* selectedItemIndexPath;
@property (strong, nonatomic) NSArray* tenthStepItems;

@end

@implementation AATenthStepTableViewController

- (NSArray*)tenthStepItems
{
    if (!_tenthStepItems) {
        _tenthStepItems = [[AAItemManager sharedItemManager] getItemsForStep:10];
        [self.tableView reloadData];
    }
    return _tenthStepItems;
}

- (void)removeTenthStepItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSMutableArray* mutableTenthStepItems = [self.tenthStepItems mutableCopy];
    [mutableTenthStepItems removeObjectAtIndex:indexPath.row];
    self.tenthStepItems = [mutableTenthStepItems copy];
    
    [[AAItemManager sharedItemManager] updateStepItemsForStep:10 withItems:self.tenthStepItems];
}

- (void)saveTenthStepItem:(AATenthStepItem*)item
{
    NSMutableArray* mutableTenthStepItems = [self.tenthStepItems mutableCopy];
    
    if (self.selectedItemIndexPath) {
        mutableTenthStepItems[self.selectedItemIndexPath.row] = item;
        self.selectedItemIndexPath = nil;
    } else {
        [mutableTenthStepItems addObject:item];
    }
    
    self.tenthStepItems = [mutableTenthStepItems copy];
    [[AAItemManager sharedItemManager] updateStepItemsForStep:10 withItems:self.tenthStepItems];
    [self.tableView reloadData];
}

#pragma mark - UI Events
- (IBAction)addButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:AA_ITEM_VIEW_SEGUE_ID sender:sender];
}

#pragma mark - Item view delegate
-(void)viewController:(AATenthStepItemViewController *)vc didExitWithAction:(AAStepItemEditAction)action
{
    if (action == AAStepItemEditActionSaved)
        [self saveTenthStepItem:vc.item];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tenthStepItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AA_TENTH_STEP_CELL_ID forIndexPath:indexPath];
    AATenthStepItem* item = self.tenthStepItems[indexPath.row];
    
    cell.textLabel.text = item.itemTitle;
    
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
            if ([sender isKindOfClass:[UITableViewCell class]]) {
                UITableViewCell* cell = (UITableViewCell*)sender;
                NSIndexPath* cellIndexPath = [self.tableView indexPathForCell:cell];
                AATenthStepItem* item = self.tenthStepItems[cellIndexPath.row];
                ivc.item = item;
                self.selectedItemIndexPath = cellIndexPath;
            } else {
                self.selectedItemIndexPath = nil;
            }
            
            ivc.delegate = self;
        }
    }
}

@end
