//
//  GJVCViewModel.m
//  GJStockListView_Example
//
//  Created by admin on 2020/3/7.
//  Copyright © 2020 jufn. All rights reserved.
//

#import "GJVCViewModel.h"

@interface GJVCViewModel ()

@property (nonatomic, strong) RACSignal *nameSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;

@property (nonatomic, copy) NSArray *resuestData;

@end

@implementation GJVCViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nameSignal = RACObserve(self, name);
        _passwordSignal = RACObserve(self, password);
        _successSubject = [RACSubject subject];
        _failureSubject = [RACSubject subject];
        _errorSubject = [RACSubject subject];
    }
    return self;
}

- (RACSignal *)buttonVaild {
    RACSignal *isVaild = [RACSignal combineLatest:@[self.nameSignal, self.passwordSignal] reduce:^id _Nullable(NSString *name, NSString *password){
        return @(name.length > 3 && password.length > 3);
    }];
    return isVaild;
}

- (void)login {
    _resuestData = @[self.name, self.password];
    [self.successSubject sendNext:self.resuestData];
}

@end
