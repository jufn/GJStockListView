//
//  MTNStockListViewController.m
//  GJStockListView_Example
//
//  Created by 陈俊峰 on 2020/12/30.
//  Copyright © 2020 jufn. All rights reserved.
//

#import "MTNStockListViewController.h"
#import <GJStockListView.h>

@interface MTNStockListViewController () <MTNStockListViewDelegate>
@property (nonatomic, strong) MTNStockListView *stockListView;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *contents;
@end

@implementation MTNStockListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ha ha h";
    [self.view addSubview:self.stockListView];
}

- (NSInteger)numberOfSectionInStockListView:(nonnull MTNStockListView *)listView {
    return 1;
}

- (CGFloat)stockListView:(MTNStockListView *)view heightForHeaderInSection:(NSInteger)section{
    return 44.0;
}

- (CGFloat)stockListView:(nonnull MTNStockListView *)view heightForRow:(NSInteger)row section:(NSInteger)section {
    return 62;
}

- (NSInteger)stockListView:(nonnull MTNStockListView *)view numOfRowInSection:(NSInteger)section {
    return self.titles.count;
}

- (NSInteger)stockListView:(nonnull MTNStockListView *)view numOfItemInSection:(NSInteger)section {
    return self.titles.count;
}

- (CGFloat)stockListView:(nonnull MTNStockListView *)view widthForItem:(NSInteger)item section:(NSInteger)section {
    return 100;
}

- (nonnull NSAttributedString *)stockListView:(nonnull MTNStockListView *)view attributedStringForHeaderItem:(NSInteger)item section:(NSInteger)section {
    return [[NSAttributedString alloc] initWithString:self.titles[item] attributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    
}

- (nonnull NSAttributedString *)stockListView:(nonnull MTNStockListView *)view attributedStringForItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section {
    return [[NSAttributedString alloc] initWithString:self.contents[item] attributes:@{NSForegroundColorAttributeName : [UIColor orangeColor], NSFontAttributeName : [UIFont systemFontOfSize:15]}];
}

- (MTNStockListView *)stockListView {
    if (!_stockListView) {
        _stockListView = [[MTNStockListView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 100)];
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
