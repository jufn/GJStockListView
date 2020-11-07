//
//  MTNScrollableTableViewCell.m
//  MTNTrade
//
//  Created by 陈俊峰 on 2020/10/29.
//  Copyright © 2020 ytx. All rights reserved.
//

#import "MTNScrollableTableViewCell.h"

static CGFloat const MTNScollableItemDefaultWidth = 100.0f;

@interface MTNScrollableCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLab;
@end

@implementation MTNScrollableCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLab];
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

@interface MTNScrollableTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray <NSAttributedString *> *attributedTexts;

@end
static NSString * const MTNScrollableReuseIdentifier = @"MTNScrollableReuseIdentifier";
@implementation MTNScrollableTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
   
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTNScrollableCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MTNScrollableReuseIdentifier forIndexPath:indexPath];
    cell.titleLab.attributedText = [self attributedStringForItem:indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self sizeForItem:indexPath.item];
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark - Setter&Getter

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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

@end

@interface MTNScrollableHeaderView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray <NSAttributedString *> *attributedTexts;
@property (nonatomic, strong) UILabel *leftLabel;
@end

static NSString *const MTNScrollableHeaderViewReuseIdentifier = @"MTNScrollableHeaderViewReuseIdentifier";

@implementation MTNScrollableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
//    self.backgroundColor = [UIColor colorFromHexString:@"#141414"];
//    [self addSubview:self.leftLabel];
//    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self).mas_offset(10);
//        make.top.bottom.mas_equalTo(self);
//        make.width.mas_equalTo(120);
//    }];
//    [self addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.leftLabel.mas_right);
//        make.top.bottom.right.mas_equalTo(self);
//    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.attributedTexts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTNScrollableCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MTNScrollableReuseIdentifier forIndexPath:indexPath];
    cell.titleLab.attributedText = self.attributedTexts[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(MTNScollableItemDefaultWidth, CGRectGetHeight(self.frame));
}

#pragma mark -scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark - Setter&Getter

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:13];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.text = @"名称代码";
    }
    return _leftLabel;
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

@end
