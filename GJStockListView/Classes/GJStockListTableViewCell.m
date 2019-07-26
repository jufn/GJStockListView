//
//  GJStockListTableViewCell.m
//  GJStockListView
//
//  Created by jufn on 2019/7/22.
//

#import "GJStockListTableViewCell.h"

@interface GJStockListTableViewCell ()
@property (nonatomic, copy) NSArray <UILabel *>* labels;
@end

@implementation GJStockListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
			  reuseIdentifier:(NSString *)reuseIdentifier
		numberOfColumnsPerRow:(NSUInteger)numberOfColumnsPerRow
				   scrollView:(UIScrollView *)scrollView {
	
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		self.contentView.backgroundColor = [UIColor clearColor];
		self.backgroundColor = [UIColor clearColor];
		[self loadUpUIWithScrollView:scrollView numberOfColumnsPerRow:numberOfColumnsPerRow];
	}
	return self;
	
}

- (UILabel *)labelAtColumn:(NSInteger)column {
	UILabel *lab = nil;
	
	if (NSLocationInRange(column, NSMakeRange(0, self.labels.count))) {
		lab = [self.labels objectAtIndex:column];
	}
	
	return lab;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	for (UILabel *lab in self.labels) {
		NSInteger i = [self.labels indexOfObject:lab];
		CGFloat posX = 0.0f, posY = 0.0f;
		
		if (i != 0) {
			CGPoint point = [self convertPoint:self.frame.origin toView:lab.superview];
			posY = point.y;
		}
		
		if (i > 1) {
			UILabel *preLab = [self.labels objectAtIndex:i - 1];
			posX = CGRectGetMaxX(preLab.frame);
		}
		
		CGFloat width = [self getWidthAtColumn:i];
		lab.frame = CGRectMake(posX, posY, width, CGRectGetHeight(self.frame));
	}
}

- (CGFloat)getWidthAtColumn:(NSInteger)column {
	CGFloat width = 0.0f;
	if (self.dataSource && [self.dataSource respondsToSelector:@selector(widthAtColumn:inView:)]) {
		width = [self.dataSource widthAtColumn:column inView:self];
	}
	return width;
}

- (void)loadUpUIWithScrollView:(UIScrollView *)scrollView
		 numberOfColumnsPerRow:(NSUInteger)numberOfColumnsPerRow {
	
	NSParameterAssert(numberOfColumnsPerRow > 0);
	NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:numberOfColumnsPerRow];
	for (int i = 0; i < numberOfColumnsPerRow; i ++) {
	
		UILabel *label = [[UILabel alloc] init];
		label.adjustsFontSizeToFitWidth = YES;
		[mArray addObject:label];
		
		if (i == 0) {
			[self.contentView addSubview:label];
		} else {
			[scrollView addSubview:label];
		}
		
	}
	
	self.labels = mArray;
}

@end



@interface GJStockListHeaderView ()
@property (nonatomic, copy) NSArray <UIButton *>*btns;
@end

@implementation GJStockListHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
						   headerTitles:(NSArray *)titles {
	
	if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
		[self.contentView addSubview:self.scrollView];
		[self loadUpUIWithTitles:titles];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	for (UIButton *btn in self.btns) {
		NSInteger i = [self.btns indexOfObject:btn];
		CGFloat posX = 0.0f, posY = 0.0f;
		
		if (i == 1) { // 布局scroll View
			UIButton *preBtn = [self.btns objectAtIndex:i - 1];

			self.scrollView.frame = CGRectMake(CGRectGetMaxX(preBtn.frame), posY, CGRectGetWidth(self.frame) - CGRectGetMaxX(preBtn.frame), CGRectGetHeight(preBtn.frame));
		} else if (i > 1) {
			UIButton *preBtn = [self.btns objectAtIndex:i - 1];
			posX = CGRectGetMaxX(preBtn.frame);
		}

		CGFloat width = [self getWidthAtColumn:i];
		btn.frame = CGRectMake(posX, posY, width, CGRectGetHeight(self.frame));
		if (i == self.btns.count - 1) {
			CGFloat wid = MAX(CGRectGetMaxX(btn.frame), CGRectGetWidth(self.scrollView.frame)) ;
			self.scrollView.contentSize = CGSizeMake(wid, self.scrollView.contentSize.height);
		}
	}
}

- (void)loadUpUIWithTitles:(NSArray *)titles {
	
	NSParameterAssert(titles.count > 0);
	NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:titles.count];
	for (NSString *title in titles) {
		NSInteger i = [titles indexOfObject:title];
		
		UIButton *button = [[UIButton alloc] init];
		[mArray addObject:button];
		[button setTitle:title forState:UIControlStateNormal];
		[button setTitle:title forState:UIControlStateHighlighted];
		[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
		[button addTarget:self action:@selector(tapHeaderBtn:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = i;
		
		if (i == 0) {
			[self.contentView addSubview:button];
		} else {
			[self.scrollView addSubview:button];
		}
	}
	self.btns = mArray;
}

- (void)tapHeaderBtn:(UIButton *)sender {
	
	if (self.didTapHeaderAtIndexBlock) {
		self.didTapHeaderAtIndexBlock(sender.tag);
	}
	
}

- (CGFloat)getWidthAtColumn:(NSInteger)column {
	CGFloat width = 0.0f;
	if (self.dataSource && [self.dataSource respondsToSelector:@selector(widthAtColumn:inView:)]) {
		width = [self.dataSource widthAtColumn:column inView:self];
	}
	return width;
}

- (UIScrollView *)scrollView {
	if (!_scrollView) {
		_scrollView = [[UIScrollView alloc] init];
	}
	return _scrollView;
}

@end
