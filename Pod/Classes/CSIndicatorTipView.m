//
//  ActivicyTipView.m
//  youyushe
//
//  Created by Pan Xiao Ping on 15/7/3.
//  Copyright (c) 2015年 cimu. All rights reserved.
//

#import "CSIndicatorTipView.h"

@implementation CSIndicatorTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contentView = [[UIView alloc] init];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];

        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.translatesAutoresizingMaskIntoConstraints = NO;
        indicator.hidesWhenStopped = NO;
        indicator.backgroundColor = [UIColor clearColor];
        _indicator = indicator;
        
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = NSLocalizedString(@"正在加载中...", nil);
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15];

        [contentView addSubview:indicator];
        [contentView addSubview:label];

        NSDictionary *views = NSDictionaryOfVariableBindings(contentView, indicator, label);
        [contentView addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"H:|[indicator]-10-[label]|"
                                     options:0
                                     metrics:nil
                                     views:views]];
        [contentView addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"V:|[indicator]|"
                                     options:0
                                     metrics:nil
                                     views:views]];
        [contentView addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"V:|[label]|"
                                     options:0
                                     metrics:nil
                                     views:views]];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];
    }
    return self;
}

@end
