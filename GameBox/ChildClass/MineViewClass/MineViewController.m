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


//#import "MineModel.h"

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
#import <UIImageView+WebCache.h>

#define CELLIDENTIFIER @"MineCell"
#define LOGINNOTIFICATION @"logingnotification"



@interface MineViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *headerview;

@property (nonatomic, strong) UICollectionView *collectionView;

/** 显示数组 */
@property (nonatomic, strong) NSArray *showArray;

/** 图片数组 */
@property (nonatomic, strong) NSArray *imageArray;

/** 登录按钮 */
@property (nonatomic, strong) UIButton *loginBtn;

/** 用户昵称 */
@property (nonatomic, strong) UIButton *nickNameBtn;
@property (nonatomic, strong) UIWindow *animationWindow;
@property (nonatomic, strong) UIButton *resetNickNameBtn;
@property (nonatomic, strong) UITextField *nickNameText;

/** 用户头像 */
@property (nonatomic, strong) UIImageView *avatar;

/** 修改密码 */
@property (nonatomic, strong) ResetPassWordViewController *resetPassWordViewController;
/** 我的关注 */
@property (nonatomic, strong) MyAttentionView *myAttentionViewController;
/** 设置 */
@property (nonatomic, strong) SettingView *settingViewController;
/** 关于我们 */
@property (nonatomic, strong) AboutUsView *aboutUsViewController;


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
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isLogin:) name:LOGINNOTIFICATION object:nil];
}

- (void)isLogin:(NSNotification *)sender {
    [self loginInterface];
//    syLog(@"-------接收到通知------");
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
    [self loginInterface];

}

- (void)loginInterface {
    if ([UserModel CurrentUser]) {
        
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,[UserModel CurrentUser].avatar]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];
        
        
        if ([UserModel CurrentUser].nickName == nil || [UserModel CurrentUser].nickName.length == 0) {
            [self.nickNameBtn setTitle:@"设置昵称" forState:(UIControlStateNormal)];
        } else {
            [self.nickNameBtn setTitle:[UserModel CurrentUser].nickName forState:(UIControlStateNormal)];
        }
        
        [self.loginBtn removeFromSuperview];
        [self.headerview addSubview:self.avatar];
        [self.headerview addSubview:self.nickNameBtn];
    } else {
        self.avatar.image = nil;
        [self.headerview addSubview:self.loginBtn];
        [self.avatar removeFromSuperview];
        [self.nickNameBtn removeFromSuperview];
    }
}

#pragma mark - responds
/** 登录 */
- (void)respondsToLoginBtn:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[ControllerManager shareManager].loginViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

/** 修改昵称 */
- (void)respondsToNickNameBtn {
    syLog(@"设置昵称");

    [self.animationWindow addSubview:self.nickNameText];
    [self.animationWindow addSubview:self.resetNickNameBtn];
    [self.animationWindow makeKeyAndVisible];
    
}

- (void)clickResetNickNameBtn {
    self.animationWindow = nil;
    if (self.nickNameText.text.length == 0) {
        [UserModel showAlertWithMessage:@"请输入昵称" dismiss:nil];
        return;
    }
    
    [ControllerManager starLoadingAnimation];
    [UserModel userModifyNicknameWithUserID:[UserModel uid] NickName:self.nickNameText.text Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success) {
            if (REQUESTSUCCESS) {
                [self.nickNameBtn setTitle:self.nickNameText.text forState:(UIControlStateNormal)];
                SAVEOBJECT_AT_USERDEFAULTS(self.nickNameText.text, @"nickname");
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [UserModel showAlertWithMessage:REQUESTMSG dismiss:nil];
        } else {
            [UserModel showAlertWithMessage:@"网络不知道飞哪去了" dismiss:nil];
        }
        [ControllerManager stopLoadingAnimation];
    }];
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self clickResetNickNameBtn];
    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    } else if (textField.text.length >= 12) {
        textField.text = [textField.text substringToIndex:12];
        return NO;
    }
    return YES;
}

/** 修改头像 */
- (void)TapaAvatar {
    
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
        
        self.avatar.image = photo;
        
        SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:NO], @"setUserAvatar");
        
        /** 上传图片 */
        [UserModel userUploadPortraitWithUserID:[UserModel uid] Image:photo Completion:^(NSDictionary * _Nullable content, BOOL success) {
        
        }];
        
        
        
     
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
        //应用
        case 0:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https%3A%2F%2Fdownload.fir.im%2Fapps%2F58a5b4c0548b7a169b00006a%2Finstall%3Fdownload_token%3D280a9c300900931027c741d4090280b1%26release_id%3D58b62c59959d69056d0001ae"]];
//            [self.navigationController pushViewController:[ControllerManager shareManager].myAppViewController animated:YES];

        }
            break;
        //我的礼包
        case 1:
        {
            if ([UserModel CurrentUser] == nil) {
                [self.navigationController pushViewController:[ControllerManager shareManager].loginViewController animated:YES];
                break;
            }
            [self.navigationController pushViewController:[ControllerManager shareManager].myGiftBagView animated:YES];
        }
            break;
        //我的消息
        case 2:
        {
            if ([UserModel CurrentUser] == nil) {
                [self.navigationController pushViewController:[ControllerManager shareManager].loginViewController animated:YES];
                break;
            }
            [self.navigationController pushViewController:[ControllerManager shareManager].myNewsViewController animated:YES];
        }
            
            break;
        //修改密码
        case 3:
        {
            if ([UserModel CurrentUser] == nil) {
                [self.navigationController pushViewController:[ControllerManager shareManager].loginViewController animated:YES];
                break;
            }
            [self.navigationController pushViewController:self.resetPassWordViewController animated:YES];
        }
            break;
        //我的关注
        case 4:
        {
            if ([UserModel CurrentUser] == nil) {
                [self.navigationController pushViewController:[ControllerManager shareManager].loginViewController animated:YES];
                break;
            }
            [self.navigationController pushViewController:self.myAttentionViewController animated:YES];
        }
            break;
        //设置
        case 5:
        {
            [self.navigationController pushViewController:self.settingViewController animated:YES];
        }
            break;
        //关于我们
        case 6:
        {
            if (![CHANNELID isEqualToString:@"185"]) {
                break;
            }
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

/** 登录按钮 */
- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc]init];
        _loginBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 3, kSCREEN_WIDTH / 3);
        _loginBtn.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH / 3);
        
        [_loginBtn setImage:[UIImage imageNamed:@"mine_loginBtn_no"] forState:(UIControlStateNormal)];
        
        [_loginBtn addTarget:self action:@selector(respondsToLoginBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loginBtn;
}

/** 头像 */
- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 3, kSCREEN_WIDTH / 3);
        _avatar.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH / 3);
        
        _avatar.backgroundColor = [UIColor grayColor];
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

/** 昵称 */
- (UIButton *)nickNameBtn {
    if (!_nickNameBtn) {
        _nickNameBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _nickNameBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, 44);
        _nickNameBtn.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH * 0.55);
        [_nickNameBtn setTitle:@"NickName" forState:(UIControlStateNormal)];
        _nickNameBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_nickNameBtn addTarget:self action:@selector(respondsToNickNameBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nickNameBtn;
}

- (UIWindow *)animationWindow {
    if (!_animationWindow) {
        _animationWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _animationWindow.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    }
    return _animationWindow;
}

- (UITextField *)nickNameText {
    if (!_nickNameText) {
        _nickNameText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44)];
        _nickNameText.placeholder = @"输入昵称";
        _nickNameText.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 3.3);
        _nickNameText.borderStyle = UITextBorderStyleRoundedRect;
        _nickNameText.delegate = self;
    }
    return _nickNameText;
}

- (UIButton *)resetNickNameBtn {
    if (!_resetNickNameBtn) {
        _resetNickNameBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44)];
        [_resetNickNameBtn setTitle:@"修改昵称" forState:(UIControlStateNormal)];
        _resetNickNameBtn.backgroundColor = [UIColor orangeColor];
        _resetNickNameBtn.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 3.3 + 60);
        [_resetNickNameBtn addTarget:self action:@selector(clickResetNickNameBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _resetNickNameBtn;
}


//修改密码
- (ResetPassWordViewController *)resetPassWordViewController {
    if (!_resetPassWordViewController) {
        _resetPassWordViewController = [ResetPassWordViewController new];
    }
    return _resetPassWordViewController;
}
//我的关注
- (MyAttentionView *)myAttentionViewController {
    if (!_myAttentionViewController) {
        _myAttentionViewController = [[MyAttentionView alloc] init];
    }
    return _myAttentionViewController;
}
//设置
- (SettingView *)settingViewController {
    if (!_settingViewController) {
        _settingViewController = [[SettingView alloc] init];
    }
    return _settingViewController;
}
//关于我们
- (AboutUsView *)aboutUsViewController {
    if (!_aboutUsViewController) {
        _aboutUsViewController = [[AboutUsView alloc] init];
    }
    return _aboutUsViewController;
}


/** 移除通知 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGINNOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
