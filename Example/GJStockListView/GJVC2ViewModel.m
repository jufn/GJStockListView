//
//  GJVC2ViewModel.m
//  GJStockListView_Example
//
//  Created by admin on 2020/3/8.
//  Copyright © 2020 jufn. All rights reserved.
//

#import "GJVC2ViewModel.h"

@implementation GJVC2ViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self loadSignal];
    }
    return self;
}

- (void)loadSignal {
    self.loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, name), RACObserve(self, password)] reduce:^id _Nullable{
        return @(self.name.length > 6 && self.password.length > 6);
    }];
    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"0.准备发送请求, 用户名密码%@ ", input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSLog(@"1. 请求数据");
            NSLog(@"2. 请求成功");
            NSLog(@"3. 处理数据");
            [subscriber sendNext:@"传数据"];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"over");
            }];
        }];
    }];
    [[self.loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if (x.boolValue) {
            NSLog(@"executing");
        } else {
            NSLog(@"end");
        }
        
    }];
    
}

@end
