//
//  GJStockListView.m
//  GJStockListView
//
//  Created by jufn on 2019/7/22.
//

#import "GJStockListView.h"

static NSString * const kGJStockListTableViewCellIdentifier = @"kGJStockListTableViewCellIdentifier";
static NSString * const kGJStockListHeaderViewIdentifier 	= @"GJStockListHeaderViewIdentifier";
static NSString * const kGJStockListTableViewContentSize 	= @"contentSize";
static NSString * const kGJStockListTableViewContentOffset 	= @"contentOffset";
static NSInteger  const kHeaderScrollViewTag = 1000;

@interface SLScrollView : UIScrollView

@end

@implementation SLScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if ([[self nextResponder] isKindOfClass:[UITableView class]]) {
		UITouch *touch = touches.anyObject;
		if (touch == nil) {
			return;
		}
		UITableView *tableView = (UITableView *)[self nextResponder];
		CGPoint point = [touch locationInView:tableView];
		NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:point];
		[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([[self nextResponder] isKindOfClass:[UITableView class]]) {
		UITouch *touch = touches.anyObject;
		if (touch == nil) {
			return;
		}
		UITableView *tableView = (UITableView *)[self nextResponder];
		CGPoint point = [touch locationInView:tableView];
		NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:point];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([[self nextResponder] isKindOfClass:[UITableView class]]) {
		UITouch *touch = touches.anyObject;
		if (touch == nil) {
			return;
		}
		UITableView *tableView = (UITableView *)[self nextResponder];
		CGPoint point = [touch locationInView:tableView];
		NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:point];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

@end

NSInteger getCellSubViewTag(NSInteger row, NSInteger column) {
    return column * 10000 + row;
}

void getRowAndColumnWithTag(NSInteger tag, NSInteger *row, NSInteger *column) {
    *row = tag % 10000;
    *column = tag / 10000;
}

@interface GJStockListView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong) SLScrollView *scrollView;

@end

@implementation GJStockListView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
		[self setInitialConfig];
		[self loadupUI];
        [self layoutScrollView];
        
		[self.tableView addObserver:self forKeyPath:kGJStockListTableViewContentSize options:NSKeyValueObservingOptionNew context:NULL];
		[self.tableView addObserver:self forKeyPath:kGJStockListTableViewContentOffset options:NSKeyValueObservingOptionNew context:NULL];
		
	}
	return self;
}

- (void)reloadData {
    [self layoutScrollView];
    [self.tableView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if ([keyPath isEqualToString:kGJStockListTableViewContentSize]) {
		CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
		
		CGRect frame = self.scrollView.frame;
		self.scrollView.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), size.height);
		self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, size.height);
		
	}
}

- (void)loadupUI {
	[self addSubview:self.tableView];

	[self.tableView addSubview:self.scrollView];
	[self.tableView sendSubviewToBack:self.scrollView];
}

- (void)layoutScrollView {
    CGFloat width = 0.0f;
    for (int i = 0; i < [self numberOfColumns]; i ++) {
        if (i == 0) {
            continue;
        }
        
        CGFloat width_i = [self itemViewWidthAtColumn:i];
        width += width_i;
    }
    width =   MAX(width, CGRectGetWidth(self.frame));
    
    CGFloat firstColumnWidth = [self itemViewWidthAtColumn:0];
    self.scrollView.frame = CGRectMake(firstColumnWidth, 0, CGRectGetWidth(self.tableView.frame) - firstColumnWidth, self.tableView.contentSize.height);
    self.scrollView.contentSize = CGSizeMake(width, self.tableView.contentSize.height);
}

- (void)setInitialConfig {
	self.preferWidthPerColumn = 90.0f;
	self.tableRowHeight = 44.0f;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows = 0;
	if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfRowsInListView:)]) {
		rows = [self.delegate numberOfRowsInListView:self];
	}
	return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.tableRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGJStockListTableViewCellIdentifier];
    NSUInteger count = [self numberOfColumns];

	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGJStockListTableViewCellIdentifier];
        CGPoint itemOri = CGPointZero;
        for (int i = 0; i < count; i ++) {
            UIView *view = [self itemViewAtRow:indexPath.row column:i];
            if (view == nil) {
                continue;
            }
            view.tag = getCellSubViewTag(indexPath.row, i);
            CGFloat width = [self itemViewWidthAtColumn:i];
            // lay out subviews
            if (i == 0) {
                [cell.contentView addSubview:view];
                view.frame = CGRectMake(itemOri.x, itemOri.y, width, self.tableRowHeight);
            } else {
                [self.scrollView addSubview:view];
                itemOri.y = indexPath.row * self.tableRowHeight;
                view.frame = CGRectMake(itemOri.x, itemOri.y, width, self.tableRowHeight);
                itemOri.x += width;
            }
        }
    } else {
        // 对复用的， 重新调整frame
        UIView *view = cell.contentView.subviews.firstObject;
        if (view) {
            NSInteger row = 0, column = 0;
            getRowAndColumnWithTag(view.tag, &row, &column);
            
            for (int i = 0; i < count; i ++) {
                if (i == 0) {
                    view.tag = getCellSubViewTag(indexPath.row, i);
                } else {
                    UIView *subView = [self.scrollView viewWithTag:getCellSubViewTag(row, i)];
                    CGFloat posY = indexPath.row * self.tableRowHeight;
                    subView.frame = CGRectMake(CGRectGetMinX(subView.frame), posY, CGRectGetWidth(subView.frame), CGRectGetHeight(subView.frame));
                    subView.tag = getCellSubViewTag(indexPath.row, i);
                }
                
            }
        }
    }

    for (int i = 0; i < count; i ++) {
        UIView *view = nil;
        
        if (i == 0) {
            view = [cell.contentView viewWithTag:getCellSubViewTag(indexPath.row, i)];
        } else {
            view = [self.scrollView viewWithTag:getCellSubViewTag(indexPath.row, i)];
        }
        
        if (view == nil) { //  空白
            continue;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:reloadingItemView:atRow:column:)]) {
            [self.delegate stockListView:self reloadingItemView:view atRow:indexPath.row column:i];
        }
    }
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return self.tableRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGJStockListHeaderViewIdentifier];
	if (headerView == nil) {
		headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kGJStockListHeaderViewIdentifier];
        
        CGFloat firstColumnWidth = [self itemViewWidthAtColumn:0];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(firstColumnWidth, 0, CGRectGetWidth(tableView.frame) - firstColumnWidth, self.tableRowHeight)];
        
		[scrollView addObserver:self forKeyPath:kGJStockListTableViewContentOffset options:NSKeyValueObservingOptionNew context:NULL];
        scrollView.delegate = self;
        scrollView.tag = kHeaderScrollViewTag;
        [headerView.contentView addSubview:scrollView];
        
        NSUInteger count = [self numberOfColumns];
        CGPoint itemOri = CGPointZero;
        for (int i = 0; i < count; i ++) {
            UIView *view = [self headeViewAtColumn:i];
            if (view == nil) {
                continue;
            }
            CGFloat width = [self itemViewWidthAtColumn:i];
            // lay out subviews
            if (i == 0) {
                [headerView.contentView addSubview:view];
                view.frame = CGRectMake(itemOri.x, itemOri.y, width, self.tableRowHeight);
            } else {
                [scrollView addSubview:view];
                view.frame = CGRectMake(itemOri.x, itemOri.y, width, self.tableRowHeight);
                itemOri.x += width;
            }
            
            if (i == count - 1) { // 最后一个
                scrollView.contentSize = CGSizeMake(CGRectGetMaxX(view.frame), CGRectGetHeight(headerView.frame));
            }
        }
        
    }
	
	return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)headeViewAtColumn:(NSInteger)column {
    UIView *headerView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:headerItemViewAtColumn:)]) {
        headerView = [self.delegate stockListView:self headerItemViewAtColumn:column];
    }
    return headerView;
}

- (UIView *)itemViewAtRow:(NSInteger)row column:(NSInteger)column {
    UIView *itemView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:itemViewAtRow:column:)]) {
      itemView =  [self.delegate stockListView:self itemViewAtRow:row column:column];
    }
    return itemView;
}

- (CGFloat)itemViewWidthAtColumn:(NSInteger)column {
    CGFloat width = self.preferWidthPerColumn;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:widthAtColumn:)]) {
        width = [self.delegate stockListView:self widthAtColumn:column];
    }
    return width;
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	UITableViewHeaderFooterView *headerView = [self.tableView headerViewForSection:0];
    UIScrollView *hScrollView = [headerView viewWithTag:kHeaderScrollViewTag];;
	if ([scrollView isEqual:hScrollView]) {
		[self.scrollView setContentOffset:scrollView.contentOffset animated:NO];
	} else if ([scrollView isEqual:self.scrollView]) {
		[hScrollView setContentOffset:scrollView.contentOffset animated:NO];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
    UITableViewHeaderFooterView *headerView = [self.tableView headerViewForSection:0];
    UIScrollView *hScrollView = [headerView viewWithTag:kHeaderScrollViewTag];;
	BOOL hScrolling = hScrollView.isDragging || hScrollView.isDecelerating || hScrollView.isTracking;
	BOOL scrolling = self.scrollView.isDragging || self.scrollView.isDecelerating || self.scrollView.isTracking;
	
	if ([scrollView isEqual:hScrollView] && scrolling == NO) {
		[self.scrollView setContentOffset:scrollView.contentOffset animated:NO];
	} else if ([scrollView isEqual:self.scrollView] && hScrolling == NO) {
		[hScrollView setContentOffset:scrollView.contentOffset animated:NO];
	}
}

- (NSInteger)numberOfColumns {
    NSInteger num = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfColumnsInListView:)]) {
        num = [self.delegate numberOfColumnsInListView:self];
    }
    return num;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
		_tableView.dataSource = self;
		_tableView.delegate = self;
	}
	return _tableView;
}

- (SLScrollView *)scrollView {
	if (!_scrollView) {
		_scrollView = [[SLScrollView alloc] init];
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.delegate = self;
	}
	return _scrollView;
}

@end
