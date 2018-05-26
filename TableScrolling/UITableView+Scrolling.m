//
//  UITableView+Scrolling.m
//  TableScrolling
//
//  Created by Rajat Agrawal on 26/05/18.
//  Copyright © 2018 Hike. All rights reserved.
//

#import "UITableView+Scrolling.h"

@implementation UITableView (Scrolling)

- (void)scrollUpToOffset:(CGFloat)offset {
    NSLog(@"Scroll up to offset %lf", offset);
    CGFloat tableOffset = self.contentOffset.y;
    CGFloat visibleHeight = self.frame.size.height - offset - self.contentInset.bottom;
    CGFloat contentSize = self.contentSize.height;
    
    CGFloat difference = contentSize - (tableOffset + visibleHeight);
    
    if (difference < 0) {
        difference = 0;
    } else if (difference > offset) {
        difference = offset;
    }
    NSLog(@"Difference is %lf", difference);
    [self setContentInset:UIEdgeInsetsMake(0, 0,self.contentInset.bottom + offset, 0)];
    [self setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, self.scrollIndicatorInsets.bottom + offset, 0)];
    self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + difference);
}

- (void)scrollDownToOffset:(CGFloat)offset {
    NSLog(@"Scroll down to offset %lf", offset);
    CGFloat contentOffset = self.contentOffset.y;
    CGFloat difference;
    if (contentOffset < offset) {
        difference = contentOffset;
    } else {
        difference = offset;
    }
    
    NSLog(@"content offset is %lf, difference is %lf", contentOffset, difference);
    
    self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y - difference);
    [self setContentInset:UIEdgeInsetsMake(0, 0, self.contentInset.bottom - offset, 0)];
    [self setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, self.scrollIndicatorInsets.bottom - offset, 0)];
}

@end
