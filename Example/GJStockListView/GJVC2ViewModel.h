//
//  GJVC2ViewModel.h
//  GJStockListView_Example
//
//  Created by admin on 2020/3/8.
//  Copyright © 2020 jufn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface GJVC2ViewModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, strong) RACSignal *loginEnableSignal;

@end

NS_ASSUME_NONNULL_END
