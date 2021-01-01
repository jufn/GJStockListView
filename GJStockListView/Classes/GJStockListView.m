
#import "GJStockListView.h"
#import "MTNScrollableRowView.h"

const NSInteger kMTNScrollableRowTag = 100000;

@interface MTNSectionItem : NSObject
/// 偏移量
@property (nonatomic, assign) CGFloat contentOffsetX;
/// 弱引用cell
@property (nonatomic, strong) NSPointerArray *rowViews;
@end

@implementation MTNSectionItem
- (NSPointerArray *)rowViews {
    if (!_rowViews) {
        _rowViews = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
    }
    return _rowViews;
}
@end

@interface MTNStockListView () <UITableViewDelegate, UITableViewDataSource, MTNScrollableRowViewDelegate>

@property (nonatomic, strong, readwrite) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary <NSString *, MTNSectionItem *> *mapper;

@end

@implementation MTNStockListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tableView];
    }
    return self;
}

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

- (nonnull NSAttributedString *)rowView:(nonnull MTNScrollableRowView *)view attributedStringForItem:(NSInteger)item {
    NSAttributedString *attri = nil;
    if (view.indexPath.row == kSectionHeaderRowFlag) { // 头部
        attri = [self attrbutedStringForHeaderItem:item section:view.indexPath.section];
    } else {
        attri = [self attributedStringForItem:item row:view.indexPath.row section:view.indexPath.section];
    }
    return attri;
}

- (CGFloat)rowView:(nonnull MTNScrollableRowView *)view widthForItem:(NSInteger)item {
    NSIndexPath *indexPath = view.indexPath;
    return [self widthForItem:item section:indexPath.section];
}

- (void)rowView:(MTNScrollableRowView *)view didScrollToOffsetX:(CGFloat)x {
    MTNSectionItem *item = [self itemAtSection:view.indexPath.section];
    item.contentOffsetX  = x;
    [item.rowViews compact];
    for (MTNScrollableRowView *each in item.rowViews) {
        if ([each isEqual:view] == NO) {
            [each setContentOffsetX:x];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MTNSectionItem *item = [self itemAtSection:section];
    MTNScrollableRowView *view = [[MTNScrollableRowView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), [self heightForHeaderInSection:section]) numberOfItems:[self numberOfItemInSection:section] delegate:self];
    view.indexPath = [NSIndexPath indexPathForRow:kSectionHeaderRowFlag inSection:section];
    [item.rowViews addPointer:(__bridge void *)view];
    view.titleLab.attributedText = [self attrbutedStringForHeaderItem:0 section:section];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%@_section_%zd", NSStringFromClass(UITableViewCell.class), indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    MTNSectionItem *item = [self itemAtSection:indexPath.section];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        MTNScrollableRowView *view = [[MTNScrollableRowView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), [self heightForRow:indexPath.row section:indexPath.section]) numberOfItems:[self numberOfItemInSection:indexPath.section] delegate:self];
        view.tag = kMTNScrollableRowTag;
        [cell.contentView addSubview:view];
        [item.rowViews addPointer:(__bridge void *)view];
    }
    MTNScrollableRowView *rowView = [cell.contentView viewWithTag:kMTNScrollableRowTag];
    [rowView setContentOffsetX:item.contentOffsetX];
    rowView.indexPath = indexPath;
    rowView.titleLab.attributedText = [self attributedStringForItem:0 row:indexPath.row section:indexPath.section];
    
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

- (MTNSectionItem *)itemAtSection:(NSInteger)section {
    NSString *key = [NSString stringWithFormat:@"%zd", section];
    MTNSectionItem *item = self.mapper[key];
    if (item == nil) {
        item = [[MTNSectionItem alloc] init];
        [self.mapper setValue:item forKey:key];
    }
    return item;
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

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    CGFloat height = CGFLOAT_MIN;
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:heightForHeaderInSection:)]) {
        height = [self.delegate stockListView:self heightForHeaderInSection:section];
    }
    return height;
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
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (NSMutableDictionary<NSString *,MTNSectionItem *> *)mapper {
    if (!_mapper) {
        _mapper = [NSMutableDictionary dictionary];
    }
    return _mapper;
}

@end
