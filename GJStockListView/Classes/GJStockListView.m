//
//  GJStockListView.m
//  GJStockListView
//
//  Created by jufn on 2019/7/22.
//

#import "GJStockListView.h"
#import "GJStockListTableViewCell.h"

static NSString * const kGJStockListTableViewCellIdentifier = @"kGJStockListTableViewCellIdentifier";
static NSString * const kGJStockListHeaderViewIdentifier 	= @"GJStockListHeaderViewIdentifier";
static NSString * const kGJStockListTableViewContentSize 	= @"contentSize";
static NSString * const kGJStockListTableViewContentOffset 	= @"contentOffset";

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

@interface GJStockListView () <UITableViewDelegate, UITableViewDataSource, GJStockListItemDataSource, UIScrollViewDelegate>
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
    NSArray *titles = [self getHeaderTitles];
    CGFloat width = 0.0f;
    for (int i = 0; i < titles.count; i ++) {
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
    NSUInteger titleCount = [[self getHeaderTitles] count];

	if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGJStockListTableViewCellIdentifier];
        CGPoint itemOri = CGPointZero;
        for (int i = 0; i < titleCount; i ++) {
            UIView *view = [self itemViewAtRow:indexPath.row column:i];
            if (view == nil) {
                continue;
            }
            CGFloat width = [self itemViewWidthAtColumn:i];
            // lay out subviews
            if (i == 0) {
                [cell.contentView addSubview:view];
                view.frame = CGRectMake(itemOri.x, itemOri.y, width, self.tableRowHeight);
            } else {
                [self.scrollView addSubview:view];
                itemOri.y = [cell convertPoint:cell.frame.origin toView:self.scrollView].y;
                view.frame = CGRectMake(itemOri.x, itemOri.y, width, self.tableRowHeight);
                itemOri.x += width;
            }
        }
	}

    for (int i = 0; i < titleCount; i ++) {
        UIView *view = [self itemViewAtRow:indexPath.row column:i];
        if (view == nil) { //  空白
            continue;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:reloadingItemView:atRow:column:)]) {
            [self.delegate stockListView:self reloadingItemView:view atRow:indexPath.row column:i];
        }
    }
	return cell;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return self.tableRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	GJStockListHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGJStockListHeaderViewIdentifier];
	if (headerView == nil) {
		headerView = [[GJStockListHeaderView alloc] initWithReuseIdentifier:kGJStockListHeaderViewIdentifier headerTitles:[self getHeaderTitles]];
		[headerView.scrollView addObserver:self forKeyPath:kGJStockListTableViewContentOffset options:NSKeyValueObservingOptionNew context:NULL];
        headerView.dataSource = self;
        headerView.scrollView.delegate = self;
	}
	
	return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
	GJStockListHeaderView *headerView = (GJStockListHeaderView *)[self.tableView headerViewForSection:0];
	
	UIScrollView *hScrollView = headerView.scrollView;
	if ([scrollView isEqual:hScrollView]) {
		[self.scrollView setContentOffset:scrollView.contentOffset animated:NO];
	} else if ([scrollView isEqual:self.scrollView]) {
		[headerView.scrollView setContentOffset:scrollView.contentOffset animated:NO];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	GJStockListHeaderView *headerView = (GJStockListHeaderView *)[self.tableView headerViewForSection:0];
	
	UIScrollView *hScrollView = headerView.scrollView;
	
	BOOL hScrolling = hScrollView.isDragging || hScrollView.isDecelerating || hScrollView.isTracking;
	BOOL scrolling = self.scrollView.isDragging || self.scrollView.isDecelerating || self.scrollView.isTracking;
	
	if ([scrollView isEqual:hScrollView] && scrolling == NO) {
		[self.scrollView setContentOffset:scrollView.contentOffset animated:NO];
	} else if ([scrollView isEqual:self.scrollView] && hScrolling == NO) {
		[headerView.scrollView setContentOffset:scrollView.contentOffset animated:NO];
	}
}

#pragma mark -- GJStockListItemDataSource
#pragma mark

- (CGFloat)widthAtColumn:(NSInteger)column inView:(UIView *)view {
	return self.preferWidthPerColumn;
}

- (NSArray *)getHeaderTitles {
	NSArray *titles = nil;
	if (self.delegate && [self.delegate respondsToSelector:@selector(titlesForListViewHeader:)]) {
		titles = [self.delegate titlesForListViewHeader:self];
	}
	return titles;
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
