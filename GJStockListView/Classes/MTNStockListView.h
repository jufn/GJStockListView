//
//  MTNStockListView.h
//  GJStockListView
//
//  Created by 陈俊峰 on 2020/11/6.
//

#import <UIKit/UIKit.h>

@class MTNStockListView;

NS_ASSUME_NONNULL_BEGIN

@protocol GJStockListViewDelegate <NSObject>
//- (NSInteger)numberOfSectionInStockListView:(MTNStockListView *)listView;
//- (NSInteger)stockListView:(MTNStockListView *)view numOfRowInSection:(NSInteger)section;
//- (NSInteger)stockListView:(MTNStockListView *)view numOfItemInSection:(NSInteger)section;
//
//
//- (CGFloat)stockListView:(MTNStockListView *)view heightForRow:(NSInteger)row section:(NSInteger)section;
//- (CGFloat)stockListView:(MTNStockListView *)view widthForItem:(NSInteger)item section:(NSInteger)section;
//
//- (NSAttributedString *)stockListView:(MTNStockListView *)view attributedStringForHeaderItem:(NSInteger)item section:(NSInteger)section;
//- (NSAttributedString *)stockListView:(MTNStockListView *)view attributedStringForItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section;
@end

@interface MTNStockListView : UIView

//@property (nonatomic, weak) id <GJStockListViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
