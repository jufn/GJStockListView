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

@property (nonatomic, strong) NSTimer *timer;

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
//	[view startRiseHeartBeatAnimationAtRow:row];
	NSLog(@" ++++++ 您点击了第%ld行", row);
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)stockListView:(GJStockListView *)view didBegainLongPressAtRow:(NSInteger)row {
//	[view startFallHeartBeatAnimationAtRow:row];
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
	[menuCtrl setMenuVisible:YES animated:YES];
}

- (void)presentAlertWithTitle:(NSString *)title {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alert dismissViewControllerAnimated:YES completion:nil];
	}];
	[alert addAction:action];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)didTapMenuItemBuy {
	[self presentAlertWithTitle:kMenuItemTitleBuy];
}

- (void)didTapMenuItemSell {
	[self presentAlertWithTitle:kMenuItemTitleSell];
}

- (void)didTapMenuItemTop {
	[self presentAlertWithTitle:kMenuItemTitleTop];
}

- (void)didTapMenuItemBottom {
	[self presentAlertWithTitle:kMenuItemTitleBottom];
}

- (void)didTapMenuItemDelete {
	[self presentAlertWithTitle:kMenuItemTitleDelete];
}

- (void)didTapMenuItemManager {
	[self presentAlertWithTitle:kMenuItemTitleManager];
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
    NSString *temperPath =  [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"temper.bundle"];
       
      NSArray *paths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:temperPath error:nil];
       
       NSSortDescriptor *sortDescripttor1 = [NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES];
         NSArray *testArr = [paths sortedArrayUsingDescriptors:@[sortDescripttor1]];
       NSMutableArray *mut = [NSMutableArray array];
       for (NSString *fileName in testArr) {
           NSString *filePath = [NSString stringWithFormat:@"%@/%@",temperPath,fileName];
           NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
           if (data !=nil) {
               NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
               [mut addObject:result];
           };
       };
       
       NSString *archivepath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"archive.plist"];
    
       BOOL yes = [mut writeToFile:archivepath atomically:YES];
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"_++++ ^");
        }];
    }
    return _timer;
}

- (void)demo30 {
    CGRect bounds = CGRectMake(0, 0, 300, 200);
    
    NSString *content = @"您可以在现有会员资格到期日之前的 30 天内进行手动续订，也可在其到期后的任意时间进行续订。开发者网站上的帐户中会显示会员资格的到期日。若要续订，请使用注册时所用的 Apple ID 登录您的帐户 (英文)，然后点按“Renew Membership”(续订会员资格) 按钮。如果会员资格在续订时仍有效，那么新的会员资格会在当前会员资格到期后立即激活，而且您会获得两 (2) 个新的TLS.如果会员资格在续订时已过期，那么新的会员资格会在您完成续订流程后立即激活，之前可供下载的所有免费 app 都会在 24 小时内再次变为上架状态。在您登录 App Store Connect 并完成付费 app 合同后，之前可供下载的所有付费 app 都会再次变为上架状态。您无需重新提交 app。您还会获得两 (2) 个新的 TSI，并会重新获得通过 Apple Developer Program 单独购买的任何 TSI 的相应使用权限。请注意，单独购买的 TSI 会在激活之日起的一年后过期。";
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:17]};
    CGRect rect = [content boundingRectWithSize:CGSizeMake(CGRectGetWidth(bounds), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:NULL];
    while (CGRectGetHeight(rect) > CGRectGetHeight(bounds)) {
        content = [content substringToIndex:content.length - 1];
        rect = [content boundingRectWithSize:CGSizeMake(CGRectGetWidth(bounds), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:NULL];
    };
    NSLog(@"%zd", content.length);
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
