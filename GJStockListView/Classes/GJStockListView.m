//
//  GJStockListView.m
//  GJStockListView
//
//  Created by jufn on 2019/7/22.
//

//#import "GJStockListView.h"



//static NSString * const kGJStockListTableViewCellIdentifier = @"kGJStockListTableViewCellIdentifier";
//static NSString * const kGJStockListHeaderViewIdentifier 	= @"GJStockListHeaderViewIdentifier";
//static NSString * const kGJStockListTableViewContentSize 	= @"contentSize";
//static NSInteger  const kHeaderScrollViewTag = 1000;
//
//@interface SLScrollView : UIScrollView
//
//@end
//
//@implementation SLScrollView
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	[super touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	[super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	if ([[self nextResponder] isKindOfClass:[UITableView class]]) {
//		UITouch *touch = touches.anyObject;
//		if (touch == nil) {
//			return;
//		}
//		UITableView *tableView = (UITableView *)[self nextResponder];
//		CGPoint point = [touch locationInView:tableView];
//		NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:point];
//		if (tableView.delegate && [tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
//			[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
//		}
//	}
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//	[super touchesCancelled:touches withEvent:event];
//}
//
//@end
//
//@interface GJStockListTableViewCell : UITableViewCell
//@property (nonatomic, strong) CAGradientLayer *gradientLayer;
//@property (nonatomic, strong) CABasicAnimation *heartBeatAnimation;
//@end
//
//@implementation GJStockListTableViewCell
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//	if (self) {
//		[self.contentView.layer addSublayer:self.gradientLayer];
//	}
//	return self;
//}
//
//- (void)layoutSubviews {
//	[super layoutSubviews];
//	self.gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
//}
//
//- (CAGradientLayer *)gradientLayer {
//	if (!_gradientLayer) {
//		_gradientLayer = [CAGradientLayer layer];
//		_gradientLayer.startPoint = CGPointMake(1, 0);
//		_gradientLayer.endPoint = CGPointMake(0, 0);
//		_gradientLayer.locations = @[@(0.0f),@(1.0f)];
//		_gradientLayer.opacity = 0;
//	}
//	return _gradientLayer;
//}
//
//- (CABasicAnimation *)heartBeatAnimation {
//	if (!_heartBeatAnimation) {
//		_heartBeatAnimation = [CABasicAnimation animation];
//		_heartBeatAnimation.keyPath = @"opacity";
//		_heartBeatAnimation.fromValue = @(0);
//		_heartBeatAnimation.toValue = @(1);
//		_heartBeatAnimation.duration = 0.75;
//		_heartBeatAnimation.autoreverses = YES;
//		_heartBeatAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//	}
//	return _heartBeatAnimation;
//}
//
//- (void)startRiseAnimation {
//	UIColor *color = [UIColor colorWithRed:235.0/255 green:51.0/255 blue:59/255.0 alpha:0.45];
//	UIColor *toColor = [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:0.0];
//	self.gradientLayer.colors = @[(__bridge id)color.CGColor, (__bridge id)toColor.CGColor];
//	[self.gradientLayer addAnimation:self.heartBeatAnimation forKey:@"rise"];
//}
//
//- (void)startFallAnimation {
//	UIColor *color = [UIColor colorWithRed:26.0/255 green:174.0/255 blue:82/255.0 alpha:0.45];
//	UIColor *toColor = [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:0.0];
//	self.gradientLayer.colors = @[(__bridge id)color.CGColor, (__bridge id)toColor.CGColor];
//	[self.gradientLayer addAnimation:self.heartBeatAnimation forKey:@"fall"];
//}
//
//@end
//
//NSInteger getCellSubViewTag(NSInteger row, NSInteger column) {
//    return column * 10000 + row;
//}
//
//void getRowAndColumnWithTag(NSInteger tag, NSInteger *row, NSInteger *column) {
//    *row = tag % 10000;
//    *column = tag / 10000;
//}
//
//@interface GJStockListView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
//@property (nonatomic, strong, readwrite) UITableView *tableView;
//@property (nonatomic, strong) SLScrollView *scrollView;
//@property (nonatomic, strong) UIView *headerView;
//@end
//
//@implementation GJStockListView
//
//- (instancetype)initWithFrame:(CGRect)frame {
//	if (self = [super initWithFrame:frame]) {
//
//		[self setInitialConfig];
//		[self loadupUI];
//		[self.tableView addObserver:self forKeyPath:kGJStockListTableViewContentSize options:NSKeyValueObservingOptionNew context:NULL];
//	}
//	return self;
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//	if ([keyPath isEqualToString:kGJStockListTableViewContentSize]) {
//		CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
//
//		CGRect frame = self.scrollView.frame;
//		self.scrollView.frame = CGRectMake(CGRectGetMinX(frame), 0, CGRectGetWidth(frame), size.height);
//		self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, size.height);
//	}
//}
//
//- (void)loadupUI {
//	[self addSubview:self.headerView];
//	[self addSubview:self.tableView];
//
//	[self.tableView addSubview:self.scrollView];
//	[self.tableView sendSubviewToBack:self.scrollView];
//}
//
//- (void)setDelegate:(id<GJStockListViewDelegate>)delegate {
//	_delegate = delegate;
//	[self layoutHeaderView];
//	[self layoutScrollView];
//}
//
//- (void)layoutScrollView {
//    CGFloat width = 0.0f;
//    for (int i = 0; i < [self numberOfColumns]; i ++) {
//        if (i == 0) {
//            continue;
//        }
//        CGFloat width_i = [self itemViewWidthAtColumn:i];
//        width += width_i;
//    }
//    width = MAX(width, CGRectGetWidth(self.frame));
//
//    CGFloat firstColumnWidth = [self itemViewWidthAtColumn:0];
//    self.scrollView.frame = CGRectMake(firstColumnWidth, 0, CGRectGetWidth(self.tableView.frame) - firstColumnWidth, self.tableView.contentSize.height);
//    self.scrollView.contentSize = CGSizeMake(width, self.tableView.contentSize.height);
//}
//
//- (void)layoutHeaderView {
//	CGFloat firstColumnWidth = [self itemViewWidthAtColumn:0];
//	UIScrollView *scrollView = [self.headerView viewWithTag:kHeaderScrollViewTag];
//	scrollView.frame = CGRectMake(firstColumnWidth, 0, CGRectGetWidth(self.headerView.frame) - firstColumnWidth, CGRectGetHeight(self.headerView.frame));
//
//	NSUInteger count = [self numberOfColumns];
//	CGPoint itemOri = CGPointZero;
//	for (int i = 0; i < count; i ++) {
//		UIView *view = [self headeViewAtColumn:i];
//		if (view == nil) {
//			continue;
//		}
//		CGFloat width = [self itemViewWidthAtColumn:i];
//		// lay out subviews
//		if (i == 0) {
//			[self.headerView addSubview:view];
//			view.frame = CGRectMake(itemOri.x, itemOri.y, width, CGRectGetHeight(self.headerView.frame));
//		} else {
//			[scrollView addSubview:view];
//			view.frame = CGRectMake(itemOri.x, itemOri.y, width, CGRectGetHeight(self.headerView.frame));
//			itemOri.x += width;
//		}
//
//		if (i == count - 1) { // 最后一个
//			scrollView.contentSize = CGSizeMake(CGRectGetMaxX(view.frame), CGRectGetHeight(self.headerView.frame));
//		}
//	}
//}
//
//- (void)startRiseHeartBeatAnimationAtRow:(NSInteger)row {
//	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//	GJStockListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//
//	[cell startRiseAnimation];
//}
//
//- (void)startFallHeartBeatAnimationAtRow:(NSInteger)row {
//	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//	GJStockListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//
//	[cell startFallAnimation];
//}
//
//- (void)setInitialConfig {
//	self.preferWidthPerColumn = 90.0f;
//	self.tableRowHeight = 44.0f;
//    self.headerHeight = 44.0f;
//}
//
//#pragma mark - UITableViewDelegate & UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	NSInteger rows = 0;
//	if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfRowsInListView:)]) {
//		rows = [self.delegate numberOfRowsInListView:self];
//	}
//	return rows;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	return self.tableRowHeight;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//	GJStockListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGJStockListTableViewCellIdentifier];
//    NSUInteger count = [self numberOfColumns];
//
//	if (cell == nil) {
//        cell = [[GJStockListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGJStockListTableViewCellIdentifier];
//        CGPoint itemOri = CGPointZero;
//        for (int i = 0; i < count; i ++) {
//            UIView *view = [self itemViewAtRow:indexPath.row column:i];
//            if (view == nil) {
//                continue;
//            }
//            view.tag = getCellSubViewTag(indexPath.row, i);
//            CGFloat width = [self itemViewWidthAtColumn:i];
//            // lay out subviews
//            if (i == 0) {
//                [cell.contentView addSubview:view];
//                view.frame = CGRectMake(itemOri.x, itemOri.y, width, self.tableRowHeight);
//            } else {
//                [self.scrollView addSubview:view];
//                itemOri.y = indexPath.row * self.tableRowHeight;
//                view.frame = CGRectMake(itemOri.x, itemOri.y, width, self.tableRowHeight);
//                itemOri.x += width;
//            }
//        }
//    } else {
//        // 对复用的， 重新调整frame
//        UIView *view = cell.contentView.subviews.firstObject;
//        if (view) {
//            NSInteger row = 0, column = 0;
//            getRowAndColumnWithTag(view.tag, &row, &column);
//
//            for (int i = 0; i < count; i ++) {
//                if (i == 0) {
//                    view.tag = getCellSubViewTag(indexPath.row, i);
//                } else {
//                    UIView *subView = [self.scrollView viewWithTag:getCellSubViewTag(row, i)];
//                    CGFloat posY = indexPath.row * self.tableRowHeight;
//                    subView.frame = CGRectMake(CGRectGetMinX(subView.frame), posY, CGRectGetWidth(subView.frame), CGRectGetHeight(subView.frame));
//                    subView.tag = getCellSubViewTag(indexPath.row, i);
//                }
//
//            }
//        }
//    }
//
//    for (int i = 0; i < count; i ++) {
//        UIView *view = nil;
//        if (i == 0) {
//            view = [cell.contentView viewWithTag:getCellSubViewTag(indexPath.row, i)];
//        } else {
//            view = [self.scrollView viewWithTag:getCellSubViewTag(indexPath.row, i)];
//        }
//
//        if (view == nil) { //  空白
//            continue;
//        }
//        if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:reloadingItemView:atRow:column:)]) {
//            [self.delegate stockListView:self reloadingItemView:view atRow:indexPath.row column:i];
//        }
//    }
//
//	return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:didSelectedAtRow:)]) {
//		[self.delegate stockListView:self didSelectedAtRow:indexPath.row];
//	}
//	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//
//- (UIView *)headeViewAtColumn:(NSInteger)column {
//    UIView *headerView = nil;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:headerItemViewAtColumn:)]) {
//        headerView = [self.delegate stockListView:self headerItemViewAtColumn:column];
//    }
//    return headerView;
//}
//
//- (UIView *)itemViewAtRow:(NSInteger)row column:(NSInteger)column {
//    UIView *itemView = nil;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:itemViewAtRow:column:)]) {
//      itemView =  [self.delegate stockListView:self itemViewAtRow:row column:column];
//    }
//    return itemView;
//}
//
//- (CGFloat)itemViewWidthAtColumn:(NSInteger)column {
//    CGFloat width = self.preferWidthPerColumn;
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:widthAtColumn:)]) {
//        width = [self.delegate stockListView:self widthAtColumn:column];
//    }
//    return width;
//}
//
//#pragma mark -- UIScrollViewDelegate
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    UIScrollView *hScrollView = [self.headerView viewWithTag:kHeaderScrollViewTag];;
//	if ([scrollView isEqual:hScrollView]) {
//		[self.scrollView setContentOffset:scrollView.contentOffset animated:NO];
//	} else if ([scrollView isEqual:self.scrollView]) {
//		[hScrollView setContentOffset:scrollView.contentOffset animated:NO];
//	}
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    UIScrollView *hScrollView = [self.headerView viewWithTag:kHeaderScrollViewTag];;
//	BOOL hScrolling = hScrollView.isDragging || hScrollView.isDecelerating || hScrollView.isTracking;
//	BOOL scrolling = self.scrollView.isDragging || self.scrollView.isDecelerating || self.scrollView.isTracking;
//
//	if ([scrollView isEqual:hScrollView] && scrolling == NO) {
//		[self.scrollView setContentOffset:scrollView.contentOffset animated:NO];
//	} else if ([scrollView isEqual:self.scrollView] && hScrolling == NO) {
//		[hScrollView setContentOffset:scrollView.contentOffset animated:NO];
//	}
//}
//
//- (NSInteger)numberOfColumns {
//    NSInteger num = 0;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfColumnsInListView:)]) {
//        num = [self.delegate numberOfColumnsInListView:self];
//    }
//    return num;
//}
//
//- (void)longGesture:(UIGestureRecognizer *)gesture {
//	if (gesture.state == UIGestureRecognizerStateBegan) {
//		CGPoint location = [gesture locationInView:self.tableView];
//		NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
//		if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:didBegainLongPressAtRow:)]) {
//			[self.delegate stockListView:self didBegainLongPressAtRow:indexPath.row];
//		}
//	}
//}
//
//- (UITableView *)tableView {
//	if (!_tableView) {
//		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.headerView.frame), CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.headerView.frame)) style:UITableViewStylePlain];
//		_tableView.dataSource = self;
//		_tableView.delegate = self;
//		UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
//		[_tableView addGestureRecognizer:longPress];
//	}
//	return _tableView;
//}
//
//- (SLScrollView *)scrollView {
//	if (!_scrollView) {
//		_scrollView = [[SLScrollView alloc] init];
//		_scrollView.showsHorizontalScrollIndicator = NO;
//		_scrollView.delegate = self;
//	}
//	return _scrollView;
//}
//
//- (UIView *)headerView {
//	if (!_headerView) {
//		_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), self.headerHeight)];
//		UIScrollView *scrollView = [[UIScrollView alloc] init];
//		scrollView.delegate = self;
//		scrollView.showsHorizontalScrollIndicator = NO;
//		scrollView.tag = kHeaderScrollViewTag;
//		[_headerView addSubview:scrollView];
//
//		UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_headerView.frame) - 0.5, CGRectGetWidth(_headerView.frame), 0.5)];
//		shadowView.backgroundColor = [UIColor grayColor];
//		[_headerView addSubview:shadowView];
//	}
//	return _headerView;
//}
//
//@end


#import "GJStockListView.h"
#import "MTNScrollableTableViewCell.h"

@interface MTNStockListView () <UITableViewDelegate, UITableViewDataSource, MTNScrollableTableViewCellDelegate>

@property (nonatomic, strong, readwrite) UITableView *tableView;

@property (nonatomic, assign) CGFloat contentOffsetX;

@end

@implementation MTNStockListView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGSizeEqualToSize(self.frame.size, self.tableView.frame.size) == NO) {
        self.tableView.frame = self.bounds;
        [self.tableView reloadData];
    }
}

#pragma mark - MTNScrollableTableViewCellDelegate

- (nonnull NSAttributedString *)scrollableTableViewCell:(nonnull MTNScrollableTableViewCell *)cell attributedStringForItem:(NSInteger)item {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    return [self attributedStringForItem:item row:indexPath.row section:indexPath.section];
}

- (CGSize)scrollableTableViewCell:(nonnull MTNScrollableTableViewCell *)cell sizeForItem:(NSInteger)item {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CGFloat rowHeight = [self heightForRow:indexPath.row section:indexPath.section];
    CGFloat width = [self widthForItem:item section:indexPath.section];
    return CGSizeMake(width, rowHeight);
}

- (void)scrollableTableViewCell:(MTNScrollableTableViewCell *)cell didScrollToOffsetX:(CGFloat)x {
    self.contentOffsetX  = x;
    NSArray *visCells = [self.tableView visibleCells];
    for (MTNScrollableTableViewCell *visCell in visCells) {
        if ([visCell isEqual:cell] == NO) {
            [visCell setContentOffsetX:x];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForRow:indexPath.row section:indexPath.section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTNScrollableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MTNScrollableTableViewCell.class)];
    if (cell == nil) {
        cell = [[MTNScrollableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(MTNScrollableTableViewCell.class)];
        cell.delegate = self;
        cell.initialContentOffetX = self.contentOffsetX;
    }
    
    [cell loadAttributedTexts:[self attributedTextsAtIndexPath:indexPath]];
    return cell;
}

- (NSArray <NSAttributedString *>*)attributedTextsAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemCount = [self numberOfItemInSection:indexPath.section];
    NSMutableArray *mAttris = [NSMutableArray arrayWithCapacity:itemCount];
    for (NSInteger i = 0; i < itemCount; i ++) {
        [mAttris addObject:[self attributedStringForItem:i row:indexPath.row section:indexPath.section]];
    }
    return mAttris.copy;
}

#pragma mark - Getter

- (NSInteger)numberOfSections {
    NSInteger section = 1; // default 1
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfSectionInStockListView:)]) {
        section = [self.delegate numberOfSectionInStockListView:self];
    }
    return section;
}

- (NSInteger)numberOfRowInSection:(NSInteger)section {
    NSInteger row = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:numOfRowInSection:)]) {
        row = [self.delegate stockListView:self numOfRowInSection:section];
    }
    return row;
}

- (NSInteger)numberOfItemInSection:(NSInteger)section {
    NSInteger item = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:numOfItemInSection:)]) {
       item = [self.delegate stockListView:self numOfItemInSection:section];
    }
    return item;
}

- (CGFloat)heightForRow:(NSInteger)row section:(NSInteger)section {
    CGFloat height = 0.0f;
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:heightForRow:section:)]) {
        height = [self.delegate stockListView:self heightForRow:row section:section];
    }
    return height;
}

- (CGFloat)widthForItem:(NSInteger)item section:(NSInteger)section {
    CGFloat width = 0.0f;
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:widthForItem:section:)]) {
        width = [self.delegate stockListView:self widthForItem:item section:section];
    }
    return width;
}

- (NSAttributedString *)attrbutedStringForHeaderItem:(NSInteger)item section:(NSInteger)section {
    NSAttributedString *attri = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:attributedStringForHeaderItem:section:)]) {
        attri = [self.delegate stockListView:self attributedStringForHeaderItem:item section:section];
    }
    return attri;
}

- (NSAttributedString *)attributedStringForItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section {
    NSAttributedString *attri = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:attributedStringForItem:row:section:)]) {
        attri = [self.delegate stockListView:self attributedStringForItem:item row:row section:section];
    }
    return attri;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
