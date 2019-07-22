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
	if (self.dataSource && [self.dataSource respondsToSelector:@selector(stockListTableViewCell:widthAtColumn:)]) {
		width = [self.dataSource stockListTableViewCell:self widthAtColumn:column];
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
