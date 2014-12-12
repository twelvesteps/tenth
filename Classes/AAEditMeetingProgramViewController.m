//
//  AAEditMeetingProgramViewController.m
//  Steps
//
//  Created by Tom on 12/8/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingProgramViewController.h"

@interface AAEditMeetingProgramViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;

@end

@implementation AAEditMeetingProgramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (AAMeetingProgram)program
{
    return (AAMeetingProgram)self.selectedIndexPath.row;
}

- (void)setProgram:(AAMeetingProgram)program
{
    self.selectedIndexPath = [NSIndexPath indexPathForRow:(NSInteger)program inSection:0];
}


#pragma mark - Tableview Delegate and Datasource

#define PROGRAM_CELL_REUSE_ID

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingProgramCell"];
    
    cell.textLabel.text = [Meeting stringForProgram:(AAMeetingProgram)indexPath.row];
    
    if ([indexPath isEqual:self.selectedIndexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self.programDelegate programViewDidSelectProgramType:self];
    [self.tableView reloadData];
}


@end
