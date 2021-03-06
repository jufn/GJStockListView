//
//  MTNStockListViewController_new.m
//  GJStockListView_Example
//
//  Created by 陈俊峰 on 2021/4/12.
//  Copyright © 2021 jufn. All rights reserved.
//

#import "MTNStockListViewController_new.h"
#import <GJStockListView/MTNStockListView.h>
#import <MJRefresh/MJRefresh.h>
#import <GJStockListView/NSIndexPath+StockList.h>

@interface MTNStockListViewController_new () <MTNStockListViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MTNStockListView *stockListView;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *contents;
@end

@implementation MTNStockListViewController_new

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ha ha new";
    [self.view addSubview:self.stockListView];
}

- (void)pullDown {
    self.contents = [self.contents arrayByAddingObjectsFromArray:[self testDatas]];
    [self.stockListView.mj_footer endRefreshing];
    [self.stockListView reloadData];
}

#pragma mark - <MTNStockListViewDelegate, MTNStockListViewDataSource>

- (BOOL)stockListView:(MTNStockListView *)stockListView shouldHorizontalScrollableAtSection:(NSInteger)section {
    return YES;
}

- (CGFloat)stockListView:(MTNStockListView *)stockListView widthForItem:(NSInteger)item section:(NSInteger)section {
    return MIN(180, MAX(100, item * 10.0));
}

- (NSInteger)stockListView:(MTNStockListView *)stockListView numberOfItemsAtSection:(NSInteger)section {
    return [self.contents.firstObject count];
}

- (nonnull NSAttributedString *)stockListView:(nonnull MTNStockListView *)view attributedStringForHeaderItem:(NSInteger)item section:(NSInteger)section {
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"row:%zd", item] attributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
}

- (nonnull NSAttributedString *)stockListView:(nonnull MTNStockListView *)view attributedStringForItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section {
    
    NSArray *rowData = self.contents[row];
    return [[NSAttributedString alloc] initWithString:rowData[item] attributes:@{NSForegroundColorAttributeName : [UIColor orangeColor], NSFontAttributeName : [UIFont systemFontOfSize:15]}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCell.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@" ---- %@ --- %zd", indexPath, indexPath.itemIndex);
}

- (MTNStockListView *)stockListView {
    if (!_stockListView) {
        _stockListView = [[MTNStockListView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _stockListView.dataSource = self;
        _stockListView.delegate = self;
        _stockListView.sectionHeaderHeight = 60.0;
        __weak typeof(self) weakSelf = self;
        _stockListView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = self;
            [strongSelf pullDown];
        }];
    }
    return _stockListView;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"名称", @"最新", @"涨幅", @"涨跌", @"昨收", @"成交量", @"成交额", @"最高", @"最低"];
    }
    return _titles;
}

- (NSArray *)contents {
    if (!_contents) {
        _contents = [self testDatas];
    }
    return _contents;
}

- (NSArray *)testDatas {
    return @[
    @[@"比亚迪", @"167.5",@"+1.85%",@"3.08",@"0.19%",@"60650", @"0.54%", @"1.23", @"112.7", @"5.89", @"18", @"163.48", @"167.78", @"37.40%"],
    @[@"恒瑞医药", @"89.28",@"+1.85%",@"3.08",@"0.19%",@"60650", @"0.54%", @"1.23", @"112.7", @"5.89", @"18", @"163.48", @"167.78", @"37.40%"],
    @[@"广汽集团", @"10.41",@"+1.85%",@"3.08",@"0.19%",@"60650", @"0.54%", @"1.23", @"112.7", @"5.89", @"18", @"163.48", @"167.78", @"37.40%"],
    @[@"万科A", @"28.50",@"+1.85%",@"3.08",@"0.19%",@"60650", @"0.54%", @"1.23", @"112.7", @"5.89", @"18", @"163.48", @"167.78", @"37.40%"],
    @[@"招商银行", @"50.80",@"+1.85%",@"3.08",@"0.19%",@"60650", @"0.54%", @"1.23", @"112.7", @"5.89", @"18", @"163.48", @"167.78", @"37.40%"],
    @[@"青岛啤酒", @"87.43",@"+1.85%",@"3.08",@"0.19%",@"60650", @"0.54%", @"1.23", @"112.7", @"5.89", @"18", @"163.48", @"167.78", @"37.40%"],
    @[@"中信证券", @"23.32",@"+1.85%",@"3.08",@"0.19%",@"60650", @"0.54%", @"1.23", @"112.7", @"5.89", @"18", @"163.48", @"167.78", @"37.40%"],
    @[@"万达电影", @"17.17",@"+1.85%",@"3.08",@"0.19%",@"60650", @"0.54%", @"1.23", @"112.7", @"5.89", @"18", @"163.48", @"167.78", @"37.40%"],
    @[@"云南白药", @"113.13",@"+1.85%",@"3.08",@"0.19%",@"60650", @"0.54%", @"1.23", @"112.7", @"5.89", @"18", @"163.48", @"167.78", @"37.40%"],
    ];
}


@end
