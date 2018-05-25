//
//  ViewController.m
//  TableScrolling
//
//  Created by Rajat Agrawal on 24/05/18.
//  Copyright © 2018 Hike. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *scrollButton;
@property (weak, nonatomic) IBOutlet UIView *stickerView;

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
    CGFloat visibleHeight = self.tableView.frame.size.height - offset;
    CGFloat contentSize = self.tableView.contentSize.height;
    
    CGFloat difference = contentSize - (tableOffset + visibleHeight);
    
    if (difference < 0) {
        difference = 0;
    } else if (difference > offset) {
        difference = offset;
    }
    NSLog(@"Difference is %lf", difference);
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, offset, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, offset, 0)];
    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + difference);
//    [self scrollToBottom];
}

- (void)scrollDownToOffset:(CGFloat)offset {
    NSLog(@"Scroll down to offset %lf", offset);
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, -offset, 0)];
    CGFloat contentOffset = self.tableView.contentOffset.y;
    CGFloat difference;
    if (contentOffset < offset) {
        difference = contentOffset;
    } else {
        difference = offset;
    }
    
    NSLog(@"content offset is %lf, difference is %lf", contentOffset, difference);
    
//    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y - difference);
}

- (void)scrollToBottom {
    CGRect bottomRect = CGRectMake(0, self.tableView.contentSize.height - 100, self.tableView.contentSize.width, 100);
    [self.tableView scrollRectToVisible:bottomRect animated:YES];
}

@end
