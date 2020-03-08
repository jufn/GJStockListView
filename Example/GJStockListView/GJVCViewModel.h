//
//  GJVCViewModel.h
//  GJStockListView_Example
//
//  Created by admin on 2020/3/7.
//  Copyright © 2020 jufn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>


NS_ASSUME_NONNULL_BEGIN

@interface GJVCViewModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) RACSubject *successSubject;
@property (nonatomic, strong) RACSubject *failureSubject;
@property (nonatomic, strong) RACSubject *errorSubject;

- (RACSignal *)buttonVaild;
- (void)login;

@end

NS_ASSUME_NONNULL_END
