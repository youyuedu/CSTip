//
//  UIScrollView+CSEmptyTip.h
//  youyushe
//
//  Created by Pan Xiao Ping on 16/1/15.
//  Copyright © 2016年 Cimu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSEmptyTipView;

@interface UIScrollView (CSEmptyTip)

/**
 *  UITableView / UICollectionView emtpy center tip
 */
@property (strong, nonatomic) CSEmptyTipView *emptyTipView;

@end
