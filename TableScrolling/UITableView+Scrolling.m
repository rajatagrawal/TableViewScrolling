//
//  UITableView+Scrolling.m
//  TableScrolling
//
//  Created by Rajat Agrawal on 26/05/18.
//  Copyright © 2018 Hike. All rights reserved.
//

#import "UITableView+Scrolling.h"

@implementation UITableView (Scrolling)

- (void)scrollUpByHeight:(CGFloat)height {
    NSLog(@"Scroll up to offset %lf", height);
    CGFloat tableOffset = self.contentOffset.y;
    CGFloat visibleHeight = self.frame.size.height - height - self.contentInset.bottom;
    CGFloat contentSize = self.contentSize.height;
    
    CGFloat difference = contentSize - (tableOffset + visibleHeight);
    
    if (difference < 0) {
        difference = 0;
    } else if (difference > height) {
        difference = height;
    }
    NSLog(@"Difference is %lf", difference);
    [self setContentInset:UIEdgeInsetsMake(0, 0,self.contentInset.bottom + height, 0)];
    [self setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, self.scrollIndicatorInsets.bottom + height, 0)];
    self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + difference);
}

- (void)scrollDownByHeight:(CGFloat)height {
    NSLog(@"Scroll down to offset %lf", height);
    CGFloat contentOffset = self.contentOffset.y;
    CGFloat difference;
    if (contentOffset < height) {
        difference = contentOffset;
    } else {
        difference = height;
    }
    
    NSLog(@"content offset is %lf, difference is %lf", contentOffset, difference);
    
    self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y - difference);
    [self setContentInset:UIEdgeInsetsMake(0, 0, self.contentInset.bottom - height, 0)];
    [self setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, self.scrollIndicatorInsets.bottom - height, 0)];
}

@end
