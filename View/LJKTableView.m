//
//  LJKTableView.m
//  scrollDemo
//
//  Created by 刘金凯 on 2017/8/15.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "LJKTableView.h"
#import "NNEntityHeaders.h"
@interface LJKTableView ()<UITableViewDataSource,UITableViewDelegate>

@end
static NSString *LJKTableViewCellID = @"LJKTableView";
@implementation LJKTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
}

- (void)setContentOffset:(CGPoint)contentOffset {
    if (self.window) {
        [super setContentOffset:contentOffset];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arc4random() % 50+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:LJKTableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LJKTableViewCellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试:%ld", indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deselectRowAtIndexPath:indexPath animated:YES];
}
@end
