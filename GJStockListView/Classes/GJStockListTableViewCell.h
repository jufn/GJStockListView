//
//  GJStockListTableViewCell.h
//  GJStockListView
//
//  Created by jufn on 2019/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GJStockListTableViewCell;

@protocol GJStockListTableViewCellDataSource <NSObject>
- (CGFloat)stockListTableViewCell:(GJStockListTableViewCell *)cell widthAtColumn:(NSInteger)column;
@end

@interface GJStockListTableViewCell : UITableViewCell

@property (nonatomic, weak) id <GJStockListTableViewCellDataSource> ds;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
			  reuseIdentifier:(NSString *)reuseIdentifier
		numberOfColumnsPerRow:(NSUInteger)numberOfColumnsPerRow
				   scrollView:(UIScrollView *)scrollView;

- (UILabel *)labelAtColumn:(NSInteger)column;

@end

NS_ASSUME_NONNULL_END
