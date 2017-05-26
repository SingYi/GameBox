//
//  SearchViewController.m
//  GameBox
//
//  Created by 石燚 on 17/4/10.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "SearchViewController.h"
#import "GDLikesTableViewCell.h"
#import "SearchCollectionCell.h"

#import "ControllerManager.h"

#import "GameRequest.h"
#import "SearchModel.h"

#define CELLIDENTIFIER @"GDLikesTableViewCell"


@interface SearchViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,GDLikesTableViewCellDelegate>


//列表
@property (nonatomic, strong) UITableView *tableView;

//列表数据源
@property (nonatomic, strong) NSArray *showArray;

/** 热门游戏 */
@property (nonatomic, strong) NSArray *hotArray;
//@property (nonatomic, strong) NSArray *collectionArray;
//@property (nonatomic, strong) UICollectionView *collectionView;

/** 清除历史记录 */
@property (nonatomic, strong) UIButton *clearHistoryBtn;

@end

@implementation SearchViewController


#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _showArray = [SearchModel getSearchHistory];
    if (_showArray) {
        self.tableView.tableFooterView = self.clearHistoryBtn;
    } else {
        self.tableView.tableFooterView = [UIView new];
    }
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [self initDataSource];
    [self initUserInterface];
}

//初始化数据源
- (void)initDataSource {
    [self hotGame];
}

//初始化用户界面
- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self.view addSubview:self.tableView];
}

- (void)hotGame {
    [GameRequest searchHotGameCompletion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && !((NSString *)content[@"status"]).boolValue) {
            NSArray *array = content[@"data"];
            if (array.count > 4) {
                NSRange range = NSMakeRange(0, 4);
                _hotArray = [array subarrayWithRange:range];
//                range = NSMakeRange(3, array.count - 4);
//                _collectionArray = [array subarrayWithRange:range];
                
//                CGSize size = self.collectionView.contentSize;
//                self.collectionView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, size.height);
            } else {
//                _hotArray = array;
//                _collectionArray = nil;
            }
//            [self.collectionView reloadData];
            [self.tableView reloadData];
        }
        
//        syLog(@"%@",content);
    }];
}

#pragma mark - respond
- (void)clickClearHistoryBtn {
    if (self.showArray) {
        
        [SearchModel clearSearchHistory];
        self.showArray = nil;
        
        self.tableView.tableFooterView = [UIView new];
        
        [self.tableView reloadData];
    }
}

#pragma mark - method

#pragma mark - cellDelegate
- (void)GDLikesTableViewCell:(GDLikesTableViewCell *)cell clickGame:(NSDictionary *)dict {
    
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    
    [ControllerManager shareManager].detailView.gameID = dict[@"id"];
    
    [ControllerManager shareManager].detailView.gameLogo = dict[@"gameLogo"];
    
    [self.navigationController pushViewController:[ControllerManager shareManager].detailView animated:YES];
    
    self.parentViewController.hidesBottomBarWhenPushed = NO;
}


#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.showArray.count;
        default:
            return 0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            GDLikesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
            cell.delegate = self;
            
            cell.array = self.hotArray;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
            
        default: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rrrrr"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"rrrrr"];
            }
            
            cell.imageView.image = [UIImage imageNamed:@"search_history"];
            cell.textLabel.text = _showArray[indexPath.row];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            return cell;
        }
    }
}

#pragma mark - tableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_showArray.count != 0) {
        
        NSString *keyword = _showArray[indexPath.row];
        
        self.parentViewController.hidesBottomBarWhenPushed = YES;
        [ControllerManager shareManager].searchResultController.keyword = keyword;
        [self.navigationController pushViewController:[ControllerManager shareManager].searchResultController animated:YES];
        self.parentViewController.hidesBottomBarWhenPushed = NO;
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, kSCREEN_WIDTH, 40)];
    
    label.backgroundColor = [UIColor whiteColor];
    switch (section) {
        case 0: {
            label.text = @"    热门搜索";
            break;
        }
            
        case 1: {
            label.text = @"    搜索历史";
            break;
        }
        
        default:
            break;
    }
    
    
    [view addSubview:label];
    
    return view;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return self.collectionView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 0 && self.collectionArray.count != 0) {
//        return 60;
//    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 100;
        default:
            return 44;
    }
}

#pragma mkar - collectionviewDelegate
/*
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchCollectionCell" forIndexPath:indexPath];
    
    cell.label.text = [NSString stringWithFormat:@" %@ ",self.collectionArray[indexPath.row][@"gamename"]];

    [cell.label sizeToFit];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
    
}
 */

#pragma mark - searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
}



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 49) style:(UITableViewStylePlain)];
        
        [_tableView registerNib:[UINib nibWithNibName:@"GDLikesTableViewCell" bundle:nil] forCellReuseIdentifier:CELLIDENTIFIER];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.tableFooterView = self.clearHistoryBtn;
        
    }
    return _tableView;
}

- (UIButton *)clearHistoryBtn {
    if (!_clearHistoryBtn) {
        _clearHistoryBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _clearHistoryBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH , 44);
        [_clearHistoryBtn setTitle:@"清除历史记录" forState:(UIControlStateNormal)];
        [_clearHistoryBtn setImage:[UIImage imageNamed:@"search_delete"] forState:(UIControlStateNormal)];
        [_clearHistoryBtn addTarget:self action:@selector(clickClearHistoryBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [_clearHistoryBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [_clearHistoryBtn setBackgroundColor:RGBCOLOR(247, 247, 247)];
        
    }
    return _clearHistoryBtn;
}

/*
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.estimatedItemSize = CGSizeMake(kSCREEN_WIDTH / 5, 44);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"SearchCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"SearchCollectionCell"];
        
    }
    return _collectionView;
}
 */

#pragma mark - memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
