//
//  MTNScrollableTableViewCell.m
//  MTNTrade
//
//  Created by 陈俊峰 on 2020/10/29.
//  Copyright © 2020 ytx. All rights reserved.
//

#import "MTNScrollableRowView.h"

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

@property (nonatomic, weak) id <MTNScrollableRowViewDelegate> delegate;
@property (nonatomic, assign) NSInteger numberOfItems;
@end
static NSString * const MTNScrollableReuseIdentifier = @"MTNScrollableReuseIdentifier";
@implementation MTNScrollableRowView


- (instancetype)initWithFrame:(CGRect)frame numberOfItems:(NSInteger)numberOfItems delegate:(id<MTNScrollableRowViewDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.numberOfItems = numberOfItems;
        [self addSubview:self.titleLab];
        [self addSubview:self.collectionView];
        
        CGSize size = [self sizeForItem:0];
        self.titleLab.frame = CGRectMake(0, 0, size.width, size.height);
        self.collectionView.frame = CGRectMake(size.width, 0, CGRectGetWidth(frame) - size.width, size.height);
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(rowView:didScrollToOffsetX:)]) {
            [self.delegate rowView:self didScrollToOffsetX:scrollView.contentOffset.x];
        }
    }
}

#pragma mark - Setter&Getter

- (CGSize)sizeForItem:(NSInteger)item {
    CGSize size = CGSizeZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(rowView:widthForItem:)]) {
        CGFloat width = [self.delegate rowView:self widthForItem:item];
        size = CGSizeMake(width, CGRectGetHeight(self.frame));
    }
    return size;
}

- (NSAttributedString *)attributedStringForItem:(NSInteger)item {
    NSAttributedString *attri = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(rowView:widthForItem:)]) {
        attri = [self.delegate rowView:self attributedStringForItem:item];
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
