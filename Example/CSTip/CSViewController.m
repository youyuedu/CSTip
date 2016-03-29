//
//  CSViewController.m
//  CSTip
//
//  Created by winddpan on 03/29/2016.
//  Copyright (c) 2016 winddpan. All rights reserved.
//

#import "CSViewController.h"
#import "CSTip.h"

@interface CSViewController ()

@end

@implementation CSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    
    CSEmptyTipView *tip = [[CSEmptyTipView alloc] initWithTitle:@"this is title" detail:@"and this is long long long long long long long long detail" headerImage:nil];
    [self.tableView setEmptyTipView:tip];
    
    [self.tableView showActivityIndicator];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView hideActivityIndicator];
    });
}

@end
