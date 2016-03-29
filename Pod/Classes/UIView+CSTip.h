//
//  UIView+Tip.h
//  youyushe
//
//  Created by Pan Xiao Ping on 16/2/15.
//  Copyright © 2016年 Cimu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Aspects.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CSTip)
- (void)csit_setTipView:(UIView *)tipView forKey:(nonnull id<NSCopying>)key;
- (UIView *)csit_tipViewForKey:(nonnull id<NSCopying>)key;
- (void)csit_showTipViewForKey:(nonnull id<NSCopying>)key;
- (void)csit_hideTipViewForKey:(nonnull id<NSCopying>)key;
@end

NS_ASSUME_NONNULL_END