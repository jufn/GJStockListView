//
//  MTNScrollableTableViewCell.h
//  MTNTrade
//
//  Created by 陈俊峰 on 2020/10/29.
//  Copyright © 2020 ytx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MTNScrollableTableViewCell;

@protocol MTNScrollableTableViewCellDelegate <NSObject>

- (CGSize)scrollableTableViewCell:(MTNScrollableTableViewCell *)cell sizeForItem:(NSInteger)item;
- (void)scrollableTableViewCell:(MTNScrollableTableViewCell *)cell didScrollToOffsetX:(CGFloat)x;

@end

/// 可横向滚动的cell
@interface MTNScrollableTableViewCell : UITableViewCell

@property (nonatomic, weak) id <MTNScrollableTableViewCellDelegate> delegate;

// 初始化给的偏移量
@property (nonatomic, assign) CGFloat initialContentOffetX;

- (void)setContentOffsetX:(CGFloat)contentOffsetX;

- (void)loadAttributedTexts:(NSArray <NSAttributedString *> *)attributedTexts;

@end

/// 可横向滚动的Header
@interface MTNScrollableHeaderView : UIView

@end

NS_ASSUME_NONNULL_END
