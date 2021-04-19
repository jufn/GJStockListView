//
//  NSIndexPath+StockList.m
//  GJStockListView
//
//  Created by 陈俊峰 on 2021/4/18.
//

#import "NSIndexPath+StockList.h"
#import <objc/runtime.h>

void *kStockListItemIndexKey = &kStockListItemIndexKey;

@implementation NSIndexPath (StockList)

- (void)setItemIndex:(NSInteger)itemIndex {
    objc_setAssociatedObject(self, kStockListItemIndexKey, @(itemIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)itemIndex {
    id val = objc_getAssociatedObject(self, kStockListItemIndexKey);
    return val ? [val integerValue] : NSNotFound;
}

@end
