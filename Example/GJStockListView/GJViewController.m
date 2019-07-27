//
//  GJViewController.m
//  GJStockListView
//
//  Created by jufn on 07/22/2019.
//  Copyright (c) 2019 jufn. All rights reserved.
//

#import "GJViewController.h"
#import "GJStockListView.h"

@interface GJViewController () <GJStockListViewDelegate>

@property (nonatomic, strong) GJStockListView *listView;

@end

@implementation GJViewController

- (NSArray *)getTitles {
	return @[@"名称", @"最新", @"涨幅", @"涨跌", @"昨收", @"成交量", @"成交额", @"最高", @"最低"];
}

- (NSArray *)getContent {
    return @[@"国泰君安", @"20.19", @"+2.10%", @"0.45", @"19.64", @"3.2B", @"54B", @"20.21", @"19.88"];
}

- (NSArray<NSString *> *)titlesForListViewHeader:(GJStockListView *)listView {
	return [self getTitles];
}

- (NSInteger)numberOfRowsInListView:(nonnull GJStockListView *)listView {
	return 30;
}

- (NSInteger)numberOfColumnsInListView:(GJStockListView *)listView {
    return [[self getTitles] count];
}

- (UIView *)stockListView:(GJStockListView *)view headerItemViewAtColumn:(NSInteger)column {
    NSString *title = [self getTitles][column];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)tapHeaderButton:(UIButton *)sender {
    NSString *title = [sender titleForState:UIControlStateNormal];
    if (title == nil ) {
        return;
    }
    
    NSInteger index = [[self getTitles] indexOfObject:title];
    NSLog(@"hhhhhh %@ ____ %zd", title, index);
}

- (UIView *)stockListView:(GJStockListView *)view itemViewAtRow:(NSInteger)row column:(NSInteger)column {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = column == 0 || column == 3 ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    label.text = [self getContent][column];
    label.textColor = [UIColor orangeColor];
    return label;
}

- (CGFloat)stockListView:(GJStockListView *)view widthAtColumn:(NSInteger)column {
    return 120;
}
- (void)stockListView:(GJStockListView *)view reloadingItemView:(UIView *)itemView atRow:(NSInteger)row column:(NSInteger)column {
    
}



- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.title  = @"股票列表";
	CGRect frame = CGRectMake(0, 188, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 188);
	
	self.listView = [[GJStockListView alloc] initWithFrame:frame];
	self.listView.delegate = self;
//    [self.listView reloadData];
	[self.view addSubview:self.listView];
	
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self method];
}

- (void)method {
	NSString *str = nil;
	
	NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
	
	@try {
		[mDict setObject:str forKey:@"123"];
	} @catch (NSException *exception) {
		str = @"987";
		[mDict setObject:str forKey:@"123"];
	} @finally {
		NSLog(@" --- %@", mDict);
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}



@end
