//
//  EmptyTipContentView.h
//  youyushe
//
//  Created by Pan Xiao Ping on 15/7/3.
//  Copyright (c) 2015年 cimu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSEmptyTipView : UIView

@property (readonly, strong) UILabel *label;
@property (readonly, strong) UIView *customView;

- (instancetype)initWithCustomView:(UIView *)customView;

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString;

- (instancetype)initWithTitle:(NSString *)title
                       detail:(NSString *)detail
                  headerImage:(UIImage *)image;
@end