//
//  MainTabBarController.m
//  GameBox
//
//  Created by 石燚 on 17/4/10.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()



@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

//初始化数据源
- (void)initDataSource {
    NSArray *viewControllerNames = @[@"HomeViewController", @"RankingListViewController", @"GiftBagViewController", @"MineViewController"];
    NSArray *titles = @[@"游戏", @"排行榜", @"礼包", @"我的"];
    NSArray *images = @[@"d_youxi_an", @"b_paihangbang_an-", @"a_libao_an", @"c_wode_an"];
    NSArray *selectImages = @[@"d_youxi_liang", @"b_paihangbang_liang", @"a_libao_liang", @"c_wode_liang"];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:4];
    
    [viewControllerNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //通过类名得到对应的类
        Class classname = NSClassFromString(obj);
        UIViewController *viewController = [[classname alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        //设置title
        viewController.navigationItem.title = titles[idx];
        viewController.navigationController.tabBarItem.title = titles[idx];
        
        viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[idx] image:[[UIImage imageNamed:images[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
        
        
        [viewControllers addObject:nav];
        
    }];
    self.viewControllers = viewControllers;
    
    
}

//初始化用户界面
- (void)initUserInterface {
    
    
}




@end







