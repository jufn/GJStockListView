//
//  GJMainRACDemoViewController.m
//  GJStockListView_Example
//
//  Created by 陈俊峰 on 2021/4/7.
//  Copyright © 2021 jufn. All rights reserved.
//

#import "GJMainRACDemoViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "GJRacView.h"
#import "GJVCViewModel.h"
#import "GJLoginSuccessViewController.h"
#import "GJVC2ViewModel.h"

@interface GJMainRACDemoViewController () <UITextFieldDelegate>

@property (nonatomic, strong) RACDisposable *disposable;

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) GJVCViewModel *viewModel;
@property (nonatomic, strong) GJVC2ViewModel *viewMode2;

@property (nonatomic, assign) int time;

@end

@implementation GJMainRACDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row + 1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (UIView *sub in self.tableView.subviews) {
        if ([sub isKindOfClass:GJRacView.class]) {
            [sub removeFromSuperview];
        }
    }
    NSString *method = [NSString stringWithFormat:@"racDemo%zd", indexPath.row + 1];
    SEL sel = NSSelectorFromString(method);
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel];
    }
    
}

- (void)racDemo16 {
    self.viewMode2 = [[GJVC2ViewModel alloc] init];
    
    RAC(self.viewMode2, name) = self.nameTextField.rac_textSignal;
    RAC(self.viewMode2, password) = self.passwordTextField.rac_textSignal;
    RAC(self.sureBtn, enabled) = self.viewMode2.loginEnableSignal;
}

- (void)racDemo15 {
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"---- %@", input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"sendNext"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
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

- (void)racDemo14 {
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

- (void)racDemo13 {
 
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

- (void)racDemo12 {
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

- (void)racDemo11 {
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

- (void)racDemo10 {
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

- (void)racDemo9 {
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

- (void)racDemo8 {
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

- (void)racDemo7 {
    self.view.center = CGPointMake(self.view.center.x + 100, self.view.center.y);
}

- (void)racDemo6 {
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
    [[[btn rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:self] distinctUntilChanged] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        NSLog(@"+++++ %@", x.second);
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
