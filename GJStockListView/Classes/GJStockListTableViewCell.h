//
//  GJStockListTableViewCell.h
//  GJStockListView
//
//  Created by jufn on 2019/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GJStockListHeaderView;

@protocol GJStockListHeaderViewDataSource <NSObject>
- (NSInteger)numberOfColumnsInHeaderView:(GJStockListHeaderView *)headerView;
- (CGFloat)widthAtColumn:(NSInteger)column inView:(UIView *)view;
- (UIView *)headerView:(GJStockListHeaderView *)headerView viewAtColumn:(NSInteger)column;
@end

//@interface GJStockListTableViewCell : UITableViewCell
//
//@property (nonatomic, weak) id <GJStockListItemDataSource> dataSource;
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style
//              reuseIdentifier:(NSString *)reuseIdentifier
//        numberOfColumnsPerRow:(NSUInteger)numberOfColumnsPerRow
//                   scrollView:(UIScrollView *)scrollView;
//
//- (UILabel *)labelAtColumn:(NSInteger)column;
//
//@end


@interface GJStockListHeaderView : UITableViewHeaderFooterView
@property (nonatomic, weak) id <GJStockListHeaderViewDataSource> dataSource;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

NS_ASSUME_NONNULL_END
