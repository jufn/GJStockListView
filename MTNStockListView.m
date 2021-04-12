//
//  MTNStockListView.m
//  GJStockListView
//
//  Created by 陈俊峰 on 2021/4/12.
//

#import "MTNStockListView.h"

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

- (void)setDataSource:(id<MTNStockListViewDataSource>)dataSource {
    super.dataSource = self;
    self.forwardTarget.dataSource = dataSource;
}

- (id<MTNStockListViewDataSource>)dataSource {
    return self.forwardTarget.dataSource;
}

@end


