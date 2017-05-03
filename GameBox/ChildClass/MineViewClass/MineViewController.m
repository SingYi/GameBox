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

#import <MobileCoreServices/MobileCoreServices.h>

#define CELLIDENTIFIER @"MineCell"


@interface MineViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *headerview;

@property (nonatomic, strong) UICollectionView *collectionView;

//**显示数组*/
@property (nonatomic, strong) NSArray *showArray;

/**图片数组*/
@property (nonatomic, strong) NSArray *imageArray;

/**登录按钮*/
@property (nonatomic, strong) UIButton *loginBtn;

/** 用户昵称 */
@property (nonatomic, strong) UIButton *nickNameBtn;

/** 用户头像 */
@property (nonatomic, strong) UIImageView *avatar;

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
    
    NSString *uid = [UserModel CurrentUser].uid;
    
    NSNumber *isLogin = OBJECT_FOR_USERDEFAULTS(@"isLogin");
    
    CLog(@"MineViewController.uid == %@",[UserModel CurrentUser].uid);
    CLog(@"MineViewController.isLogin == %d",isLogin.boolValue);
    
    if (uid && isLogin.boolValue) {
        CLog(@"已登录");
        
        self.avatar.image = [UIImage imageWithData:[UserModel CurrentUser].avatar];
        
        [self.loginBtn removeFromSuperview];
        [self.headerview addSubview:self.avatar];
        [self.headerview addSubview:self.nickNameBtn];
        
    } else {
        CLog(@"未登录");
        
        self.avatar.image = nil;
        
        [self.headerview addSubview:self.loginBtn];
        [self.avatar removeFromSuperview];
        [self.nickNameBtn removeFromSuperview];
    }
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
    [self.view addSubview:self.collectionView];
}

#pragma mark - responds
- (void)respondsToLoginBtn:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.loginView animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)TapaAvatar {
    
    CLog(@"1");
    
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    pickerView.delegate = self;
    pickerView.allowsEditing = YES;
    
    if  ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] && [UIImagePickerController isSourceTypeAvailable : UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择图片来源" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *photoLibraryAct = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pickerView animated:YES completion:nil];
        }];
        UIAlertAction *cameraAct = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerView.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            pickerView.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
            [self presentViewController:pickerView animated:YES completion:nil];
        }];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:photoLibraryAct];
        [alertController addAction:cameraAct];
        [alertController addAction:cancelAct];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - pickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString*)kUTTypeImage]) {
        
        UIImage  *photo = info[UIImagePickerControllerEditedImage];
        NSData *data = UIImagePNGRepresentation(photo);
        
        SAVEOBJECT_AT_USERDEFAULTS(data, @"avatar");
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.avatar.image = photo;
        
        


        
     
    } else {
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.titleLabel.text = _showArray[indexPath.row];
    
    if ([_showArray[indexPath.row] isEqualToString:@""]) {
        cell.titleImageView.hidden = YES;
        cell.hidden = YES;
    } else {
        cell.hidden = NO;
        cell.titleImageView.hidden = NO;
        cell.titleImageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
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
        _headerview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.738)];
        _headerview.image = [UIImage imageNamed:@"mineBackground"];
        _headerview.userInteractionEnabled = YES;
        
    }
    return _headerview;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.itemSize = CGSizeMake(kSCREEN_WIDTH / 3 - 1, (kSCREEN_HEIGHT - kSCREEN_WIDTH * 0.738 - 49) / 3 - 2);
        
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 1;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kSCREEN_WIDTH * 0.738, kSCREEN_WIDTH, kSCREEN_HEIGHT - kSCREEN_WIDTH * 0.738 - 49) collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = RGBCOLOR(200, 200, 200);
        
        [_collectionView registerClass:[MineCell class] forCellWithReuseIdentifier:CELLIDENTIFIER];
        
        
    }
    return _collectionView;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc]init];
        _loginBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 3, kSCREEN_WIDTH / 3);
        _loginBtn.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH / 4);
        
        [_loginBtn setImage:[UIImage imageNamed:@"mine_loginBtn_no"] forState:(UIControlStateNormal)];
        
        [_loginBtn addTarget:self action:@selector(respondsToLoginBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loginBtn;
}

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 3, kSCREEN_WIDTH / 3);
        _avatar.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH / 3);
        
        _avatar.backgroundColor = [UIColor blueColor];
        _avatar.layer.cornerRadius = kSCREEN_WIDTH / 6;
        _avatar.layer.masksToBounds = YES;
        
        _avatar.userInteractionEnabled = YES;
        _avatar.layer.borderWidth = 2.0f;//边框宽度
        _avatar.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapaAvatar)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        [_avatar addGestureRecognizer:tapRecognizer];
    }
    return _avatar;
}

- (UIButton *)nickNameBtn {
    if (!_nickNameBtn) {
        _nickNameBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _nickNameBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, 44);
        _nickNameBtn.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH * 0.55);
        [_nickNameBtn setTitle:@"NickName" forState:(UIControlStateNormal)];
        _nickNameBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _nickNameBtn;
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
