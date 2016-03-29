//
//  UIView+CSTip.m
//  youyushe
//
//  Created by Pan Xiao Ping on 16/1/15.
//  Copyright © 2016年 Cimu. All rights reserved.
//

#import "UIView+CSIndicatorTip.h"
#import "UIView+CSTip.h"
#import "CSIndicatorTipView.h"

static const NSString *CSIndicatorKey = @"CSIndicator";

@implementation UIView (CSIndicatorTip)

#pragma mark - public funcs

- (void)showActivityIndicator {
    CSIndicatorTipView *indicatorView = (CSIndicatorTipView *)[self csit_tipViewForKey:CSIndicatorKey];
    if (!indicatorView) {
        indicatorView = [[CSIndicatorTipView alloc] init];
        [self csit_setTipView:indicatorView forKey:CSIndicatorKey];
    }
    [indicatorView.indicator startAnimating];
    [self csit_showTipViewForKey:CSIndicatorKey];
}

- (void)hideActivityIndicator {
    CSIndicatorTipView *indicatorView = (CSIndicatorTipView *)[self csit_tipViewForKey:CSIndicatorKey];
    [indicatorView.indicator stopAnimating];
    [self csit_hideTipViewForKey:CSIndicatorKey];
}

- (BOOL)isShowingActivityIndicator {
    CSIndicatorTipView *indicatorView = (CSIndicatorTipView *)[self csit_tipViewForKey:CSIndicatorKey];
    return indicatorView && indicatorView.superview != nil;
}

@end
