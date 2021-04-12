//
//  MTNStockListView.h
//  GJStockListView
//
//  Created by 陈俊峰 on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MTNStockListViewDelegate <UITableViewDelegate>
@end

@protocol MTNStockListViewDataSource  <UITableViewDataSource>

@end

@interface MTNStockListView : UITableView

@property (nonatomic, weak, nullable) id<MTNStockListViewDelegate>delegate;
@property (nonatomic, weak, nullable) id<MTNStockListViewDataSource>dataSource;

@end

NS_ASSUME_NONNULL_END
