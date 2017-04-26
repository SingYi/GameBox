//
//  SearchResultViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/26.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()<UISearchResultsUpdating>

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchController.hidesNavigationBarDuringPresentation = NO;
    searchController.obscuresBackgroundDuringPresentation = NO;
    searchController.dimsBackgroundDuringPresentation = NO;
    
    NSLog(@"result");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
