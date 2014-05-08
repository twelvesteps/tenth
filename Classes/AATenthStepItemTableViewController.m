//
//  AATenthStepItemTableViewController.m
//  Steps
//
//  Created by Tom on 5/8/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AATenthStepItemTableViewController.h"

@interface AATenthStepItemTableViewController ()

@property (weak, nonatomic) IBOutlet UITextView *whoText;
@property (weak, nonatomic) IBOutlet UITextView *whatText;
@property (weak, nonatomic) IBOutlet UITextView *defectText;
@property (weak, nonatomic) IBOutlet UITextView *ammendsText;

@end

@implementation AATenthStepItemTableViewController

- (AATenthStepItem*)item
{
    if (!_item) _item = [[AATenthStepItem alloc] init];
    return _item;
}


- (IBAction)confirmEditButtonTapped:(UIBarButtonItem *)sender {
    
    
    if ([sender isEqual:self.navigationItem.rightBarButtonItem]) {
        [self populateItemData];
        [self.delegate viewController:self didExitWithAction:AAStepItemEditActionSaved];
    } else {
        [self.delegate viewController:self didExitWithAction:AAStepItemEditActionCancelled];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.navigationItem.title = @"Tenth Step";
    
    if (self.item) [self populateCellData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(confirmEditButtonTapped:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (void)populateCellData
{
    self.whoText.text =     self.item.person;
    self.whatText.text =    self.item.itemDescription;
    self.defectText.text =  self.item.characterDefect;
    self.ammendsText.text = self.item.ammends;
}

- (void)populateItemData
{
    self.item.person = self.whoText.text;
    self.item.itemDescription = self.whatText.text;
    self.item.characterDefect = self.defectText.text;
    self.item.ammends = self.ammendsText.text;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
