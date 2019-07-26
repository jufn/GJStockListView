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
static const NSInteger kMinimumColumnPerRow = 2; // 最小两列， 小于两列没有意义

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
		
		[self.tableView addObserver:self forKeyPath:kGJStockListTableViewContentSize options:NSKeyValueObservingOptionNew context:NULL];
		[self.tableView addObserver:self forKeyPath:kGJStockListTableViewContentOffset options:NSKeyValueObservingOptionNew context:NULL];
		
	}
	return self;
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
	GJStockListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGJStockListTableViewCellIdentifier];
	NSUInteger titleCount = [[self getHeaderTitles] count];
	if (!cell) {
		cell = [[GJStockListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGJStockListTableViewCellIdentifier numberOfColumnsPerRow:titleCount scrollView:self.scrollView];
	}
	cell.dataSource = self;
	
	for (int i = 0; i < titleCount; i ++) {
		UILabel *label = [cell labelAtColumn:i];
		NSAttributedString *attr = [self attributedStringAtRow:indexPath.row column:i];
		label.attributedText = attr;
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
	}
	headerView.dataSource = self;
	headerView.scrollView.delegate = self;
	
	return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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

- (void)reloadData {
	NSArray *titles = [self getHeaderTitles];
	
	NSParameterAssert(titles);
	NSParameterAssert(titles.count >= kMinimumColumnPerRow);
	
	CGFloat width = MAX(self.preferWidthPerColumn * titles.count, CGRectGetWidth(self.frame));
	self.scrollView.frame = CGRectMake(self.preferWidthPerColumn, 0, CGRectGetWidth(self.tableView.frame) - self.preferWidthPerColumn, self.tableView.contentSize.height);
	self.scrollView.contentSize = CGSizeMake(width - self.preferWidthPerColumn, self.tableView.contentSize.height);
	
}

- (NSAttributedString *)attributedStringAtRow:(NSInteger)row
									column:(NSInteger)column {
	NSAttributedString *attrbute = nil;
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(listView:attributedStringAtRow:column:)]) {
		attrbute =	[self.delegate listView:self attributedStringAtRow:row column:column];
	}
	return attrbute;
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
