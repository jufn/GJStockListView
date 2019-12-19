//
//  GJStockListView.h
//  GJStockListView
//
//  Created by jufn on 2019/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GJStockListView;
@protocol GJStockListViewDelegate <NSObject>

- (NSInteger)numberOfRowsInListView:(GJStockListView *)listView;
- (NSInteger)numberOfColumnsInListView:(GJStockListView *)listView;
- (UIView *)stockListView:(GJStockListView *)view headerItemViewAtColumn:(NSInteger)column;
- (UIView *)stockListView:(GJStockListView *)view itemViewAtRow:(NSInteger)row column:(NSInteger)column;
@optional

- (CGFloat)stockListView:(GJStockListView *)view widthAtColumn:(NSInteger)column;
- (void)stockListView:(GJStockListView *)view reloadingItemView:(UIView *)itemView atRow:(NSInteger)row column:(NSInteger)column;

@end

@interface GJStockListView : UIView

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, weak) id <GJStockListViewDelegate> delegate;
@property (nonatomic, assign) CGFloat preferWidthPerColumn;
@property (nonatomic, assign) CGFloat tableRowHeight;
@property (nonatomic, assign) CGFloat headerHeight;

- (void)startRiseHeartBeatAnimationAtRow:(NSInteger)row;
- (void)startFallHeartBeatAnimationAtRow:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
