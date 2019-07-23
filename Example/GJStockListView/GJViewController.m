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

- (NSArray<NSString *> *)titlesForListViewHeader:(GJStockListView *)listView {
	return [self getTitles];
}

- (nonnull NSAttributedString *)listView:(nonnull GJStockListView *)listView attributedStringAtRow:(NSInteger)row column:(NSInteger)column {
	NSInteger num = pow(row, column);
	NSString *string = [NSString stringWithFormat:@"%zd", num];
	NSMutableAttributedString *mAttri = [[NSMutableAttributedString alloc] initWithString:string];
	UIColor *titleColor = [UIColor darkGrayColor];
	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.alignment = NSTextAlignmentCenter;
	if (num % 3 == 2) {
		titleColor = [UIColor redColor];
		style.alignment = NSTextAlignmentLeft;
	} else if (num % 3 == 1) {
		titleColor = [UIColor greenColor];
		style.alignment = NSTextAlignmentRight;
	}
	
	[mAttri addAttributes:@{NSForegroundColorAttributeName : titleColor, NSParagraphStyleAttributeName : style} range:NSMakeRange(0, string.length)];
	
	return mAttri;
}


- (NSInteger)numberOfRowsInListView:(nonnull GJStockListView *)listView {
	return 30;
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.title  = @"股票列表";
	
	self.listView = [[GJStockListView alloc] initWithFrame:self.view.bounds];
	self.listView.delegate = self;
	[self.listView reloadData];
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
