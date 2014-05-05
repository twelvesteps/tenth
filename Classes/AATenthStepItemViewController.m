//
//  AATenthStepItemViewController.m
//  Steps
//
//  Created by Tom on 5/4/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AATenthStepItemViewController.h"

@interface AATenthStepItemViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tenthStepItemTitle;
@property (weak, nonatomic) IBOutlet UITextView *tenthStepItemText;

@end

@implementation AATenthStepItemViewController

- (AATenthStepItem*)item
{
    if (!_item) _item = [[AATenthStepItem alloc] init];
    return _item;
}

- (IBAction)confirmEditButtonTapped:(UIBarButtonItem *)sender {

    
    if ([sender isEqual:self.navigationItem.rightBarButtonItem]) {
        self.item.title =       self.tenthStepItemTitle.text;
        self.item.description = self.tenthStepItemText.text;
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
    self.tenthStepItemTitle.text =  self.item.title;
    self.tenthStepItemText.text =   self.item.description;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
