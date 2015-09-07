# KTJTabBarView
常规自定义TabBarView.

#示例代码
```
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
```