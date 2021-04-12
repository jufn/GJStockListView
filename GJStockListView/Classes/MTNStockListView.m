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

@interface MTNStockListViewForwardTarget : NSObject

@property (nonatomic, weak) id <MTNStockListViewDelegate>delegate;
@property (nonatomic, weak) id <MTNStockListViewDataSource>dataSource;
@end

@implementation MTNStockListViewForwardTarget

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.delegate];
}
@end

@interface MTNStockListView () <UITableViewDelegate, UITableViewDataSource, MTNScrollableRowViewDelegate>

@property (nonatomic, strong) NSMutableDictionary <NSString *, MTNSectionConfigure *> *sectionConfigure;
@property (nonatomic, strong) MTNStockListViewForwardTarget *forwardTarget;

@end

@implementation MTNStockListView

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

- (void)setDelegate:(id<MTNStockListViewDelegate>)delegate {
    super.delegate = self;
    self.forwardTarget.delegate = delegate;
}

- (id<MTNStockListViewDelegate>)delegate {
    return self.forwardTarget.delegate;
}

- (void)setDataSource:(id<MTNStockListViewDataSource>)dataSource {
    super.dataSource = self;
    self.forwardTarget.dataSource = dataSource;
}

- (id<MTNStockListViewDataSource>)dataSource {
    return self.forwardTarget.dataSource;
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
    CGFloat width = 0.0f;
    if ([self.delegate respondsToSelector:@selector(stockListView:widthForItem:section:)]) {
        width = [self.delegate stockListView:self widthForItem:item section:indexPath.section];
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

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger num = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        num = [self.dataSource numberOfSectionsInTableView:tableView];
    }
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL should = NO;
    if ([self.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        should = [self.dataSource stockListView:self shouldHorizontalScrollableAtSection:indexPath.section];
    }
    
    if (should == NO) {
        return [self.dataSource tableView:self cellForRowAtIndexPath:indexPath];
    }
    
    static NSInteger kScrollableRowViewTag = 10086l;
    NSString *identifier = getSectionIdentifier(indexPath.section);
    MTNSectionConfigure *configure = [self sectionConfigureAtSection:indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        CGFloat rowHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
        
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
    if ([self.dataSource respondsToSelector:@selector(stockListView:numberOfItemsAtSection:)]) {
        number = [self.dataSource stockListView:self numberOfItemsAtSection:section];
    }
    return number;
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

#pragma mark - Getter
- (NSMutableDictionary<NSString *,MTNSectionConfigure *> *)sectionConfigure {
    if (!_sectionConfigure) {
        _sectionConfigure = [NSMutableDictionary dictionary];
    }
    return _sectionConfigure;
}

- (MTNStockListViewForwardTarget *)forwardTarget {
    if (!_forwardTarget) {
        _forwardTarget = [MTNStockListViewForwardTarget new];
    }
    return _forwardTarget;
}

@end


