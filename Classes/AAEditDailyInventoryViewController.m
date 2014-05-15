//
//  AAEditDailyInventoryViewController.m
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "InventoryQuestion+AAAdditions.h"
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

- (NSArray*)questions
{
    if (!_questions) _questions = [[self.dailyInventory.questions allObjects] sortedArrayUsingSelector:@selector(compareQuestionNumber:)];
    return _questions;
}

#pragma mark - UI Events

- (void)yesNoSwitchValueChanged:(UISwitch*)sender
{
    // find the cell that was switched
    // expand its view with additional materials
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (IBAction)saveButtonTapped:(UIBarButtonItem *)sender
{
    // set questions data based on tableViewCells
    for (NSUInteger i = 0; i < AA_DAILY_INVENTORY_QUESTION_COUNT; i++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:i inSection:0];
        AADailyInventoryQuestionTableViewCell* cell = (AADailyInventoryQuestionTableViewCell*)[self.tableView cellForRowAtIndexPath:cellPath];
        
        if ([cell.question.type integerValue] == AADailyInventoryQuestionYesNoType) {
            InventoryQuestion* question = self.questions[i];
            question.yesNoAnswer = [NSNumber numberWithBool:cell.yesNoSwitch.on];
        }
    }
    

    [self.dailyInventory setNotes:self.notesTextView.text];
    [self.dailyInventory setQuestions:[NSSet setWithArray:self.questions]];
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

#pragma mark - UITableView Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // +1 for notes cell
    return AA_DAILY_INVENTORY_QUESTION_COUNT;
}

#define AA_DAILY_INVENTORY_QUESTION_LINE_HEIGHT 21.0f
#define AA_DAILY_INVENTORY_QUESTION_LABEL_INSET 22.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < AA_DAILY_INVENTORY_QUESTION_COUNT) {
        CGFloat height = ([self numLinesForQuestionCellAtIndexPath:indexPath] * AA_DAILY_INVENTORY_QUESTION_LINE_HEIGHT) +
                            AA_DAILY_INVENTORY_QUESTION_LABEL_INSET;
        return height;
    } else {
        return 144.0f;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.notesTextView resignFirstResponder];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InventoryQuestion* question = self.questions[indexPath.row];
        
//    if ([question.type integerValue] == AADailyInventoryQuestionYesNoType) {
        return [self yesNoQuestionTableViewCellForIndexPath:indexPath];
//    } else {
//        return [self descriptionQuestionTableViewCellForIndexPath:indexPath];
//    }
}

- (UITableViewCell*)yesNoQuestionTableViewCellForIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"YesNoQuestionCell"];

    // set up cell's UI
    if ([cell isKindOfClass:[AADailyInventoryQuestionTableViewCell class]]) {
        AADailyInventoryQuestionTableViewCell* diqtvc = (AADailyInventoryQuestionTableViewCell*)cell;
        InventoryQuestion* question = self.questions[indexPath.row];
        diqtvc.question = question;
        diqtvc.yesNoSwitch.on = [question.yesNoAnswer boolValue];
        diqtvc.questionTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        diqtvc.questionTextLabel.numberOfLines = [self numLinesForQuestionCellAtIndexPath:indexPath];
        
        [diqtvc.yesNoSwitch addTarget:self action:@selector(yesNoSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return cell;
}

- (UITableViewCell*)descriptionQuestionTableViewCellForIndexPath:(NSIndexPath*)indexPath
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
    InventoryQuestion* question = self.questions[indexPath.row];

    return (question.questionText.length / 31) + 1;
}

@end
