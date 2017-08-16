//
//  ViewController.m
//  scrollView_tableVIiew_Demo
//
//  Created by 刘金凯 on 2017/8/16.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "ViewController.h"
#import "NNEntityHeaders.h"
#import "LJKTableView.h"
#import "LJKTitleView.h"
#import "LJKHeaderView.h"
@interface ViewController ()<UIScrollViewDelegate, UITableViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LJKTitleView *titleView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupContentView];
    [self setupHeaderView];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, NNScreenWidth, [UIScreen mainScreen].bounds.size.height)];
        _scrollView.delaysContentTouches  = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
#pragma mark - 主要内容
- (void)setupContentView {
    self.scrollView.contentSize = CGSizeMake(NNScreenWidth * 6, 0);
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, NNHeadViewHeight + NNTitleHeight)];
    for (int i=0; i<6; i++) {
        LJKTableView *tableView = [[LJKTableView alloc] initWithFrame:CGRectMake(NNScreenWidth *i, 0, NNScreenWidth, self.view.frame.size.height - NNTitleHeight - 20)];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self;
        tableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
        tableView.tableHeaderView     = tableViewHeaderView;
        [self.scrollView addSubview:tableView];
    }
}
#pragma mark -tableView 的头部视图
- (void)setupHeaderView {
    self.headerView = [[LJKHeaderView alloc] initWithFrame:CGRectMake(0, 0, NNScreenWidth, NNHeadViewHeight + NNTitleHeight)];
    [self.view addSubview:self.headerView];
    self.titleView = [[LJKTitleView alloc] initWithFrame:CGRectMake(0, NNHeadViewHeight , NNScreenWidth, NNTitleHeight)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:self.titleView];
    __weak typeof(self) weakSelf = self;
    self.titleView.titles = @[@"标题一", @"标题二", @"标题三",@"标题四", @"标题五", @"标题六"];
    self.titleView.selectedIndex = 0;
    self.titleView.buttonSelected= ^(NSInteger index){
        [weakSelf.scrollView setContentOffset:CGPointMake(NNScreenWidth * index, 0) animated:YES];
    };
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSInteger pageNum = scrollView.contentOffset.x / NNScreenWidth + 0.5;
        self.titleView.selectedIndex = pageNum;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView || !scrollView.window ||scrollView == self.titleView.btnContanerSV) {
        return;
    }
    CGFloat offsetY      = scrollView.contentOffset.y;
    CGFloat originY      = 0;
    CGFloat otherOffsetY = 0;
    if (offsetY <= NNHeadViewHeight) {
        originY = -offsetY;
        if (offsetY < 0) {
            otherOffsetY = 0;
        } else {
            otherOffsetY = offsetY;
        }
    } else {
        originY = -NNHeadViewHeight;
        otherOffsetY = NNHeadViewHeight;
    }
    self.headerView.frame = CGRectMake(0, originY, NNScreenWidth, NNHeadViewHeight + NNTitleHeight);
    for ( int i = 0; i < self.titleView.titles.count; i++ ) {
        if (i != self.titleView.selectedIndex) {
            UITableView *contentView = self.scrollView.subviews[i];
            CGPoint offset = CGPointMake(0, otherOffsetY);
            if ([contentView isKindOfClass:[UITableView class]]) {
                if (contentView.contentOffset.y < NNHeadViewHeight || offset.y < NNHeadViewHeight) {
                    [contentView setContentOffset:offset animated:NO];
                }
            }
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (void)dealloc {
    NSLog(@"控制器已销毁");
}


@end
