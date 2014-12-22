//
//  AAEditMeetingProgramViewController.m
//  Steps
//
//  Created by Tom on 12/8/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingProgramViewController.h"
#import "AAUserMeetingsManager.h"
#import "MeetingProgram.h"

@interface AAEditMeetingProgramViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;

@property (strong, nonatomic) NSArray* meetingPrograms;

@end

@implementation AAEditMeetingProgramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray*)meetingPrograms
{
    if (!_meetingPrograms) {
        _meetingPrograms = [[AAUserMeetingsManager sharedManager] fetchMeetingPrograms];
    }
    
    return _meetingPrograms;
}

- (MeetingProgram*)program
{
    return [self.meetingPrograms objectAtIndex:self.selectedIndexPath.row];
}

- (void)setProgram:(MeetingProgram*)program
{
    if (program) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:[self.meetingPrograms indexOfObject:program] inSection:0];
    } else {
        self.selectedIndexPath = nil;
    }
}


#pragma mark - Tableview Delegate and Datasource

#define PROGRAM_CELL_REUSE_ID

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.meetingPrograms.count;
}

- (AASeparatorTableViewCell*)separatorCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AASeparatorTableViewCell* cell = (AASeparatorTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"MeetingProgramCell"];
    
    MeetingProgram* program = [self.meetingPrograms objectAtIndex:indexPath.row];
    cell.textLabel.text = program.localizedTitle;
    
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
