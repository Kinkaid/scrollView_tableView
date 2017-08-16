//
//  LJKTitleView.h
//  scrollDemo
//
//  Created by 刘金凯 on 2017/8/15.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NNTitleHeight 45
@interface LJKTitleView : UIView

@property (nonatomic,strong) UIScrollView *btnContanerSV;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) void (^buttonSelected)(NSInteger index);

@end
