//
//  GJRacView.h
//  GJStockListView_Example
//
//  Created by admin on 2020/3/7.
//  Copyright © 2020 jufn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface GJRacView : UIView

@property (nonatomic, strong) RACSubject *subject;

- (void)sendValue:(NSString *)value andDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
