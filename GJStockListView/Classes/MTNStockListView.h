//
//  MTNStockListView.h
//  GJStockListView
//
//  Created by 陈俊峰 on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MTNStockListView;
@protocol MTNStockListViewDelegate <UITableViewDelegate>
- (CGFloat)stockListView:(MTNStockListView *)stockListView widthForItem:(NSInteger)item section:(NSInteger)section;

- (NSAttributedString *)stockListView:(MTNStockListView *)stockListView attributedStringForItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section;
- (NSAttributedString *)stockListView:(MTNStockListView *)stockListView attributedStringForHeaderItem:(NSInteger)item section:(NSInteger)section;

- (BOOL)stockListView:(MTNStockListView *)stockListView shouldHorizontalScrollableAtSection:(NSInteger)section;
- (NSInteger)stockListView:(MTNStockListView *)stockListView numberOfItemsAtSection:(NSInteger)section;
@end

@interface MTNStockListView : UITableView
@property (nonatomic, weak, nullable) id<MTNStockListViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
