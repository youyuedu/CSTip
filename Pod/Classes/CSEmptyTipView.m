//
//  EmptyTipContentView.m
//  youyushe
//
//  Created by Pan Xiao Ping on 15/7/3.
//  Copyright (c) 2015年 cimu. All rights reserved.
//

#import "CSEmptyTipView.h"

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

- (instancetype)initWithCustomView:(UIView *)customView {
    if (self = [super init]) {
        [_customView removeFromSuperview];
        _customView = customView;
        _customView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:customView];

        NSDictionary *views = NSDictionaryOfVariableBindings(_customView);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_customView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_customView]|" options:0 metrics:nil views:views]];
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
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_label);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_label]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_label]|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail headerImage:(UIImage *)image {
    UIFont *bodyFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    if (image) {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = image;
        NSAttributedString *attachAS = [NSAttributedString attributedStringWithAttachment:attachment];
        [attrStr appendAttributedString:attachAS];
    }
    if (title.length) {
        if (attrStr.length) {
            NSAttributedString *breakAS = [[NSAttributedString alloc] initWithString:@"\n"];
            [attrStr appendAttributedString:breakAS];
        }
        NSMutableAttributedString *titleAS = [[NSMutableAttributedString alloc] initWithString:title];
        [titleAS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ceil(bodyFont.pointSize*1.2)] range:NSMakeRange(0, titleAS.length)];
        [titleAS addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, titleAS.length)];
        [attrStr appendAttributedString:titleAS];
    }
    if (detail.length) {
        if (attrStr.length) {
            NSAttributedString *breakAS = [[NSAttributedString alloc] initWithString:@"\n"];
            [attrStr appendAttributedString:breakAS];
        }
        NSMutableAttributedString *detailAS = [[NSMutableAttributedString alloc] initWithString:detail];
        [detailAS addAttribute:NSFontAttributeName value:bodyFont range:NSMakeRange(0, detailAS.length)];
        [detailAS addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, detailAS.length)];
        [attrStr appendAttributedString:detailAS];
    }
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.paragraphSpacingBefore = 15;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attrStr.length)];
    
    return [self initWithAttributedString:attrStr];
}

@end
