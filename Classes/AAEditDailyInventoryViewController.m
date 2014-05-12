//
//  AAEditDailyInventoryViewController.m
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditDailyInventoryViewController.h"
#import "AADailyInventoryQuestionTableViewCell.h"
#import "AAUserDataManager.h"

@interface AAEditDailyInventoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL newDailyInventory;
@property (strong, nonatomic) NSArray* questions;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AAEditDailyInventoryViewController

#pragma mark - View Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set delegates
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // add custom cancel button navigation bar
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

#pragma mark - Properties

- (DailyInventory*)dailyInventory
{
    if (!_dailyInventory) {
        _dailyInventory = [[AAUserDataManager sharedManager] createDailyInventory];
        self.newDailyInventory = YES;
    }
    return _dailyInventory;
}

- (NSArray*)questions
{
    if (!_questions) _questions = [AADailyInventoryQuestion questionsForAnswerCode:[self.dailyInventory.answers integerValue]];
    return _questions;
}

#pragma mark - UI Events

- (IBAction)saveButtonTapped:(UIBarButtonItem *)sender
{
    // set questions data based on tableViewCells
    for (NSUInteger i = 0; i < AA_DAILY_INVENTORY_QUESTIONS_COUNT; i++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:i inSection:0];
        AADailyInventoryQuestionTableViewCell* cell = (AADailyInventoryQuestionTableViewCell*)[self.tableView cellForRowAtIndexPath:cellPath];
        cell.question.answer = cell.yesNoSwitch.on;
    }
    
    AADailyInventoryQuestionsAnswerCode answers = [AADailyInventoryQuestion answerCodeForQuestions:self.questions];
    [self.dailyInventory setAnswers:[NSNumber numberWithInteger:answers]];
    
    [self.delegate viewController:self didEditDailyInventory:self.dailyInventory];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelButtonTapped:(UIBarButtonItem*)sender
{
    if (self.newDailyInventory)
        [[AAUserDataManager sharedManager] deleteDailyInventory:self.dailyInventory];
    
    [self.delegate viewController:self didEditDailyInventory:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return AA_DAILY_INVENTORY_QUESTIONS_COUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self numLinesForQuestionCellAtIndexPath:indexPath] + 1) * 22.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    // determine type of cell based on index path
    if (indexPath.row <= AA_DAILY_INVENTORY_QUESTIONS_COUNT) cell = [self questionTableViewCellForIndexPath:indexPath];
    
    
    return cell;
}

- (UITableViewCell*)questionTableViewCellForIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"YesNoQuestionCell"];

    // set up cell's UI
    if ([cell isKindOfClass:[AADailyInventoryQuestionTableViewCell class]]) {
        AADailyInventoryQuestionTableViewCell* diqtvc = (AADailyInventoryQuestionTableViewCell*)cell;
        AADailyInventoryQuestion* question = self.questions[indexPath.row];
        diqtvc.question = question;
        diqtvc.yesNoSwitch.on = question.answer;
        diqtvc.questionTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        diqtvc.questionTextLabel.numberOfLines = [self numLinesForQuestionCellAtIndexPath:indexPath];
    }
    
    return cell;
}

- (NSUInteger)numLinesForQuestionCellAtIndexPath:(NSIndexPath*)indexPath
{
    AADailyInventoryQuestion* question = self.questions[indexPath.row];

    return (question.questionText.length / 31) + 1;
}

@end
