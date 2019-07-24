//
//  GJStockListTableViewCell.h
//  GJStockListView
//
//  Created by jufn on 2019/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GJStockListTableViewCell;

@protocol GJStockListItemDataSource <NSObject>
- (CGFloat)widthAtColumn:(NSInteger)column inView:(UIView *)view;
@end

@interface GJStockListTableViewCell : UITableViewCell

@property (nonatomic, weak) id <GJStockListItemDataSource> dataSource;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
			  reuseIdentifier:(NSString *)reuseIdentifier
		numberOfColumnsPerRow:(NSUInteger)numberOfColumnsPerRow
				   scrollView:(UIScrollView *)scrollView;

- (UILabel *)labelAtColumn:(NSInteger)column;

@end


@interface GJStockListHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic, weak) id <GJStockListItemDataSource> dataSource;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
						   headerTitles:(NSArray *)titles
							 scrollView:(UIScrollView *)scrollView;
@end

NS_ASSUME_NONNULL_END
