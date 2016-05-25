//
//  UIScrollView+CSEmptyTip.m
//  youyushe
//
//  Created by Pan Xiao Ping on 16/1/15.
//  Copyright © 2016年 Cimu. All rights reserved.
//

#import "UIScrollView+CSEmptyTip.h"
#import <objc/runtime.h>
#import "UIView+CSTip.h"
#import "UIView+CSIndicatorTip.h"
#import "CSIndicatorTipView.h"
#import "CSEmptyTipView.h"

static void *CSReloadHookedContext  = &CSReloadHookedContext;
static void *CSRefreshControlStashesContext  = &CSRefreshControlStashesContext;

static const NSString *CSEmptyTipKey = @"CSEmptyTip";

@implementation UIScrollView (CSEmptyTip)

- (void)setEmptyTipView:(CSEmptyTipView *)new {
    NSAssert([self isKindOfClass:UITableView.class] || [self isKindOfClass:UICollectionView.class],
             @"must be UITableView or UICollectionView setEmptyTipView:");
    
    [self.emptyTipView removeFromSuperview];
    [self csit_setTipView:new forKey:CSEmptyTipKey];
    [self et_reloadEmptyTip];
    
    if (!objc_getAssociatedObject(self, CSReloadHookedContext)) {
        [self et_hookSelector:@selector(reloadData)];
        if ([self isKindOfClass:[UITableView class]]) {
            [self et_hookSelector:@selector(endUpdates)];
            [self et_hookSelector:@selector(insertSections:withRowAnimation:)];
            [self et_hookSelector:@selector(insertRowsAtIndexPaths:withRowAnimation:)];
            [self et_hookSelector:@selector(deleteSections:withRowAnimation:)];
            [self et_hookSelector:@selector(deleteRowsAtIndexPaths:withRowAnimation:)];
        }
    }
}

- (CSEmptyTipView *)emptyTipView {
    return (id)[self csit_tipViewForKey:CSEmptyTipKey];
}

#pragma - private

- (void)et_hookSelector:(SEL)selector {
    if (![self respondsToSelector:selector]) {
        return;
    }
    [self aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        [aspectInfo.instance et_reloadEmptyTip];
    } error:nil];
}

- (NSInteger)et_itemsCount
{
    NSInteger items = 0;
    id target = self;
    if (![target respondsToSelector:@selector(dataSource)]) {
        return items;
    }
    
    if ([target isKindOfClass:[UITableView class]]) {
        id <UITableViewDataSource> dataSource = [target performSelector:@selector(dataSource)];
        UITableView *tableView = (UITableView *)target;
        
        NSInteger sections = 1;
        if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        for (NSInteger i = 0; i < sections; i++) {
            items += [dataSource tableView:tableView numberOfRowsInSection:i];
        }
    } else if ([target isKindOfClass:[UICollectionView class]]) {
        id <UICollectionViewDataSource> dataSource = [target performSelector:@selector(dataSource)];
        UICollectionView *collectionView = (UICollectionView *)target;
        
        NSInteger sections = 1;
        if ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        for (NSInteger i = 0; i < sections; i++) {
            items += [dataSource collectionView:collectionView numberOfItemsInSection:i];
        }
    }
    return items;
}

- (void)et_reloadEmptyTip {
    if ([self isKindOfClass:UITableView.class] || [self isKindOfClass:UICollectionView.class]) {
        if ([self isShowingActivityIndicator]) {
            [self csit_hideTipViewForKey:CSEmptyTipKey];
            return;
        }
        if ([self et_itemsCount] > 0) {
            [self csit_hideTipViewForKey:CSEmptyTipKey];
        } else {
            [self csit_showTipViewForKey:CSEmptyTipKey];
        }
    }
}

#pragma mark - override UIView

- (void)showActivityIndicator {
    [super showActivityIndicator];
    
    if ([self respondsToSelector:@selector(et_reloadEmptyTip)]) {
        [self performSelector:@selector(et_reloadEmptyTip)];
    }
    
    UIViewController *parentViewController = [self et_parentViewController];
    UIRefreshControl *refreshControl = [self et_refreshControl];
    if (refreshControl && !objc_getAssociatedObject(self, CSRefreshControlStashesContext)) {
        objc_setAssociatedObject(self, CSRefreshControlStashesContext, refreshControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [parentViewController performSelector:@selector(setRefreshControl:) withObject:nil];
    }
}

- (void)hideActivityIndicator {
    [super hideActivityIndicator];
    
    if ([self respondsToSelector:@selector(et_reloadEmptyTip)]) {
        [self performSelector:@selector(et_reloadEmptyTip)];
    }
    
    UIViewController *parentViewController = [self et_parentViewController];
    UIRefreshControl *refreshControl = objc_getAssociatedObject(self, CSRefreshControlStashesContext);
    if ([refreshControl isKindOfClass:UIRefreshControl.class] && parentViewController && [parentViewController respondsToSelector:@selector(setRefreshControl:)]) {
        [parentViewController performSelector:@selector(setRefreshControl:) withObject:refreshControl];
        objc_setAssociatedObject(self, CSRefreshControlStashesContext, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIRefreshControl *)et_refreshControl {
    UIViewController *responder = [self et_parentViewController];
    if (responder && [responder respondsToSelector:@selector(refreshControl)]) {
        UIRefreshControl *refreshControl = [responder performSelector:@selector(refreshControl)];
        if ([refreshControl isKindOfClass:UIRefreshControl.class]) {
            return refreshControl;
        }
    }
    return nil;
}

- (UIViewController *)et_parentViewController {
    id responder = self;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    UIViewController *viewController = (UIViewController *)responder;
    return viewController;
}

@end
