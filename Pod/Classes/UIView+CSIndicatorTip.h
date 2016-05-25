//
//  UIView+CSTip.h
//  youyushe
//
//  Created by Pan Xiao Ping on 16/1/15.
//  Copyright © 2016年 Cimu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CSIndicatorTip)

/**
 *  Aslo disable UIRefreshControl if parent view controller has one
 */
- (void)showActivityIndicator;

- (void)hideActivityIndicator;

- (BOOL)isShowingActivityIndicator;

@end
