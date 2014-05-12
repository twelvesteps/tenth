//
//  AAEditDailyInventoryViewController.m
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditDailyInventoryViewController.h"
#import "AADailyInventoryQuestionTableViewCell.h"
#import "AADailyInventoryNotesTableViewCell.h"
#import "AAUserDataManager.h"

@interface AAEditDailyInventoryViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) NSArray* questions;
@property (weak, nonatomic) UITextView* notesTextView;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

- (DailyInventory*)dailyInventory
{
    if (!_dailyInventory) {
        // dailyInventory was not set by previous controller, create new inventory
        _dailyInventory = [[AAUserDataManager sharedManager] todaysDailyInventory];
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
    [self.dailyInventory setNotes:self.notesTextView.text];
    DLog(@"<DEBUG> notesTextView.text: %@", self.notesTextView.text);
    DLog(@"<DEBUG> inventory.notes: %@", self.dailyInventory.notes);
    
    [self.delegate viewController:self didEditDailyInventory:self.dailyInventory];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonTapped:(UIBarButtonItem*)sender
{
    [self.delegate viewController:self didEditDailyInventory:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextView Delegate and Keyboard Notifications

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom = keyboardHeight;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.tableView.contentInset = contentInset;
    }];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom = 0.0f;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.tableView.contentInset = contentInset;
    }];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

#pragma mark - UITableView Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // +1 for notes cell
    return AA_DAILY_INVENTORY_QUESTIONS_COUNT + 1;
}

#define AA_DAILY_INVENTORY_QUESTION_LINE_HEIGHT 21.0f
#define AA_DAILY_INVENTORY_QUESTION_LABEL_INSET 22.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < AA_DAILY_INVENTORY_QUESTIONS_COUNT) {
        return ([self numLinesForQuestionCellAtIndexPath:indexPath] * AA_DAILY_INVENTORY_QUESTION_LINE_HEIGHT) +
                AA_DAILY_INVENTORY_QUESTION_LABEL_INSET;
    } else {
        return 132.0f;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // determine type of cell based on index path
    if (indexPath.row < AA_DAILY_INVENTORY_QUESTIONS_COUNT)
        return [self questionTableViewCellForIndexPath:indexPath];
    else
        return [self notesTableViewCellForIndexPath:indexPath];
    
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

- (UITableViewCell*)notesTableViewCellForIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InventoryNotesCell"];
    
    if ([cell isKindOfClass:[AADailyInventoryNotesTableViewCell class]]) {
        AADailyInventoryNotesTableViewCell* notesCell = (AADailyInventoryNotesTableViewCell*)cell;
        self.notesTextView = notesCell.notesTextView;
        self.notesTextView.delegate = self;
        self.notesTextView.text = self.dailyInventory.notes;
        self.notesTextView.contentInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
    }
    
    return cell;
}

- (NSUInteger)numLinesForQuestionCellAtIndexPath:(NSIndexPath*)indexPath
{
    AADailyInventoryQuestion* question = self.questions[indexPath.row];

    return (question.questionText.length / 31) + 1;
}

@end
