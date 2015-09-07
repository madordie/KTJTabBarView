//
//  KTJTabBarView.h
//  KTJTabBarView
//
//  Created by 孙继刚 on 15/9/6.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTJTabBarViewDelegate;
@interface KTJTabBarView : UIView {
    UIScrollView *_scrollView;
    NSArray *_itemViews;
}

@property (nonatomic, assign) BOOL scrollEnabled;   // Default YES. 是否滚动
@property (nonatomic, assign) CGFloat itemMinWidth; // Default 80.  最小宽度
@property (nonatomic, assign) CGFloat itemDistance; // Default 2.   距离
@property (nonatomic, strong) NSArray *itemDataSource;  //  数据源
@property (nonatomic, weak) id<KTJTabBarViewDelegate> delegate;

- (void)setup;

@property (nonatomic, assign) CGFloat selectStatusViewHeight;   // Default 2.   选择中提示框的高度
@property (nonatomic, assign) NSInteger selectIndex;    // Default 0.   当前选中的下标
@property (nonatomic, strong) UIView *selectStatusView; //  选中View

@end

@protocol KTJTabBarViewDelegate <NSObject>

- (UIButton *)ktjTabBarView:(KTJTabBarView *)tabbarView formatItemView:(UIButton *)itemView data:(id)data;

@optional
- (void)ktjTabBarView:(KTJTabBarView *)tabbarView selectItemView:(UIButton *)itemView data:(id)data;

@end



#if 0


self.tabBarView = [KTJTabBarView new];
self.tabBarView.scrollEnabled = NO;
self.tableView.backgroundColor = [UIColor grayColor];
self.tabBarView.frame = CGRectMake(0, 60, self.view.frame.size.width, 60);
self.tabBarView.itemDataSource = @[@"aaa", @"bbb", @"aaa", @"bbb", @"aaa", @"bbb", @"aaa", @"bbb", @"aaa", @"bbb", @"aaa"];
self.tabBarView.delegate = self;
[self.tabBarView setup];
[self.view addSubview:self.tabBarView];

pragma mark - < *** ViewController      代理     👇 ***>
- (void)ktjTabBarView:(KTJTabBarView *)tabbarView selectItemView:(UIButton *)itemView data:(id)data {
    //  选中了
}
- (UIButton *)ktjTabBarView:(KTJTabBarView *)tabbarView formatItemView:(UIButton *)itemView data:(id)data {
    [itemView setTitle:data forState:UIControlStateNormal];
    itemView.backgroundColor = [UIColor orangeColor];
    return itemView;
}


#endif