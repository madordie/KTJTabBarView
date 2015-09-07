//
//  KTJTabBarView.m
//  KTJTabBarView
//
//  Created by 孙继刚 on 15/9/6.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import "KTJTabBarView.h"

#ifndef KTJWeak
#define KTJWeak(JSelf) __weak __typeof(&*(JSelf))weak##JSelf = JSelf
#endif

#ifndef KTJGetDivisor
#define KTJGetDivisor(JDiv) (JDiv!=0?JDiv:1)
#endif

@implementation KTJTabBarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self ktj_init];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self ktj_init];
    }
    return self;
}
- (void)ktj_init {
    self.scrollEnabled = YES;
    self.itemMinWidth = 80;
    self.selectIndex = 0;
    self.itemDistance = 2;
    self.selectStatusViewHeight = 2;
    
    _scrollView = [[UIScrollView alloc] init];
    [self addSubview:_scrollView];
    self.selectStatusView = [[UIView alloc] init];
    self.selectStatusView.backgroundColor = [UIColor redColor];
}

- (void)setup {
    
    NSMutableArray *itemViews = [NSMutableArray arrayWithCapacity:self.itemDataSource.count];
    {
        NSArray *oldViews = _scrollView.subviews;
        [oldViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        KTJWeak(self);
        [self.itemDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *item = [[UIButton alloc] init];
            if ([weakself.delegate respondsToSelector:@selector(ktjTabBarView:formatItemView:data:)]) {
                item = [weakself.delegate ktjTabBarView:weakself formatItemView:item data:obj];
            }
            [item addTarget:weakself action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:item];
            [itemViews addObject:item];
        }];
    }
    _itemViews = itemViews;
    
    if (!_itemViews.count) {
        return;
    }
    
    [_scrollView addSubview:self.selectStatusView];
    
    _scrollView.scrollEnabled = self.scrollEnabled;
    
    [self sizeToFit];
}

- (void)itemClick:(UIButton *)sender {
    self.selectIndex = [_itemViews indexOfObject:sender];
    if (self.itemDataSource.count>self.selectIndex && self.selectIndex>=0 && [self.delegate respondsToSelector:@selector(ktjTabBarView:selectItemView:data:)]) {
        [self.delegate ktjTabBarView:self selectItemView:sender data:self.itemDataSource[self.selectIndex]];
    }
}
- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
    if (_selectIndex<0 || _selectIndex>=_itemViews.count) {
        return;
    }
    
    UIView *selectView = _itemViews[_selectIndex];
    __block CGRect frame = self.selectStatusView.frame;
    frame.size.height = self.selectStatusViewHeight;
    frame.origin.y = _scrollView.contentSize.height - frame.size.height;
    self.selectStatusView.frame = frame;
    NSTimeInterval duration = 0.15;
    const CGFloat xMin = MIN(frame.origin.x, selectView.frame.origin.x);
    const CGFloat xMax = MAX(frame.origin.x+frame.size.width, selectView.frame.origin.x+selectView.frame.size.width);
    [UIView animateWithDuration:duration animations:^{
        CGFloat pellet = (xMax-xMin)*0.15;  //  做个稍微短一点点的弹性效果
        frame.origin.x = xMin+pellet;
        frame.size.width = xMax-xMin-pellet-pellet;
        self.selectStatusView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:duration animations:^{
                frame.origin.x = selectView.frame.origin.x;
                frame.size.width = selectView.frame.size.width;
                self.selectStatusView.frame = frame;
            }];
        }
    }];
    
    //  调整滚动的显示半拉的item 显示出来
    if (self.scrollEnabled) {
        CGFloat lrdist = self.itemMinWidth;
        CGPoint contentOffset = _scrollView.contentOffset;
        if (contentOffset.x+lrdist > selectView.frame.origin.x) {
            contentOffset.x = selectView.frame.origin.x-lrdist;
        } else if (contentOffset.x+_scrollView.frame.size.width < selectView.frame.origin.x+selectView.frame.size.width+lrdist) {
            contentOffset.x = selectView.frame.origin.x+selectView.frame.size.width+lrdist-_scrollView.frame.size.width;
        }
        contentOffset.x = MAX(0, contentOffset.x);
        contentOffset.x = MIN(_scrollView.contentSize.width-_scrollView.frame.size.width, contentOffset.x);
        [_scrollView setContentOffset:contentOffset animated:YES];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    __block CGRect frame;
    
    frame.size = size;
    frame.origin = CGPointZero;
    _scrollView.frame = frame;
    
    BOOL scrollEnabled = self.scrollEnabled;
    CGFloat itemDis = self.itemDistance;
    frame.origin = CGPointMake(itemDis, 0);
    frame.size = CGSizeMake(self.itemMinWidth, size.height);
    if (!scrollEnabled) {
        NSUInteger itemCount = _itemViews.count;
        frame.size.width = (_scrollView.frame.size.width-(itemCount+1)*itemDis)/KTJGetDivisor(itemCount);
    }
    [_itemViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (scrollEnabled) {
            obj.frame = frame;
            [obj sizeToFit];
            frame.size.width = MAX(frame.size.width, obj.frame.size.width);
            frame.size.height = MAX(frame.size.height, obj.frame.size.height);
        }
        obj.frame = frame;
        frame.origin.x += frame.size.width+itemDis;
    }];
    _scrollView.contentSize = CGSizeMake(frame.origin.x, frame.size.height);
    
    size.height = _scrollView.frame.origin.y + _scrollView.frame.size.height;
    
    self.selectIndex = self.selectIndex;
    
    return size;
}

@end
