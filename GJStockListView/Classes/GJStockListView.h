
#import <UIKit/UIKit.h>

@class GJStockListView;

NS_ASSUME_NONNULL_BEGIN

@protocol GJStockListViewDelegate <NSObject>
- (NSInteger)numberOfSectionInStockListView:(GJStockListView *)listView;
- (NSInteger)stockListView:(GJStockListView *)view numOfRowInSection:(NSInteger)section;
- (NSInteger)stockListView:(GJStockListView *)view numOfItemInSection:(NSInteger)section;

- (CGFloat)stockListView:(GJStockListView *)view heightForHeaderInSection:(NSInteger)section;
- (CGFloat)stockListView:(GJStockListView *)view heightForRow:(NSInteger)row section:(NSInteger)section;
- (CGFloat)stockListView:(GJStockListView *)view widthForItem:(NSInteger)item section:(NSInteger)section;

- (NSAttributedString *)stockListView:(GJStockListView *)view attributedStringForHeaderItem:(NSInteger)item section:(NSInteger)section;
- (NSAttributedString *)stockListView:(GJStockListView *)view attributedStringForItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section;
- (void)stockListView:(GJStockListView *)view didSelectedRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface GJStockListView : UIView

@property (nonatomic, readonly) UITableView *tableView;

@property (nonatomic, weak) id <GJStockListViewDelegate>delegate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
