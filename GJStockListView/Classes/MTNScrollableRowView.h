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
- (CGFloat)rowView:(MTNScrollableRowView *)view widthForItem:(NSInteger)item;
- (NSAttributedString *)rowView:(MTNScrollableRowView *)view attributedStringForItem:(NSInteger)item;
- (void)rowView:(MTNScrollableRowView *)view didScrollToOffsetX:(CGFloat)x;

@end

/// 可横向滚动的cell
@interface MTNScrollableRowView : UIView
@property (nonatomic, strong) UILabel *titleLab;

- (instancetype)initWithFrame:(CGRect)frame numberOfItems:(NSInteger)numberOfItems delegate:(id <MTNScrollableRowViewDelegate>) delegate;

@property (nonatomic, assign) BOOL isAddedToHeader;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)setContentOffsetX:(CGFloat)contentOffsetX;

@end

NS_ASSUME_NONNULL_END
