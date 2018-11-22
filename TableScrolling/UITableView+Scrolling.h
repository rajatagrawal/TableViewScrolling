//
//  UITableView+Scrolling.h
//  TableScrolling
//
//  Created by Rajat Agrawal on 26/05/18.
//  Copyright © 2018 Hike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Scrolling)

- (void)scrollUpByHeight:(CGFloat)height;
- (void)scrollDownByHeight:(CGFloat)height;

@end
