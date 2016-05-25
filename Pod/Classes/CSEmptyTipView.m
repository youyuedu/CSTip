//
//  EmptyTipContentView.m
//  youyushe
//
//  Created by Pan Xiao Ping on 15/7/3.
//  Copyright (c) 2015年 cimu. All rights reserved.
//

#import "CSEmptyTipView.h"

@interface CSEmptyTipView ()
@property (strong) NSMutableArray *layoutConstraints;
@end

@implementation CSEmptyTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 1;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_label.attributedText) {
        [_label setNeedsDisplay];
    }
}

- (void)setOffset:(CGPoint)offset {
    _offset = offset;
    [self _updateConstraints];
}

- (instancetype)initWithCustomView:(UIView *)customView {
    if (self = [super init]) {
        [_customView removeFromSuperview];
        _customView = customView;
        _customView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:customView];
        [self _updateConstraints];
    }
    return self;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attributeString {
    if (self = [super init]) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        _label.backgroundColor = [UIColor clearColor];
        _label.attributedText = attributeString;
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_label];
        [self _updateConstraints];
    }
    return self;
}

- (void)_updateConstraints {
    
    if (!self.layoutConstraints) {
        self.layoutConstraints = [[NSMutableArray alloc] init];
    }
    [self removeConstraints:self.layoutConstraints];
    [self.layoutConstraints removeAllObjects];
    
    if (_label) {
        [self.layoutConstraints addObject:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-30 + self.offset.y]];
        [self.layoutConstraints addObject:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0 + self.offset.x]];
        [self.layoutConstraints addObject:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
    }
    if (_customView) {
        [self.layoutConstraints addObject:[NSLayoutConstraint constraintWithItem:_customView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-30 + self.offset.y]];
        [self.layoutConstraints addObject:[NSLayoutConstraint constraintWithItem:_customView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0 + self.offset.x]];
        [self.layoutConstraints addObject:[NSLayoutConstraint constraintWithItem:_customView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
    }
    [self addConstraints:self.layoutConstraints];
}

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail headerImage:(UIImage *)image {
    
    NSParagraphStyle *(^paragraphStyle)(CGFloat spacing) = ^NSParagraphStyle *(CGFloat spacing) {
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        paragraph.paragraphSpacing = spacing;
        return paragraph;
    };
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    if (image) {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = image;
        NSMutableAttributedString *attachAS = [[NSAttributedString attributedStringWithAttachment:attachment] mutableCopy];
        [attachAS addAttribute:NSParagraphStyleAttributeName value:paragraphStyle(40) range:NSMakeRange(0, attachAS.length)];
        [attrStr appendAttributedString:attachAS];
    }
    if (title.length) {
        if (attrStr.length) {
            NSAttributedString *breakAS = [[NSAttributedString alloc] initWithString:@"\n"];
            [attrStr appendAttributedString:breakAS];
        }
        NSMutableAttributedString *titleAS = [[NSMutableAttributedString alloc] initWithString:title];
        [titleAS addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, titleAS.length)];
        [titleAS addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] range:NSMakeRange(0, titleAS.length)];
        [titleAS addAttribute:NSParagraphStyleAttributeName value:paragraphStyle(12) range:NSMakeRange(0, titleAS.length)];
        [attrStr appendAttributedString:titleAS];
    }
    if (detail.length) {
        if (attrStr.length) {
            NSAttributedString *breakAS = [[NSAttributedString alloc] initWithString:@"\n"];
            [attrStr appendAttributedString:breakAS];
        }
        NSMutableAttributedString *detailAS = [[NSMutableAttributedString alloc] initWithString:detail];
        [detailAS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, detailAS.length)];
        [detailAS addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1] range:NSMakeRange(0, detailAS.length)];
        [detailAS addAttribute:NSParagraphStyleAttributeName value:paragraphStyle(12) range:NSMakeRange(0, detailAS.length)];
        [attrStr appendAttributedString:detailAS];
    }
    
    return [self initWithAttributedString:attrStr];
}

@end
