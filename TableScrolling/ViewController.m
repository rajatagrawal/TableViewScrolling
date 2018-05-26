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
@property (weak, nonatomic) IBOutlet UIView *stickerView;
@property (strong, nonatomic) IBOutlet UITextField *chatTextField;

@property (nonatomic, strong) UIStackView *bottomStackView;
@property (nonatomic, strong) NSLayoutConstraint *bottomStackViewBottomConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"normal_cell"];
    
    [self.scrollButton setTitle:@"Scroll up" forState:UIControlStateNormal];
    [self.scrollButton setTitle:@"Scroll down" forState:UIControlStateSelected];
    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
//    footerView.backgroundColor = UIColor.greenColor;
//    self.tableView.tableFooterView = footerView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupChatTextField];
    [self setupBottomStackView];
    
    [self.view layoutIfNeeded];
    NSLog(@"stack view height is %lf", self.bottomStackView.frame.size.height);
    [self.tableView scrollUpToOffset:self.bottomStackView.frame.size.height];
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

- (IBAction)scrollAction:(UIButton *)sender {
    NSLog(@"Table view content size is %lf", self.tableView.contentSize.height);
    if (!sender.selected) {
        [self scrollUpToOffset:self.stickerView.frame.size.height];
        self.stickerView.alpha = 1;
    } else {
        [self scrollDownToOffset:self.stickerView.frame.size.height];
        self.stickerView.alpha = 0;
    }
    
    sender.selected = !sender.selected;
}

- (void)scrollUpToOffset:(CGFloat)offset {
    NSLog(@"Scroll up to offset %lf", offset);
    CGFloat tableOffset = self.tableView.contentOffset.y;
    CGFloat visibleHeight = self.tableView.frame.size.height - offset - self.tableView.contentInset.bottom;
    CGFloat contentSize = self.tableView.contentSize.height;
    
    CGFloat difference = contentSize - (tableOffset + visibleHeight);
    
    if (difference < 0) {
        difference = 0;
    } else if (difference > offset) {
        difference = offset;
    }
    NSLog(@"Difference is %lf", difference);
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0,self.tableView.contentInset.bottom + offset, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, self.tableView.scrollIndicatorInsets.bottom + offset, 0)];
    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + difference);
}

- (void)scrollDownToOffset:(CGFloat)offset {
    NSLog(@"Scroll down to offset %lf", offset);
    CGFloat contentOffset = self.tableView.contentOffset.y;
    CGFloat difference;
    if (contentOffset < offset) {
        difference = contentOffset;
    } else {
        difference = offset;
    }
    
    NSLog(@"content offset is %lf, difference is %lf", contentOffset, difference);
    
    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y - difference);
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, self.tableView.contentInset.bottom - offset, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, self.tableView.scrollIndicatorInsets.bottom - offset, 0)];
}

- (void)scrollToBottom {
    CGRect bottomRect = CGRectMake(0, self.tableView.contentSize.height - 100, self.tableView.contentSize.width, 100);
    [self.tableView scrollRectToVisible:bottomRect animated:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.bottomStackViewBottomConstraint.constant = self.bottomStackViewBottomConstraint.constant - keyboardHeight;
    [self scrollUpToOffset:keyboardHeight];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.bottomStackViewBottomConstraint.constant = self.bottomStackViewBottomConstraint.constant + keyboardHeight;
    NSLog(@"Keyboard height during hide is %lf", keyboardHeight);
    [self scrollDownToOffset:keyboardHeight];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.chatTextField resignFirstResponder];
    return YES;
}

- (void)setupChatTextField {
    _chatTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
    _chatTextField.delegate = self;
    _chatTextField.backgroundColor = UIColor.redColor;
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
    
    [self.bottomStackView insertArrangedSubview:self.chatTextField atIndex:0];
}


@end
