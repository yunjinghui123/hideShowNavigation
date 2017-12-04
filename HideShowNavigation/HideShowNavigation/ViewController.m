//
//  ViewController.m
//  HideShowNavigation
//
//  Created by yunjinghui on 2017/12/4.
//  Copyright © 2017年 yunjinghui. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@end


static NSString * const cellid = @"cellid";
static CGFloat const viewAnimation_time = 0.08;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
}

- (void)prepareView {
    [self.view addSubview:self.tableView];
    
    self.tableView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellid];
    
    /// 这是内容视图, 可以适当的时候给top添加内容
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor cyanColor];
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"注意这里下面的分割线";
    [_topView addSubview:label];
    _topView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 44);
    [self.view addSubview:_topView];
    label.frame = _topView.bounds;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.y > 0) {
        // 这里在调整导航栏的同时让自定义的view也随着滚动，加动画的目地是为了让view的y值调整效果显得不那么突然
        [UIView animateWithDuration:viewAnimation_time animations:^{
            self.navigationController.navigationBar.hidden = YES;
            _topView.y = 20;
        }];
    } else {
        [UIView animateWithDuration:viewAnimation_time animations:^{
            self.navigationController.navigationBar.hidden = NO;
            _topView.y = 64;
        }];
    }
}

#pragma mark - UITbaleViewDelegate创建占位灰色分割线视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}


#pragma mark - UITableViewData
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    cell.contentView.backgroundColor = [UIColor yellowColor];
    
    return cell;
}


#pragma mark - lazy
- (UITableView *)tableView {
    if (_tableView == nil) {
        // 这里style设置为 UITableViewStylePlain 目的是让tableView随着滚动而滚动形成层次感
        _tableView = [[UITableView alloc] initWithFrame:(CGRect){{0, 0}, {0, 0}} style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.backgroundColor = [UIColor blueColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [UIView new];
    }
    return _tableView;
}




@end
