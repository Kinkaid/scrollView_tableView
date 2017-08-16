//
//  LJKTitleView.m
//  scrollDemo
//
//  Created by 刘金凯 on 2017/8/15.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "LJKTitleView.h"
#import "NNEntityHeaders.h"
@interface LJKTitleView ()

@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation LJKTitleView

- (void)titleButtonClicked:(UIButton *)button {
    _selectedIndex               = button.tag;
    if (self.selectedButton) {
        self.selectedButton.selected = YES;
    }
    button.selected              = NO;
    self.selectedButton          = button;
    if (self.buttonSelected) {
        self.buttonSelected(button.tag);
    }
    NSString* title              = self.titles[button.tag];
    CGFloat sliderWidth          = button.titleLabel.font.pointSize * title.length;
    [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sliderWidth);
        make.height.mas_equalTo(2);
        make.centerX.equalTo(button);
        make.bottom.equalTo(self).offset(-2);
    }];
    if (_titles.count > 5) {
        if (_selectedIndex < 3) {
            [UIView animateWithDuration:0.25 animations:^{
                [_btnContanerSV setContentOffset:CGPointMake(0, 0)];
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                [_btnContanerSV setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width / 5.0 *((_selectedIndex - 2) >(_titles.count -5)?_titles.count -5:(_selectedIndex - 2)), 0)];
            }];
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex   = selectedIndex;
    UIButton* button = _btnContanerSV.subviews[selectedIndex];
    [self titleButtonClicked:button];
}

- (void)setTitles:(NSArray *)titles {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _titles               = titles;
    _btnContanerSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, NNTitleHeight)];
    [self addSubview:_btnContanerSV];
    _btnContanerSV.userInteractionEnabled = YES;
    _btnContanerSV.showsVerticalScrollIndicator = NO;
    _btnContanerSV.showsHorizontalScrollIndicator = NO;
    CGFloat width = 0;
    if (_titles.count >= 5) {
        _btnContanerSV.contentSize = CGSizeMake(_titles.count * ([UIScreen mainScreen].bounds.size.width / 5.0), 0);
        width = [UIScreen mainScreen].bounds.size.width / 5.0;
    } else {
        _btnContanerSV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 0);
        width = [UIScreen mainScreen].bounds.size.width / _titles.count;
    }
    
    
    for ( int i = 0; i<_titles.count; i++ ) {
        UIButton* titleButton = [self titleButton:titles[i]];
        titleButton.frame = CGRectMake(i*width, 0, width, NNTitleHeight);
        titleButton.tag = i;
        [_btnContanerSV addSubview:titleButton];
        if (i != 0) {
            titleButton.selected  = YES;
        } else {
            self.selectedButton  = titleButton;
        }
    }
    UIButton *button      = _btnContanerSV.subviews[0];
    NSString *title       = titles[0];
    CGFloat sliderWidth   = button.titleLabel.font.pointSize * title.length;
    [self.btnContanerSV addSubview:self.sliderView];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sliderWidth);
        make.height.mas_equalTo(4);
        make.centerX.equalTo(button);
        make.bottom.equalTo(self.btnContanerSV).offset(-3);
    }];
    [self layoutIfNeeded];
}

- (UIButton *)titleButton:(NSString *)title {
    UIButton* titleButton       = [[UIButton alloc] init];
    [titleButton addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [titleButton setTitle:title forState:UIControlStateNormal];
    return titleButton;
}

- (void)drawRect:(CGRect)rect {
    [self makelineStartPoint:self.sliderView.bottom andEndPoint:self.sliderView.bottom];
    [self makelineStartPoint:self.selectedButton.top andEndPoint:self.selectedButton.top];
}

- (void)makelineStartPoint:(CGFloat)statPoint andEndPoint:(CGFloat)endPoint {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.5);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, statPoint);  //起点坐标
    CGContextAddLineToPoint(context, self.frame.size.width, endPoint);   //终点坐标
    CGContextStrokePath(context);
}

- (UIView *)sliderView {
    if (!_sliderView) {
        UIView* sliderView            = [[UIView alloc] init];
        sliderView.backgroundColor    = [UIColor redColor];
        sliderView.layer.cornerRadius = 2;
        sliderView.clipsToBounds      = YES;
        _sliderView                   = sliderView;
    }
    return _sliderView;
}

@end
