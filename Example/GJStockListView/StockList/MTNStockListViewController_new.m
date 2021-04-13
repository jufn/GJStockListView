//
//  MTNStockListViewController_new.m
//  GJStockListView_Example
//
//  Created by 陈俊峰 on 2021/4/12.
//  Copyright © 2021 jufn. All rights reserved.
//

#import "MTNStockListViewController_new.h"
#import <GJStockListView/MTNStockListView.h>

@interface MTNStockListViewController_new () <MTNStockListViewDelegate, MTNStockListViewDataSource>
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

#pragma mark - <MTNStockListViewDelegate, MTNStockListViewDataSource>

- (BOOL)stockListView:(MTNStockListView *)stockListView shouldHorizontalScrollableAtSection:(NSInteger)section {
    return YES;
}

- (CGFloat)stockListView:(MTNStockListView *)stockListView widthForItem:(NSInteger)item section:(NSInteger)section {
    return MIN(180, MAX(100, item * 10.0));
}

- (NSInteger)stockListView:(MTNStockListView *)stockListView numberOfItemsAtSection:(NSInteger)section {
    return self.titles.count;
}

- (nonnull NSAttributedString *)stockListView:(nonnull MTNStockListView *)view attributedStringForHeaderItem:(NSInteger)item section:(NSInteger)section {
    return [[NSAttributedString alloc] initWithString:self.titles[item] attributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
}

- (nonnull NSAttributedString *)stockListView:(nonnull MTNStockListView *)view attributedStringForItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section {
    return [[NSAttributedString alloc] initWithString:self.contents[item] attributes:@{NSForegroundColorAttributeName : [UIColor orangeColor], NSFontAttributeName : [UIFont systemFontOfSize:15]}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCell.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 50.0;
}

- (MTNStockListView *)stockListView {
    if (!_stockListView) {
        _stockListView = [[MTNStockListView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _stockListView.dataSource = self;
        _stockListView.delegate = self;
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
        _contents = @[@"振华重工", @"20.19", @"+2.10%", @"0.45", @"19.64", @"3.2B", @"54B", @"20.21", @"19.88"];
    }
    return _contents;
}

@end
