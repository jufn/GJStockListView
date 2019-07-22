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
@end

@implementation GJViewController

- (NSArray *)getTitles {
	return @[@"名称", @"最新", @"涨幅", @"涨跌", @"昨收", @"成交量", @"成交额", @"最高", @"最低"];
}

- (NSArray<NSString *> *)titlesForListViewHeader:(GJStockListView *)listView {
	return [self getTitles];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.title  = @"股票列表";
	
	
	GJStockListView *view = [[GJStockListView alloc] initWithFrame:self.view.bounds];
	view.delegate = self;
	[self.view addSubview:view];
	
	
	
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
