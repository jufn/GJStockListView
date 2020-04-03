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
#import <ReactiveObjC/ReactiveObjC.h>
#import "GJRacView.h"
#import "GJVCViewModel.h"
#import "GJLoginSuccessViewController.h"
#import "GJVC2ViewModel.h"

static NSString * const kMenuItemTitleBuy = @"买入";
static NSString * const kMenuItemTitleSell = @"卖出";
static NSString * const kMenuItemTitleTop = @"置顶";
static NSString * const kMenuItemTitleBottom = @"置底";
static NSString * const kMenuItemTitleDelete = @"删除";
static NSString * const kMenuItemTitleManager = @"指标管理";

@interface GJViewController () <GJStockListViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) GJStockListView *listView;
@property (nonatomic, copy) NSArray<UIMenuItem *> *allMenuItems;

@property (nonatomic, assign) int time;
@property (nonatomic, strong) RACDisposable *disposable;

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) GJVCViewModel *viewModel;
@property (nonatomic, strong) GJVC2ViewModel *viewMode2;

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
    
//    [self racDemo16];
//    [self racDemo20];
}

- (void)racDemo20 {
    self.viewMode2 = [[GJVC2ViewModel alloc] init];
    
    RAC(self.viewMode2, name) = self.nameTextField.rac_textSignal;
    RAC(self.viewMode2, password) = self.passwordTextField.rac_textSignal;
    RAC(self.sureBtn, enabled) = self.viewMode2.loginEnableSignal;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//	[self.listView startFallHeartBeatAnimationAtRow:3];
//	[self.listView startRiseHeartBeatAnimationAtRow:5];
//	self.title  = @"股票列表";
//	CGRect frame = CGRectMake(0, 200, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 200);
//
//	self.listView = [[GJStockListView alloc] initWithFrame:frame];
//	self.listView.delegate = self;
//
//	MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//			[self.listView.tableView.mj_header endRefreshing];
//		});
//	}];
//	header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//	[header setTitle:@"正在刷新......" forState:MJRefreshStateRefreshing];
//	self.listView.tableView.mj_header = header;
//	[self.view addSubview:self.listView];
	
//    [RACObserve(self.view, center) subscribeNext:^(id  _Nullable x) {
//          NSLog(@"++++ %@", x);
//      }];
//    [self racDemo11];
//    [self racDemo16];
//    [self blindModel];
//    [self demo17];
//}

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
    NSLog(@"%zd", yes);
//    [self method];
//    [self racDemo1];
//    [self racDemo3];
//    [self racDemo4];
//    [self racDemo9];
//    [self racDemo10];
//    [self racDemo11];
//    self.filed.text = @"fsdfs";
//    [self racDemo12];
//    [self racDemo13];
//    [self racDemo15];
//    [self demo18];
//    [self demo30];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
//    CFRunLoopAddTimer(CFRunLoopGetCurrent(), (__bridge_retained CFRunLoopTimerRef)self.timer, kCFRunLoopCommonModes);
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
//        [self.timer fire];
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


- (void)demo18 {
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"---- %@", input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"sendNext"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
//    [command.executionSignals subscribeNext:^(id  _Nullable x) {
//        [x subscribeNext:^(id  _Nullable x) {
//            NSLog(@"what is %@", x);
//        }];
//        NSLog(@"executionSignals %@", x);
//    }];
    
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"switchToLatest %@", x);
    }];
    
    [command.executing subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            NSLog(@"executing");
        } else {
            NSLog(@"end");
        }
    }];
    
    RACSignal *signal = [command execute:@"execute"];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];

}

- (void)demo17 {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送网络请求");
        [subscriber sendNext:@"得到网络数据"];
        return nil;
    }];
    
    RACMulticastConnection *connection = [signal publish];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"1 +++ %@", x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"2 +++ %@", x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"3 +++ %@", x);
    }];
    [connection connect];
    
}

- (void)blindModel {
    self.viewModel = [[GJVCViewModel alloc] init];
    
    RAC(self.viewModel, name) = self.nameTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    RAC(self.sureBtn, enabled) = [self.viewModel buttonVaild];
    
    [self.viewModel.successSubject subscribeNext:^(NSArray *  _Nullable x) {
        GJLoginSuccessViewController *vc = [[GJLoginSuccessViewController alloc] init];
        vc.name = x.firstObject;
        vc.password = x[1];
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
}

- (void)racDemo16 {
 
    CGFloat w = 200, h = 40;
    CGFloat origin = [UIScreen mainScreen].bounds.size.width * 0.5 - w;
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(origin, 120, w, h)];
    self.nameTextField.textColor = [UIColor orangeColor];
    self.nameTextField.backgroundColor = [UIColor lightGrayColor];
    self.nameTextField.userInteractionEnabled = YES;
    [self.view addSubview:self.nameTextField];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(origin, 180, w, h)];
    self.passwordTextField.userInteractionEnabled = YES;
    self.passwordTextField.textColor = [UIColor orangeColor];
    self.passwordTextField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.passwordTextField];
    
    self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(origin, 240, w, h)];
    [self.sureBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.sureBtn.enabled = NO;
    [self.view addSubview:self.sureBtn];
    
    [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[self.viewMode2.loginCommand execute:@{@"name" : self.nameTextField.text, @"password" : self.passwordTextField.text}] subscribeNext:^(id  _Nullable x) {
            NSLog(@"===== %@", x);
        }];
    }];
    
}

- (void)racDemo15 {
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    RACSubject *chinese = [RACSubject subject];
    [[RACSignal merge:@[letters, numbers, chinese]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [letters sendNext:@"AA"];
    [numbers sendNext:@"11"];
    [chinese sendNext:@"你好"];
}

- (void)racDemo14 {
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    
    [[RACSignal combineLatest:@[letters, numbers] reduce:^(NSString *letter, NSString *number){
        return [letter stringByAppendingString:number];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [letters sendNext:@"A"];
    [letters sendNext:@"B"];
    [numbers sendNext:@"1"];
    [letters sendNext:@"C"];
    [numbers sendNext:@"2"];
    
}

- (void)racDemo13 {
    RACSubject *baidu = [RACSubject subject];
    RACSubject *geogle = [RACSubject subject];
    RACSubject *signalOfSignal = [RACSubject subject];
    
    RACSignal *switchSignal = signalOfSignal.switchToLatest;
    [[switchSignal map:^id _Nullable(NSString *  _Nullable value) {
        return [NSString stringWithFormat:@"https://%@", value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [signalOfSignal sendNext:baidu];
    [baidu sendNext:@"www.baidu.com"];
    [signalOfSignal sendNext:geogle];
    [geogle sendNext:@"www.geogle.com"];
}

- (void)racDemo12 {
    NSArray *ary = @[@"you", @"are", @"beautiful", @"girl"];
    [[[ary rac_sequence].signal map:^id _Nullable(NSString *  _Nullable value) {
        NSLog(@"%@", value);
        return [value uppercaseString];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
//    RACSequence *seq = [ary rac_sequence];
//    RACSignal *signal = seq.signal;
//
//    RACSignal *upperSignal = [signal map:^id _Nullable(NSString *  _Nullable value) {
//        return value.uppercaseString;
//    }];
//
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    }];
//    [upperSignal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    }];
    
}

- (void)racDemo11 {
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(50, 120, 200, 50)];
    field.backgroundColor = [UIColor grayColor];
    field.textColor = [UIColor orangeColor];
    field.delegate = self;
    field.placeholder = @"placeHolder";
    field.userInteractionEnabled = YES;
    [self.view addSubview:field];
    
    //创建一个label
       UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 250, 200, 50)];
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor orangeColor];
       [self.view addSubview:label];
    
    RAC(label, text) = field.rac_textSignal;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)racDemo10 {
    self.view.center = CGPointMake(self.view.center.x + 100, self.view.center.y);
}

- (void)racDemo9 {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    [self rac_liftSelector:@selector(uploadUIWithResponse:data2:) withSignals:signal1, signal2, nil];
}

- (void)uploadUIWithResponse:(id)data1 data2:(id)data2 {
    NSLog(@"更新UI");
}

- (void)racDemo5 {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(40, 120, 200, 50)];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"发送验证码" forState:(UIControlStateNormal)];
    [self.view addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.time = 30;
        btn.enabled = NO;
        [btn setTitle:[NSString stringWithFormat:@"请稍等%d秒",_time] forState:UIControlStateDisabled];
        _disposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
            _time --;
            NSString *text = (_time > 0) ? [NSString stringWithFormat:@"请稍等%d秒",_time] : @"重新发送";
            if (_time > 0) {
                btn.enabled = NO;
                [btn setTitle:text forState:UIControlStateDisabled];
            } else {
                btn.enabled = YES;
                [btn setTitle:text forState:UIControlStateNormal];
                [_disposable dispose];
            }
        }];
    }];
}

- (void)racDemo4 {
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(50, 150, 200, 50)];
    field.backgroundColor = [UIColor grayColor];
    [self.view addSubview:field];
    
    [field.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@", x);
    }];
}

- (void)racDemo3 {
    GJRacView *view = [[GJRacView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.view addSubview:view];
    [[view rac_signalForSelector:@selector(sendValue:andDict:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"点击了按钮%@", x.first);
        NSLog(@"%@", x.second);
    }];
}

- (void)racDemo2 {
    GJRacView *view = [[GJRacView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.view addSubview:view];
    [view.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
        
    }];
}

- (void)racDemo1 {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 70, 70)];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    btn.tag = 1001;
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        NSLog(@"%@", x);
        x.frame = CGRectMake(200, 50, 100, 100);
    }];
    [[btn rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        NSLog(@"+++++ %@", x.second);
    }];
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

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self demo1];
//}
//
//- (void)demo1 {
//
//}
@end
