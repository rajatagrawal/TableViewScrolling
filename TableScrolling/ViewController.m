//
//  ViewController.m
//  TableScrolling
//
//  Created by Rajat Agrawal on 24/05/18.
//  Copyright © 2018 Hike. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+Scrolling.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *scrollButton;
@property (strong, nonatomic) UITextField *chatTextField;
@property (strong, nonatomic) UIView *viewB;
@property (strong, nonatomic) UIStackView *bottomStackView;

@property (nonatomic, strong) NSLayoutConstraint *bottomStackViewBottomConstraint;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupTableView];
    [self setupChatTextField];
    [self setupViewB];
    [self setupBottomStackView];
    self.scrollButton.selected = YES;
    
    [self.bottomStackView insertArrangedSubview:self.viewB atIndex:0];
    [self.bottomStackView insertArrangedSubview:self.chatTextField atIndex:1];
    self.viewB.alpha = 0;

    [self.view layoutIfNeeded];
    NSLog(@"stack view height is %lf", self.bottomStackView.frame.size.height);
    [self.tableView scrollUpByHeight:self.chatTextField.frame.size.height];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)scrollAction:(UIButton *)sender {
    NSLog(@"Table view content size is %lf", self.tableView.contentSize.height);
    if (!sender.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            self.chatTextField.alpha = 1;
            [self.tableView scrollUpByHeight:self.chatTextField.frame.size.height];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [self.tableView scrollDownByHeight:self.chatTextField.frame.size.height];
            self.chatTextField.alpha = 0;
        }];
    }
    
    sender.selected = !sender.selected;
    NSLog(@"Button selected is %ld and bottom stack frame size is %lf", sender.selected, self.bottomStackView.frame.size.height);
}

- (IBAction)viewBAction:(UIButton *)sender {
    if (!sender.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.tableView scrollUpByHeight:self.viewB.frame.size.height];
            self.viewB.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [self.tableView scrollDownByHeight:self.viewB.frame.size.height];
            self.viewB.alpha = 0;
        }];
    }
    sender.selected = !sender.selected;
}


- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.bottomStackViewBottomConstraint.constant = self.bottomStackViewBottomConstraint.constant - keyboardHeight;
    [self.tableView scrollUpByHeight:keyboardHeight];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.bottomStackViewBottomConstraint.constant = self.bottomStackViewBottomConstraint.constant + keyboardHeight;
    NSLog(@"Keyboard height during hide is %lf", keyboardHeight);
    [self.tableView scrollDownByHeight:keyboardHeight];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.chatTextField resignFirstResponder];
    return YES;
}

- (void)setupChatTextField {
    _chatTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    _chatTextField.delegate = self;
    _chatTextField.backgroundColor = UIColor.blueColor;
}

- (void)setupViewB {
    _viewB = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _viewB.backgroundColor = UIColor.orangeColor;
    _viewB.translatesAutoresizingMaskIntoConstraints = NO;
    [_viewB.heightAnchor constraintEqualToConstant:50].active = YES;
}

- (void)setupBottomStackView {
    _bottomStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.bottomStackView];
    
    self.bottomStackView.axis = UILayoutConstraintAxisVertical;
    
    self.bottomStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomStackViewBottomConstraint = [self.bottomStackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    self.bottomStackViewBottomConstraint.active = YES;
    [self.bottomStackView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.bottomStackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"normal_cell"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    footerView.backgroundColor = UIColor.greenColor;
    self.tableView.tableFooterView = footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"normal_cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Title %@", @(indexPath.row)];
    return cell;
    
}

@end
