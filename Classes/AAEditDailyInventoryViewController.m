//
//  AAEditDailyInventoryViewController.m
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "InventoryQuestion+AAAdditions.h"
#import "AAEditDailyInventoryViewController.h"
#import "AADailyInventoryYesNoQuestionTableViewCell.h"
#import "AADailyInventoryDescriptiveQuestionTableViewCell.h"
#import "AACallButton.h"
#import "AAUserDataManager.h"

@interface AAEditDailyInventoryViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, AADailyInventoryYesNoQuestionTableViewCellDelegate>

@property (nonatomic) BOOL showCallButtons;
@property (strong, nonatomic) NSArray* questions;
@property (weak, nonatomic) UITextView* descriptiveQuestionTextView;
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
    
    // respond to keyboard appearance by scrolling tableview
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

- (void)updateDailyInventory
{
    for (NSUInteger i = 0; i < AA_DAILY_INVENTORY_QUESTION_COUNT; i++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:i inSection:0];
        InventoryQuestion* question = self.questions[i];
        
        if ([question.type integerValue] == AADailyInventoryQuestionYesNoType) {
            AADailyInventoryYesNoQuestionTableViewCell* cell = (AADailyInventoryYesNoQuestionTableViewCell*)[self.tableView cellForRowAtIndexPath:cellPath];
            question.yesNoAnswer = [NSNumber numberWithBool:cell.yesNoSwitch.on];
        } else {
            AADailyInventoryDescriptiveQuestionTableViewCell* cell = (AADailyInventoryDescriptiveQuestionTableViewCell*)[self.tableView cellForRowAtIndexPath:cellPath];
            question.descriptiveAnswer = cell.answerTextView.text;
        }
    }
    
    [self.dailyInventory setQuestions:[NSSet setWithArray:self.questions]];
}

- (NSArray*)questions
{
    if (!_questions) _questions = [[self.dailyInventory.questions allObjects] sortedArrayUsingSelector:@selector(compareQuestionNumber:)];
    return _questions;
}

#pragma mark - UI Events

- (IBAction)saveButtonTapped:(UIBarButtonItem *)sender
{
    [self updateDailyInventory];
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

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom = 0.0f;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.tableView.contentInset = contentInset;
    }];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - AADailyInventoryYesNoQuestion Delegate and Datasource

- (void)tableViewCellSwitchDidChangeValue:(AADailyInventoryYesNoQuestionTableViewCell *)cell
{
    self.showCallButtons = cell.yesNoSwitch.on;
    
    if (self.showCallButtons) {
        cell.accessoryButtonHeightConstraint.constant = 44.0f;
    } else {
        cell.accessoryButtonHeightConstraint.constant = 0.0f;
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - UITableView Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return AA_DAILY_INVENTORY_QUESTION_COUNT;
}

#define AA_DAILY_INVENTORY_QUESTION_LINE_HEIGHT         21.0f
#define AA_DAILY_INVENTORY_QUESTION_LABEL_INSET         22.0f
#define AA_DAILY_INVENTORY_QUESTION_TEXT_VIEW_HEIGHT    92.0f
#define AA_DAILY_INVENTORY_CALL_BUTTON_HEIGHT           44.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InventoryQuestion* question = (InventoryQuestion*)self.questions[indexPath.row];
    if ([question.type integerValue] == AADailyInventoryQuestionYesNoType) {
        CGFloat height = ([self numLinesForQuestionCellAtIndexPath:indexPath] * AA_DAILY_INVENTORY_QUESTION_LINE_HEIGHT) +
        AA_DAILY_INVENTORY_QUESTION_LABEL_INSET;
        
        if ([question.number integerValue] == AA_DAILY_INVENTORY_QUESTION_DISCUSS_QUESTION_INDEX &&
            self.showCallButtons) {
            height += AA_DAILY_INVENTORY_CALL_BUTTON_HEIGHT;
        }
        
        return height;
    } else {
        CGFloat height = ([self numLinesForQuestionCellAtIndexPath:indexPath] * AA_DAILY_INVENTORY_QUESTION_LINE_HEIGHT) + AA_DAILY_INVENTORY_QUESTION_LABEL_INSET + AA_DAILY_INVENTORY_QUESTION_TEXT_VIEW_HEIGHT;
        return height;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.descriptiveQuestionTextView resignFirstResponder];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InventoryQuestion* question = self.questions[indexPath.row];
        
    if ([question.type integerValue] == AADailyInventoryQuestionYesNoType) {
        return [self yesNoQuestionTableViewCellForIndexPath:indexPath];
    } else {
        return [self descriptionQuestionTableViewCellForIndexPath:indexPath];
    }
}

- (UITableViewCell*)yesNoQuestionTableViewCellForIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"YesNoQuestionCell"];

    // set up cell's UI
    if ([cell isKindOfClass:[AADailyInventoryQuestionTableViewCell class]]) {
        AADailyInventoryYesNoQuestionTableViewCell* diynqtvc = (AADailyInventoryYesNoQuestionTableViewCell*)cell;
        InventoryQuestion* question = self.questions[indexPath.row];
        
        [self setupYesNoQuestionTableViewCell:diynqtvc withQuestion:question];
        // index path needed to find numberOfLines
        diynqtvc.questionTextLabel.numberOfLines = [self numLinesForQuestionCellAtIndexPath:indexPath];
    }
    
    return cell;
}

- (void)setupYesNoQuestionTableViewCell:(AADailyInventoryYesNoQuestionTableViewCell*)cell withQuestion:(InventoryQuestion*)question
{
    cell.question = question;
    cell.yesNoSwitch.on = [question.yesNoAnswer boolValue];
    cell.questionTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.delegate = self;

    if (question.yesNoAnswer && [question.number integerValue] == AA_DAILY_INVENTORY_QUESTION_DISCUSS_QUESTION_INDEX) {
        [self showCallButtonsForCell:cell];
    } else {
        [self hideCallButtonsForCell:cell];
    }
}

- (void)hideCallButtonsForCell:(AADailyInventoryYesNoQuestionTableViewCell*)cell
{
    for (AACallButton* button in cell.callButtons) {
        button.hidden = YES;
    }
    cell.accessoryButtonHeightConstraint.constant = 0.0f;
}

- (void)showCallButtonsForCell:(AADailyInventoryYesNoQuestionTableViewCell*)cell
{
    for (AACallButton* button in cell.callButtons) {
        button.hidden = NO;
    }
    cell.accessoryButtonHeightConstraint.constant = AA_DAILY_INVENTORY_CALL_BUTTON_HEIGHT;
}

- (UITableViewCell*)descriptionQuestionTableViewCellForIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"DescriptiveQuestionCell"];
    
    if ([cell isKindOfClass:[AADailyInventoryDescriptiveQuestionTableViewCell class]]) {
        AADailyInventoryDescriptiveQuestionTableViewCell* didqtvc = (AADailyInventoryDescriptiveQuestionTableViewCell*)cell;
        InventoryQuestion* question = self.questions[indexPath.row];
        self.descriptiveQuestionTextView = didqtvc.answerTextView;
        didqtvc.answerTextView.delegate = self;
        didqtvc.answerTextView.text = question.descriptiveAnswer;
        didqtvc.answerTextView.contentInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
        didqtvc.questionTextLabel.text = question.questionText;
    }
    
    return cell;
}

- (NSUInteger)numLinesForQuestionCellAtIndexPath:(NSIndexPath*)indexPath
{
    InventoryQuestion* question = self.questions[indexPath.row];

    return (question.questionText.length / 31) + 1;
}

@end
