//
//  GJViewController.m
//  GJStockListView
//
//  Created by jufn on 07/22/2019.
//  Copyright (c) 2019 jufn. All rights reserved.
//

#import "GJViewController.h"
#import "GJStockListView.h"
#import <MJRefresh/MJRefresh.h>

static NSString * const kMenuItemTitleBuy = @"买入";
static NSString * const kMenuItemTitleSell = @"卖出";
static NSString * const kMenuItemTitleTop = @"置顶";
static NSString * const kMenuItemTitleBottom = @"置底";
static NSString * const kMenuItemTitleDelete = @"删除";
static NSString * const kMenuItemTitleManager = @"指标管理";

@interface GJViewController () <GJStockListViewDelegate>
@property (nonatomic, strong) GJStockListView *listView;
@property (nonatomic, copy) NSArray<UIMenuItem *> *allMenuItems;
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
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [self getContent][column];
    label.textColor = [UIColor orangeColor];
    return label;
}

- (CGFloat)stockListView:(GJStockListView *)view widthAtColumn:(NSInteger)column {
    return 120;
}

- (void)stockListView:(GJStockListView *)view reloadingItemView:(UIView *)itemView atRow:(NSInteger)row column:(NSInteger)column {
    
}

- (void)stockListView:(GJStockListView *)view didSelectedAtRow:(NSInteger)row {
	
	[view startRiseHeartBeatAnimationAtRow:row];
	NSLog(@" ++++++ 您点击了第%ld行", row);
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)stockListView:(GJStockListView *)view didBegainLongPressAtRow:(NSInteger)row {
	[view startFallHeartBeatAnimationAtRow:row];
	[self becomeFirstResponder];
	NSLog(@" ________ 您长按了第%zd行", row);
	UIMenuController *menuCtrl = [UIMenuController sharedMenuController];
	NSArray *titles = @[kMenuItemTitleTop, kMenuItemTitleBottom, kMenuItemTitleDelete, kMenuItemTitleManager];
	NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
		NSString *title = [(UIMenuItem *)evaluatedObject title];
		return [titles containsObject:title];
	}];
	menuCtrl.menuItems = [self.allMenuItems filteredArrayUsingPredicate:predicate];
	
	UITableViewCell *cell = [view.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
	CGRect rect = [view.tableView convertRect:cell.frame toView:view];
	[menuCtrl setTargetRect:rect inView:view];
	[menuCtrl update];
	[menuCtrl setMenuVisible:YES animated:YES];}

- (void)didTapMenuItemBuy {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:kMenuItemTitleBuy message:nil preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alert dismissViewControllerAnimated:YES completion:nil];
	}];
	[alert addAction:action];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)didTapMenuItemSell {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:kMenuItemTitleSell message:nil preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alert dismissViewControllerAnimated:YES completion:nil];
	}];
	[alert addAction:action];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)didTapMenuItemTop {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:kMenuItemTitleTop message:nil preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alert dismissViewControllerAnimated:YES completion:nil];
	}];
	[alert addAction:action];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)didTapMenuItemBottom {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:kMenuItemTitleBottom message:nil preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alert dismissViewControllerAnimated:YES completion:nil];
	}];
	[alert addAction:action];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)didTapMenuItemDelete {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:kMenuItemTitleDelete message:nil preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alert dismissViewControllerAnimated:YES completion:nil];
	}];
	[alert addAction:action];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)didTapMenuItemManager {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:kMenuItemTitleManager message:nil preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alert dismissViewControllerAnimated:YES completion:nil];
	}];
	[alert addAction:action];
	[self presentViewController:alert animated:YES completion:nil];
}

- (NSArray<UIMenuItem *> *)allMenuItems {
	if (!_allMenuItems) {
		NSArray *titles = @[kMenuItemTitleBuy, kMenuItemTitleSell, kMenuItemTitleTop, kMenuItemTitleBottom, kMenuItemTitleDelete, kMenuItemTitleManager];
		NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:titles.count];
		for (NSString *title in titles) {
			SEL selector = NULL;
			if ([title isEqualToString:kMenuItemTitleBuy]) {
				selector = @selector(didTapMenuItemBuy);
			} else if ([title isEqualToString:kMenuItemTitleSell]) {
				selector = @selector(didTapMenuItemSell);
			} else if ([title isEqualToString:kMenuItemTitleTop]) {
				selector = @selector(didTapMenuItemTop);
			} else if ([title isEqualToString:kMenuItemTitleBottom]) {
				selector = @selector(didTapMenuItemBottom);
			} else if ([title isEqualToString:kMenuItemTitleDelete]) {
				selector = @selector(didTapMenuItemDelete);
			} else if ([title isEqualToString:kMenuItemTitleManager]) {
				selector = @selector(didTapMenuItemManager);
			}
			UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:title action:selector];
			[mArray addObject:item];
		}
		_allMenuItems = mArray;
	}
	return _allMenuItems;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.title  = @"股票列表";
	CGRect frame = CGRectMake(0, 200, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 200);
	
	self.listView = [[GJStockListView alloc] initWithFrame:frame];
	self.listView.delegate = self;
	
	MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.listView.tableView.mj_header endRefreshing];
		});
	}];
	header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	[header setTitle:@"正在刷新......" forState:MJRefreshStateRefreshing];
	self.listView.tableView.mj_header = header;
	[self.view addSubview:self.listView];
	
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.listView startFallHeartBeatAnimationAtRow:3];
	[self.listView startRiseHeartBeatAnimationAtRow:5];
	
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
