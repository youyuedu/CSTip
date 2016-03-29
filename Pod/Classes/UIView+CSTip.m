//
//  UIView+Tip.m
//  youyushe
//
//  Created by Pan Xiao Ping on 16/2/15.
//  Copyright © 2016年 Cimu. All rights reserved.
//

#import "UIView+CSTip.h"
#import <objc/runtime.h>

static void *CSShowTipDictionaryContext = &CSShowTipDictionaryContext;
static void *CSLayoutHookedContext = &CSLayoutHookedContext;
static void *CSTipRenderWidthContext = &CSTipRenderWidthContext;

@implementation UIView (CSTip)

- (UIView *)csit_tipViewForKey:(nonnull id<NSCopying>)key {
    NSMutableDictionary *tipDictionary = [self csit_tipDictionary];
    return tipDictionary[key];
}

- (void)csit_setTipView:(UIView *)tipView forKey:(nonnull id<NSCopying>)key {
    NSMutableDictionary *tipDictionary = [self csit_tipDictionary];
    UIView *oldTip = tipDictionary[key];
    [oldTip removeFromSuperview];
    
    if (tipView) {
        [tipDictionary setObject:tipView forKey:key];
    } else {
        [tipDictionary removeObjectForKey:key];
    }
}

- (void)csit_showTipViewForKey:(nonnull id<NSCopying>)key {
    UIView *tipView = [self csit_tipViewForKey:key];
    if (tipView && !tipView.superview) {
        [self addSubview:tipView];
        [self csit_updateTipViewFrame];
    }
    
    if (!objc_getAssociatedObject(self, CSLayoutHookedContext)) {
        [self aspect_hookSelector:@selector(didMoveToWindow) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
            [self csit_updateTipViewFrame];
        } error:nil];
        
        [self aspect_hookSelector:@selector(setFrame:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
            [self csit_updateTipViewFrame];
        } error:nil];
        
        if ([self isKindOfClass:UIScrollView.class]) {
            [self aspect_hookSelector:@selector(setContentInset:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
                [aspectInfo.instance csit_updateTipViewFrame];
            } error:nil];
        }
        if ([self isKindOfClass:UITableView.class]) {
            [self aspect_hookSelector:@selector(setTableHeaderView:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
                [aspectInfo.instance csit_updateTipViewFrame];
            } error:nil];
            [self aspect_hookSelector:@selector(setTableFooterView:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
                [aspectInfo.instance csit_updateTipViewFrame];
            } error:nil];
        }
        
        objc_setAssociatedObject(self, CSLayoutHookedContext, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)csit_hideTipViewForKey:(nonnull id<NSCopying>)key {
    UIView *tipView = [self csit_tipViewForKey:key];
    if (tipView.superview) {
        [tipView removeFromSuperview];
    }
}

- (NSMutableDictionary *)csit_tipDictionary {
    NSMutableDictionary *tipDictionary = objc_getAssociatedObject(self, CSShowTipDictionaryContext);
    if (!tipDictionary) {
        tipDictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, CSShowTipDictionaryContext, tipDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tipDictionary;
}

- (void)csit_updateTipViewFrame
{
    NSMutableDictionary *tipDictionary = [self csit_tipDictionary];
    [tipDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UIView  * _Nonnull tipView, BOOL * _Nonnull stop) {
        if (tipView.superview) {
            CGFloat renderedWidth = [objc_getAssociatedObject(tipView, CSTipRenderWidthContext) doubleValue];
            CGFloat renderWidth = CGRectGetWidth(self.frame);
            CGSize size = tipView.frame.size;
            
            if (renderWidth != renderedWidth) {
                CGSize fittingSize = CGSizeZero;
                NSLayoutConstraint *tempWidthConstraint = [NSLayoutConstraint constraintWithItem:tipView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetWidth(self.frame) * 0.8];
                [tipView addConstraint:tempWidthConstraint];
                
                fittingSize = [tipView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                [tipView removeConstraint:tempWidthConstraint];
                
                size = fittingSize;
                objc_setAssociatedObject(tipView, CSTipRenderWidthContext, @(renderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            
            CGFloat height = CGRectGetHeight(self.frame);
            CGFloat width = CGRectGetWidth(self.frame);
            
            if ([self isKindOfClass:UIScrollView.class]) {
                UIScrollView *scrollView = (UIScrollView *)self;
                height = height - scrollView.contentInset.top - scrollView.contentInset.bottom;
            }
            
            CGFloat x = (width - size.width)/2;
            CGFloat y = (height - size.height)/2;
            
            if ([self isKindOfClass:UITableView.class]) {
                y += CGRectGetHeight(((UITableView *)self).tableHeaderView.frame) / 2;
                y -= CGRectGetHeight(((UITableView *)self).tableFooterView.frame) / 2;
            }
            tipView.frame = CGRectMake(ceil(x),  ceil(y), ceil(size.width), ceil(size.height));
        }
    }];
}

@end
