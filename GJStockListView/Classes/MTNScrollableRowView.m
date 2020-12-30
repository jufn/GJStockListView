//
//  MTNScrollableTableViewCell.m
//  MTNTrade
//
//  Created by 陈俊峰 on 2020/10/29.
//  Copyright © 2020 ytx. All rights reserved.
//

#import "MTNScrollableRowView.h"

static CGFloat const MTNScollableItemDefaultWidth = 100.0f;

@interface MTNScrollableCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLab;
@end

@implementation MTNScrollableCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLab];
        self.titleLab.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    }
    return self;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentRight;
    }
    return _titleLab;
}

@end

@interface MTNScrollableRowView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
static NSString * const MTNScrollableReuseIdentifier = @"MTNScrollableReuseIdentifier";
@implementation MTNScrollableRowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLab];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)loadAttributedText:(NSAttributedString *)attributedText item:(NSInteger)item {
    if (item == 0) {
        self.titleLab.attributedText = attributedText;
    } else {
        MTNScrollableCollectionViewCell *cell = (MTNScrollableCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item-1 inSection:0]];
        cell.titleLab.attributedText = attributedText;
    }
}

- (void)layoutSubviewsWithCellWidth:(CGFloat)width {
    CGSize size = [self sizeForItem:0];
    self.titleLab.frame = CGRectMake(0, 0, size.width, size.height);
    self.collectionView.frame = CGRectMake(size.width, 0, width - size.width, size.height);
}

- (void)reloadData {
    self.titleLab.attributedText = [self attributedStringForItem:0];
    [self.collectionView reloadData];
}

- (void)setContentOffsetX:(CGFloat)contentOffsetX {
    self.collectionView.contentOffset = CGPointMake(contentOffsetX, self.collectionView.contentOffset.y);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfItems];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTNScrollableCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MTNScrollableReuseIdentifier forIndexPath:indexPath];
    cell.titleLab.attributedText = [self attributedStringForItem:indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self sizeForItem:indexPath.item + 1];
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging + scrollView.isTracking + scrollView.isDecelerating) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(scrollableTableViewCell:didScrollToOffsetX:)]) {
            [self.delegate scrollableTableViewCell:self didScrollToOffsetX:scrollView.contentOffset.x];
        }
    }
}

#pragma mark - Setter&Getter

- (NSInteger)numberOfItems {
    NSInteger item = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItemsInScrollableTableViewCell:)]) {
        item = [self.delegate numberOfItemsInScrollableTableViewCell:self];
    }
    return item;
}

- (CGSize)sizeForItem:(NSInteger)item {
    CGSize size = CGSizeZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollableTableViewCell:sizeForItem:)]) {
        size = [self.delegate scrollableTableViewCell:self sizeForItem:item];
    }
    return size;
}

- (NSAttributedString *)attributedStringForItem:(NSInteger)item {
    NSAttributedString *attri = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollableTableViewCell:attributedStringForItem:)]) {
        attri = [self.delegate scrollableTableViewCell:self attributedStringForItem:item];
    }
    return attri;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:MTNScrollableCollectionViewCell.class forCellWithReuseIdentifier:MTNScrollableReuseIdentifier];
    }
    return _collectionView;;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
    }
    return _titleLab;
}

@end
