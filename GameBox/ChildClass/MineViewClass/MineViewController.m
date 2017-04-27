//
//  MineViewController.m
//  GameBox
//
//  Created by 石燚 on 17/4/10.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "ControllerManager.h"
#import "MineCell.h"
#import "MineModel.h"

#import "UserModel.h"

//我的页面的7个子视图
#import "AppManagerView.h"
@class MyGiftBagViewController;
#import "MyNewsView.h"
#import "ResetPassWordViewController.h"
#import "MyAttentionView.h"
#import "SettingView.h"
#import "AboutUsView.h"


#define CELLIDENTIFIER @"MineCell"


@interface MineViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIImageView *headerview;

@property (nonatomic, strong) UICollectionView *collectionView;

//**显示数组*/
@property (nonatomic, strong) NSArray *showArray;

/**图片数组*/
@property (nonatomic, strong) NSArray *imageArray;

/**登录按钮*/
@property (nonatomic, strong) UIButton *loginBtn;

/**登录页面*/
@property (nonatomic, strong) LoginViewController *loginView;

/**修改密码*/
@property (nonatomic, strong) ResetPassWordViewController *resetPassWordView;



@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    _showArray = @[@"应用管理",@"我的礼包",@"我的消息",@"修改密码",@"我的关注",@"设置",@"关于",@"",@""];
    _imageArray = @[@"mine_yingyongguanli",@"mine_libao",@"mine_wodexiaoxi",@"mine_xiugaimima",@"mine_guanzhu",@"mine_shezhi",@"mine_guanyu"];

    
}

- (void)initUserInterface {
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.headerview];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.collectionView];
}

#pragma mark - responds
- (void)respondsToLoginBtn:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.loginView animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - collectionViewDataSource 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _showArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.label.text = _showArray[indexPath.row];
    
    if ([_showArray[indexPath.row] isEqualToString:@""]) {
        cell.image.hidden = YES;
    } else {
        cell.image.hidden = NO;
        cell.image.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.hidesBottomBarWhenPushed = YES;
    switch (indexPath.row) {
        case 0:
        {
//            [self.navigationController pushViewController:[AppManagerView new] animated:YES];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https%3A%2F%2Fdownload.fir.im%2Fapps%2F58c78f29ca87a86ab50000ee%2Finstall%3Fdownload_token%3Dfb0f242cdf75f7007568a491321dac4d%26release_id%3D58c78faeca87a86b4c00012e"]];
        }
            break;
        case 1:
        {
            [self.navigationController pushViewController:[ControllerManager shareManager].myGiftBagView animated:YES];
        }
            break;
        case 2:
        {
            [self.navigationController pushViewController:[MyNewsView new] animated:YES];
        }
            
            break;
        case 3:
        {
            [self.navigationController pushViewController:self.resetPassWordView animated:YES];
        }
            break;
        case 4:
        {
            [self.navigationController pushViewController:[MyAttentionView new] animated:YES];
        }
            break;
        case 5:
        {
            [self.navigationController pushViewController:[SettingView new] animated:YES];
        }
            break;
        case 6:
        {
            [self.navigationController pushViewController:[AboutUsView new] animated:YES];
        }
            break;
            
            
            
        default:
            break;
    }
    
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - getter 
- (UIImageView *)headerview {
    if (!_headerview) {
        _headerview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
        _headerview.image = [UIImage imageNamed:@"mineBackground"];
        _headerview.userInteractionEnabled = YES;
    }
    return _headerview;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.itemSize = CGSizeMake(kSCREEN_WIDTH / 3, (kSCREEN_HEIGHT - 349) / 3);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 300, kSCREEN_WIDTH, kSCREEN_HEIGHT - 349) collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellWithReuseIdentifier:CELLIDENTIFIER];
        
        
    }
    return _collectionView;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc]init];
        _loginBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 3, kSCREEN_WIDTH / 3);
        _loginBtn.center = CGPointMake(kSCREEN_WIDTH / 2, 150);
        
        [_loginBtn setImage:[UIImage imageNamed:@"mine_loginBtn_no"] forState:(UIControlStateNormal)];
        [_loginBtn setTitle:@"" forState:(UIControlStateNormal)];
        
        [_loginBtn addTarget:self action:@selector(respondsToLoginBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _loginBtn;
}

- (LoginViewController *)loginView {
    if (!_loginView) {
        _loginView = [[LoginViewController alloc] init];
        
    }
    return _loginView;
}


//修改密码
- (ResetPassWordViewController *)resetPassWordView {
    if (!_resetPassWordView) {
        _resetPassWordView = [ResetPassWordViewController new];
    }
    return _resetPassWordView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
