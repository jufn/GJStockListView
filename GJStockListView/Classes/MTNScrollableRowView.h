//
//  MTNScrollableTableViewCell.h
//  MTNTrade
//
//  Created by 陈俊峰 on 2020/10/29.
//  Copyright © 2020 ytx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MTNScrollableRowView;

@protocol MTNScrollableRowViewDelegate <NSObject>

- (NSInteger)numberOfItemsInScrollableTableViewCell:(MTNScrollableRowView *)cell;

- (CGSize)scrollableTableViewCell:(MTNScrollableRowView *)cell sizeForItem:(NSInteger)item;
- (NSAttributedString *)scrollableTableViewCell:(MTNScrollableRowView *)cell attributedStringForItem:(NSInteger)item;
- (void)scrollableTableViewCell:(MTNScrollableRowView *)cell didScrollToOffsetX:(CGFloat)x;

@end

/// 可横向滚动的cell
@interface MTNScrollableRowView : UIView

@property (nonatomic, weak) id <MTNScrollableRowViewDelegate> delegate;

// 初始化给的偏移量
@property (nonatomic, assign) CGFloat initialContentOffetX;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)layoutSubviewsWithCellWidth:(CGFloat)width;

- (void)setContentOffsetX:(CGFloat)contentOffsetX;

- (void)loadAttributedText:(NSAttributedString *)attributedText item:(NSInteger)item;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
