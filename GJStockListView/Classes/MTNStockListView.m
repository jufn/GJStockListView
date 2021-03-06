//
//  MTNStockListView.m
//  GJStockListView
//
//  Created by 陈俊峰 on 2021/4/12.
//

#import "MTNStockListView.h"
#import "MTNScrollableRowView.h"

NSString *getSectionIdentifier(NSInteger section) {
    return [NSString stringWithFormat:@"MTNStockListView_Section_identifier_%zd", section];
}

@interface MTNSectionConfigure : NSObject
/// 偏移量
@property (nonatomic, assign) CGFloat contentOffsetX;
/// 弱引用cell
@property (nonatomic, strong) NSPointerArray *rowViews;
@end

@implementation MTNSectionConfigure
- (NSPointerArray *)rowViews {
    if (!_rowViews) {
        _rowViews = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
    }
    return _rowViews;
}
@end

@interface MTNStockListViewForwardTarget : NSObject <UITableViewDelegate, UITableViewDataSource, MTNScrollableRowViewDelegate>
@property (nonatomic, strong) NSMutableDictionary <NSString *, MTNSectionConfigure *> *sectionConfigure;

@property (nonatomic, weak) id <MTNStockListViewDelegate>delegate;
@property (nonatomic, weak) id <UITableViewDataSource>dataSource;
@property (nonatomic, weak) MTNStockListView *listView;
@end

@implementation MTNStockListViewForwardTarget

- (BOOL)respondsToSelector:(SEL)aSelector {
   BOOL header = [NSStringFromSelector(aSelector) containsString:@"viewForHeaderInSection"];
    
    if (header) {
        NSLog(@" ----- ");
    }
    return [super respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.delegate];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL should = NO;
    if ([self.delegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        should = [self.delegate stockListView:(MTNStockListView *)tableView shouldHorizontalScrollableAtSection:indexPath.section];
    }
    
    if (should == NO) {
        return [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    static NSInteger kScrollableRowViewTag = 10086l;
    NSString *identifier = getSectionIdentifier(indexPath.section);
    MTNSectionConfigure *configure = [self sectionConfigureAtSection:indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        CGFloat rowHeight = [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
        
        MTNScrollableRowView *view = [[MTNScrollableRowView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), rowHeight) numberOfItems:[self numberOfItemsAtSection:indexPath.section] delegate:self];
        view.tag = kScrollableRowViewTag;
        [cell.contentView addSubview:view];
        [configure.rowViews addPointer:(__bridge void *)view];
    }
    MTNScrollableRowView *rowView = [cell.contentView viewWithTag:kScrollableRowViewTag];
    [rowView setContentOffsetX:configure.contentOffsetX];
    rowView.indexPath = indexPath;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BOOL should = NO;
    if ([self.delegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        should = [self.delegate stockListView:(MTNStockListView *)tableView shouldHorizontalScrollableAtSection:section];
    }
    if (should == NO) {
        return [self.delegate tableView:tableView viewForHeaderInSection:section];
    }
    static NSInteger kScrollableHeaderRowViewTag = 10086l;
    MTNSectionConfigure *configure = [self sectionConfigureAtSection:section];
    NSString *identifier = getSectionIdentifier(section);
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (header == nil) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        
        CGFloat rowHeight = [self.delegate tableView:tableView heightForHeaderInSection:section];
        
        MTNScrollableRowView *view = [[MTNScrollableRowView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), rowHeight) numberOfItems:[self numberOfItemsAtSection:section] delegate:self];
        view.tag = kScrollableHeaderRowViewTag;
        [header.contentView addSubview:view];
        [configure.rowViews addPointer:(__bridge void *)view];
    }
    MTNScrollableRowView *rowView = [header.contentView viewWithTag:kScrollableHeaderRowViewTag];
    [rowView setContentOffsetX:configure.contentOffsetX];
    rowView.indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    rowView.isAddedToHeader = YES;
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource tableView:tableView numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger num = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        num = [self.dataSource numberOfSectionsInTableView:tableView];
    }
    return num;
}

#pragma mark - MTNScrollableTableViewCellDelegate

- (nonnull NSAttributedString *)rowView:(nonnull MTNScrollableRowView *)view attributedStringForItem:(NSInteger)item {
    NSAttributedString *attri = nil;
    if (view.isAddedToHeader) { // 头部
        attri = [self attrbutedStringForHeaderItem:item section:view.indexPath.section];
    } else {
        attri = [self attributedStringForItem:item row:view.indexPath.row section:view.indexPath.section];
    }
    return attri;
}

- (CGFloat)rowView:(nonnull MTNScrollableRowView *)view widthForItem:(NSInteger)item {
    NSIndexPath *indexPath = view.indexPath;
    CGFloat width = 0.0f;
    if ([self.delegate respondsToSelector:@selector(stockListView:widthForItem:section:)]) {
        width = [self.delegate stockListView:self.listView widthForItem:item section:indexPath.section];
    }
    return width;
}

- (void)rowView:(MTNScrollableRowView *)view didScrollToOffsetX:(CGFloat)x {
    MTNSectionConfigure *configure = [self sectionConfigureAtSection:view.indexPath.section];
    
    configure.contentOffsetX  = x;
    [configure.rowViews compact];
    for (MTNScrollableRowView *each in configure.rowViews) {
        if ([each isEqual:view] == NO) {
            [each setContentOffsetX:x];
        }
    }
}

- (void)rowView:(MTNScrollableRowView *)view didSelectedAtItem:(NSInteger)item {
    [self.listView selectRowAtIndexPath:view.indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:self.listView didSelectRowAtIndexPath:view.indexPath];
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (MTNSectionConfigure *)sectionConfigureAtSection:(NSInteger)section {
    NSString *identifier = getSectionIdentifier(section);
    MTNSectionConfigure *configure = self.sectionConfigure[identifier];
    if (configure == nil) {
        configure = [MTNSectionConfigure new];
        [self.sectionConfigure setObject:configure forKey:identifier];
    }
    return configure;
}

- (NSInteger)numberOfItemsAtSection:(NSInteger)section {
    NSInteger number = 0;
    if ([self.delegate respondsToSelector:@selector(stockListView:numberOfItemsAtSection:)]) {
        number = [self.delegate stockListView:self.listView numberOfItemsAtSection:section];
    }
    return number;
}

- (NSAttributedString *)attrbutedStringForHeaderItem:(NSInteger)item section:(NSInteger)section {
    NSAttributedString *attri = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:attributedStringForHeaderItem:section:)]) {
        attri = [self.delegate stockListView:self.listView attributedStringForHeaderItem:item section:section];
    }
    return attri;
}

- (NSAttributedString *)attributedStringForItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section {
    NSAttributedString *attri = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockListView:attributedStringForItem:row:section:)]) {
        attri = [self.delegate stockListView:self.listView attributedStringForItem:item row:row section:section];
    }
    return attri;
}

#pragma mark - Getter
- (NSMutableDictionary<NSString *,MTNSectionConfigure *> *)sectionConfigure {
    if (!_sectionConfigure) {
        _sectionConfigure = [NSMutableDictionary dictionary];
    }
    return _sectionConfigure;
}

@end

@interface MTNStockListView ()
@property (nonatomic, strong) MTNStockListViewForwardTarget *forwardTarget;
@end

@implementation MTNStockListView

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

- (void)setDelegate:(id<MTNStockListViewDelegate>)delegate {
    self.forwardTarget.delegate = delegate;
    super.delegate = nil;
    super.delegate = self.forwardTarget;
}

- (id<MTNStockListViewDelegate>)delegate {
    return self.forwardTarget.delegate;
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    self.forwardTarget.dataSource = dataSource;
    super.dataSource = nil;
    super.dataSource = self.forwardTarget;
}

- (id<UITableViewDataSource>)dataSource {
    return self.forwardTarget.dataSource;
}

- (MTNStockListViewForwardTarget *)forwardTarget {
    if (!_forwardTarget) {
        _forwardTarget = [MTNStockListViewForwardTarget new];
        _forwardTarget.listView = self;
    }
    return _forwardTarget;
}

@end
