//
//  GJRacView.m
//  GJStockListView_Example
//
//  Created by admin on 2020/3/7.
//  Copyright © 2020 jufn. All rights reserved.
//

#import "GJRacView.h"

@implementation GJRacView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor redColor];
        //创建一个按钮
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 70, 70)];
        btn.backgroundColor = [UIColor blueColor];
        [self addSubview:btn];
        
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self sendValue:@"1234" andDict:@{@"key" : @"value"}];
        }];
        
    }
    return self;
}



- (void)demo2 {
    //创建一个按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 70, 70)];
    btn.backgroundColor = [UIColor redColor];
    [self addSubview:btn];
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.subject sendNext:@"点击按钮了"];
    }];
}


- (RACSubject *)subject {
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
