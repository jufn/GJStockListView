
#import "GJStockListView.h"
#import "MTNScrollableRowView.h"

const NSInteger kMTNScrollableRowTag = 100000;

@interface MTNStockListView () <UITableViewDelegate, UITableViewDataSource, MTNScrollableRowViewDelegate>

@property (nonatomic, strong, readwrite) UITableView *tableView;

@property (nonatomic, assign) CGFloat contentOffsetX;

@property (nonatomic, strong) NSMapTable *map;

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

- (NSInteger)numberOfItemsInScrollableTableViewCell:(MTNScrollableRowView *)cell {
    return [self numberOfItemInSection:cell.indexPath.section];
}

- (nonnull NSAttributedString *)scrollableTableViewCell:(nonnull MTNScrollableRowView *)cell attributedStringForItem:(NSInteger)item {
    NSIndexPath *indexPath = cell.indexPath;
    return [self attributedStringForItem:item row:indexPath.row section:indexPath.section];
}

- (CGSize)scrollableTableViewCell:(nonnull MTNScrollableRowView *)cell sizeForItem:(NSInteger)item {
    NSIndexPath *indexPath = cell.indexPath;
    CGFloat rowHeight = [self heightForRow:indexPath.row section:indexPath.section];
    CGFloat width = [self widthForItem:item section:indexPath.section];
    return CGSizeMake(width, rowHeight);
}

- (void)scrollableTableViewCell:(MTNScrollableRowView *)cell didScrollToOffsetX:(CGFloat)x {
    self.contentOffsetX  = x;
    NSArray *visCells = [self.tableView visibleCells];
    for (UITableViewCell *visCell in visCells) {
        MTNScrollableRowView *visView = [visCell viewWithTag:kMTNScrollableRowTag];
        if ([visView isEqual:cell] == NO) {
            [visView setContentOffsetX:x];
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
    MTNScrollableRowView *view = [[MTNScrollableRowView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), [self heightForHeaderInSection:section])];
    
    return view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%@_section_%zd", NSStringFromClass(UITableViewCell.class), indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        MTNScrollableRowView *view = [[MTNScrollableRowView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), [self heightForRow:indexPath.row section:indexPath.section])];
        view.delegate = self;
        [view layoutSubviewsWithCellWidth:CGRectGetWidth(tableView.frame)];
        view.tag = kMTNScrollableRowTag;
        
        [cell.contentView addSubview:view];
    }
    MTNScrollableRowView *rowView = [cell.contentView viewWithTag:kMTNScrollableRowTag];
    [rowView reloadData];
    [rowView setContentOffsetX:self.contentOffsetX];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:heightForHeaderInsection:)]) {
        height = [self.delegate stockListView:self heightForHeaderInsection:section];
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

@end
