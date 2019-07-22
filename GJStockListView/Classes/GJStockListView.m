//
//  GJStockListView.m
//  GJStockListView
//
//  Created by jufn on 2019/7/22.
//

#import "GJStockListView.h"
#import "GJStockListTableViewCell.h"

static NSString * const kGJStockListTableViewCellIdentifier = @"kGJStockListTableViewCellIdentifier";
static NSString * const kGJStockListTableViewContentSize = @"contentSize";

@interface GJStockListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GJStockListView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
		[self loadupUI];
		[self setInitialConfig];
		
		[self.tableView addObserver:self forKeyPath:kGJStockListTableViewContentSize options:NSKeyValueObservingOptionNew context:NULL];
		
	}
	return self;
}

- (void)loadupUI {
	[self addSubview:self.tableView];
	[self.tableView insertSubview:self.scrollView atIndex:0];
}

- (void)setInitialConfig {
	self.preferWidthPerColumn = 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows = 0;
	if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfRowsInListView:)]) {
		rows = [self.delegate numberOfRowsInListView:self];
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	GJStockListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGJStockListTableViewCellIdentifier];
	NSUInteger titleCount = [[self getHeaderTitles] count];
	if (!cell) {
		cell = [[GJStockListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGJStockListTableViewCellIdentifier numberOfColumnsPerRow:titleCount scrollView:self.scrollView];
	}
	
	for (int i = 0; i < titleCount; i ++) {
		UILabel *label = [cell labelAtColumn:i];
		NSAttributedString *attr = [self attributedStringAtRow:indexPath.row column:i];
		label.attributedText = attr;
	}
	
	return cell;;
}

- (void)reloadData {
	NSArray *titles = [self getHeaderTitles];
	
	NSParameterAssert(titles);
	NSParameterAssert(titles.count > 0);
	
	CGFloat width = MAX(self.preferWidthPerColumn * titles.count, CGRectGetWidth(self.frame));
	self.scrollView.frame = CGRectMake(0, 0, width, self.tableView.contentSize.height);
	
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if ([keyPath isEqualToString:kGJStockListTableViewContentSize]) {
		CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
		self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.height, size.height);
	}
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
		_tableView.dataSource = self;
		_tableView.delegate = self;
	}
	return _tableView;
}

- (UIScrollView *)scrollView {
	if (!_scrollView) {
		_scrollView = [[UIScrollView alloc] init];
	}
	return _scrollView;
}

@end
