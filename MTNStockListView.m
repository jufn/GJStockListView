//
//  MTNStockListView.m
//  GJStockListView
//
//  Created by 陈俊峰 on 2021/4/12.
//

#import "MTNStockListView.h"

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

@interface MTNStockListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MTNStockListViewForwardTarget *forwardTarget;

@end

@implementation MTNStockListView

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

- (instancetype)init {
    if (self = [super init]) {
        _forwardTarget = [MTNStockListViewForwardTarget new];
    }
    return self;
}

- (void)setDelegate:(id<MTNStockListViewDelegate>)delegate {
    super.delegate = self;
    self.forwardTarget.delegate = delegate;
}

- (id<MTNStockListViewDelegate>)delegate {
    return self.forwardTarget.delegate;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger num = 1;
    if ([self.forwardTarget.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        num = [self.forwardTarget.dataSource numberOfSectionsInTableView:tableView];
    }
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.forwardTarget.dataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL should = NO;
    if ([self.forwardTarget respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        should = [self.forwardTarget.dataSource stockListView:self shouldHorizontalScrollableAtSection:indexPath.section];
    }
    
    UITableViewCell *cell = nil;
    if (should) {
        NSString *identifier = [NSString stringWithFormat:@"%@_section_%zd", NSStringFromClass(UITableViewCell.class), indexPath.section];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

        
        
        
    } else {
        cell = [self.forwardTarget.dataSource tableView:self cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (void)setDataSource:(id<MTNStockListViewDataSource>)dataSource {
    super.dataSource = self;
    self.forwardTarget.dataSource = dataSource;
}

- (id<MTNStockListViewDataSource>)dataSource {
    return self.forwardTarget.dataSource;
}

@end


