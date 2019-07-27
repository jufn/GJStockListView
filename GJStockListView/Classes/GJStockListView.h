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
- (NSArray <NSString *>*)titlesForListViewHeader:(GJStockListView *)listView;
- (UIButton *)stockListView:(GJStockListView *)view buttonAtColumn:(NSInteger)column;
- (UIView *)stockListView:(GJStockListView *)view itemViewAtRow:(NSInteger)row column:(NSInteger)column;
@optional

- (CGFloat)stockListView:(GJStockListView *)view widthAtColumn:(NSInteger)column;
- (void)stockListView:(GJStockListView *)view reloadingItemView:(UIView *)itemView atRow:(NSInteger)row column:(NSInteger)column;
- (void)stockListView:(GJStockListView *)view didTapHeaderButton:(UIButton *)button atColumn:(NSInteger)column;

@end

@interface GJStockListView : UIView

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, weak) id <GJStockListViewDelegate> delegate;
@property (nonatomic, assign) CGFloat preferWidthPerColumn;
@property (nonatomic, assign) CGFloat tableRowHeight;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
