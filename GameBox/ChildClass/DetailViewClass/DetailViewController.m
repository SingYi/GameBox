//
//  DetailViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailHeader.h"
#import "DetailFooter.h"

#import "GameRequest.h"
#import "UserModel.h"

#import "GameDetailViewController.h"
#import "GameStrategyViewController.h"
#import "GameGiftBagViewController.h"
#import "GameOpenServerViewController.h"

#import "WriteCommentController.h"
#import "UserModel.h"

#import "ChangyanSDK.h"
#import "UIImageView+WebCache.h"





@interface DetailViewController ()<DetailHeaderDelegate,DetailFooterDelegate>

/**头部视图*/
@property (nonatomic, strong) DetailHeader *detailHeader;

/**尾部视图*/
@property (nonatomic, strong) DetailFooter *detailFooter;

/**游戏详情页面*/
@property (nonatomic, strong) GameDetailViewController *gameDetail;
/**游戏攻略*/
@property (nonatomic, strong) GameStrategyViewController *gameStrategy;
/**游戏礼包*/
@property (nonatomic, strong) GameGiftBagViewController *gameGiftBag;
/**游戏开服*/
@property (nonatomic, strong) GameOpenServerViewController *gameOpenServer;
/** 评论页面 */
@property (nonatomic, strong) WriteCommentController *writeComment;
/**当前视图*/
@property (nonatomic, strong) UIViewController *currentViewController;
/**当前下标*/
@property (nonatomic, assign) NSInteger currentIndex;
/**动画效果状态*/
@property (nonatomic, assign) BOOL isAnimation;
/**向左滑*/
@property (nonatomic, assign) BOOL isLeft;
/** 评论按钮 */
@property (nonatomic, strong) UIBarButtonItem *commentButton;

/**游戏数据*/
@property (nonatomic, strong) NSDictionary * gameinfo;
/**猜你喜欢*/
@property (nonatomic, strong) NSArray *likes;


/** 分享页面 */
@property (nonatomic, strong) UIWindow *sharedWindow;
@property (nonatomic, strong) UIView *sharedView;
@property (nonatomic, strong) UIButton *cancleShared;

/** 分享到QQ空间 */
@property (nonatomic, strong) UIButton *sharedQQZone;
@property (nonatomic, strong) UILabel *QzoneLabel;
/** 分享到朋友圈 */
@property (nonatomic, strong) UIButton *sharedFirendcycle;
@property (nonatomic, strong) UILabel *firendLabel;


@end

@implementation DetailViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.detailHeader.btnArray = @[@"详情",@"攻略",@"礼包",@"开服"];
        self.currentViewController = self.gameDetail;
        _currentIndex = 0;
        _isAnimation = NO;
        _isLeft = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_gameID != nil) {
        [self getGameComments];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //页面即将消失时取消底部视图代理
    self.detailFooter.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [self addChildViewController:self.gameDetail];
    [self.view addSubview:self.gameDetail.view];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];

    
    self.navigationItem.title = @"游戏详情";
    
    [self.view addSubview:self.detailHeader];
    [self.view addSubview:self.gameDetail.view];
    [self.view addSubview:self.detailFooter];
    
    self.navigationItem.rightBarButtonItem = self.commentButton;
    //页面添加左右轻扫手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipe];
    [self.view addGestureRecognizer:leftSwipe];
}

#pragma mark - respondsToSwipe
/** 手势的响应事件 */
- (void)respondsToSwipe:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft && _currentIndex >= 0 && _currentIndex < 3) {
        
        [self didselectBtnAtIndex:_currentIndex + 1];  //切换视图
        self.detailHeader.index = _currentIndex;  //切换标签
        
    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight && _currentIndex > 0 && _currentIndex <= 3) {
        
        [self didselectBtnAtIndex:_currentIndex - 1];  //切换视图
        self.detailHeader.index = _currentIndex;  //切换标签
    }
}

- (void)respondsToCommentButton {
    self.hidesBottomBarWhenPushed = YES;
    if ([UserModel CurrentUser]) {
        
        [self.navigationController pushViewController:self.writeComment animated:YES];
    } else {
        [self.navigationController pushViewController:[ControllerManager shareManager].loginViewController animated:YES];
    }
}

#pragma mark - setter
- (void)setGameID:(NSString *)gameID {
    
    self.detailFooter.delegate = nil;
    _gameID = gameID;

    if (self.currentViewController == self.gameDetail) {
        
    } else {
        [self replaceController:self.currentViewController newController:self.gameDetail];
        [self.detailHeader.selectView reomveLabelWithX:0];
        _currentIndex = 0;
    }
    

    
    
    self.gameGiftBag.gameID = gameID;
    self.gameOpenServer.gameID = gameID;
    self.gameStrategy.gameID = gameID;
    
        //请求游戏详情
    
    NSDictionary *dict = [GameRequest gameWithGameID:_gameID];
//    syLog(@"%@",dict);
    self.gameinfo = dict;

    [GameRequest gameInfoWithGameID:_gameID Comoletion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {
            self.gameinfo = content[@"data"][@"gameinfo"];
            
            syLog(@"%@",content[@"data"][@"gameinfo"]);

            self.likes = content[@"data"][@"like"];
            
            NSArray *array = [AppModel getLocalGamesWithPlist];
            for (NSInteger i = 0; i < array.count; i++) {
                if ([array[i][@"bundleID"] isEqualToString:self.gameinfo[@"ios_pack"]]) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.gameinfo];
                    [dict setObject:@"1" forKey:@"isLocal"];
                    self.gameinfo = [dict copy];
                    break;
                }
            }
            if ([self.gameinfo[@"isLocal"] isEqualToString:@"1"]) {
                self.detailFooter.isOpen = YES;
            } else {
                self.detailFooter.isOpen = NO;
            }
            
            //设置收藏按钮的代理
            self.detailFooter.delegate = self;
        } else {
            
                
        }
    }];
    
    //获取游戏评论
    [self getGameComments];

}


/** 获取游戏评论 */
- (void)getGameComments {
    
    //获取游戏评论
    [ChangyanSDK loadTopic:@"" topicTitle:nil topicSourceID:[NSString stringWithFormat:@"game_%@",_gameID] pageSize:@"3" hotSize:nil orderBy:nil style:nil depth:nil subSize:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        
        if (statusCode == 0) {
            
            NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            self.gameDetail.commentArray = dic[@"comments"];
            self.writeComment.gameName = dic[@"topic_id"];
            self.gameDetail.gameID = _gameID;
        } else {
            
            
        }
    
    }];
    
}

#pragma markg - gameInfo
/** 设置游戏信息 */
- (void)setGameinfo:(NSDictionary *)gameinfo {
    _gameinfo = gameinfo;

    //设置游戏名称
    self.detailHeader.gameNameLabel.text = _gameinfo[@"gamename"];
    [self.detailHeader.gameNameLabel sizeToFit];
    self.gameOpenServer.gamename = _gameinfo[@"gamename"];
    //设置标签
    NSArray *types = [((NSString *)_gameinfo[@"types"]) componentsSeparatedByString:@" "];
    NSInteger j = 0;
    for (; j < (types.count < 3 ? types.count : 3); j++) {
        self.detailHeader.typeLabels[j].text = [NSString stringWithFormat:@" %@ ",types[j]];
        if (j == 0) {
            self.detailHeader.typeLabels[j].frame = CGRectMake(CGRectGetMaxX(self.detailHeader.gameNameLabel.frame) + 4, 15, 15, 15);
        } else {
            self.detailHeader.typeLabels[j].frame = CGRectMake(CGRectGetMaxX(self.detailHeader.typeLabels[j - 1].frame) + 2, 15, 15, 15);
        }
        [self.detailHeader.typeLabels[j] sizeToFit];
    }
    for (; j < self.detailHeader.typeLabels.count; j++) {
        self.detailHeader.typeLabels[j].text = @"";
        [self.detailHeader.typeLabels[j] sizeToFit];
    }
    
    
    //设置游戏评分
    self.detailHeader.source = ((NSString *)_gameinfo[@"score"]).floatValue;

    //设置游戏下载次数
    NSInteger downLoad = ((NSString *)_gameinfo[@"download"]).integerValue;
    if (downLoad > 10000) {
        self.detailHeader.downLoadNumber.text = [NSString stringWithFormat:@"%ld万+次下载",downLoad / 10000];
        [self.detailHeader.downLoadNumber sizeToFit];
    } else {
        self.detailHeader.downLoadNumber.text = [NSString stringWithFormat:@"%ld次下载",downLoad];
         [self.detailHeader.downLoadNumber sizeToFit];
    }
    
    //设置游戏大小
    self.detailHeader.sizeLabel.text = [NSString stringWithFormat:@"%@M",_gameinfo[@"size"]];
    [self.detailHeader.sizeLabel sizeToFit];
    
    //设置 QQ 群
    self.detailHeader.qqGroup = gameinfo[@"qq_group"];
    
    //设置游戏轮播图
    self.gameDetail.imagasArray = gameinfo[@"imgs"];
    
    //设置游戏简介
    self.gameDetail.abstract = gameinfo[@"abstract"];
    
    //设置游戏特性
    self.gameDetail.feature = gameinfo[@"feature"];
    
    //设置游戏返利
    self.gameDetail.rebate = gameinfo[@"rebate"];
    
    //gifModel
    self.gameDetail.gifModel = gameinfo[@"gif_model"];
    
    //gif
    self.gameDetail.gifUrl = gameinfo[@"gif"];

    //vip
    self.gameDetail.vip = gameinfo[@"vip"];
    
    //是否收藏
    NSString *isCollection = gameinfo[@"collect"];
    self.detailFooter.isCollection = isCollection.boolValue;
    
    [self.gameDetail goToTop];
}

//设置猜你喜欢
- (void)setLikes:(NSArray *)likes {
    self.gameDetail.likes = likes;
}


//设置游戏logo
- (void)setGameLogo:(UIImage *)gameLogo {
    
    UIImage *image = [UIImage imageNamed:@"image_downloading"];
    
    NSData *data1 = UIImagePNGRepresentation(image);
    
    NSData *data2 = UIImagePNGRepresentation(gameLogo);
    
    if ([data1 isEqual:data2] || gameLogo == nil) {
        
        [self.detailHeader.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_gameinfo[@"logo"]]] placeholderImage:image];
        self.gameStrategy.gameLogo = self.detailHeader.imageView.image;
    } else {
        
        self.detailHeader.imageView.image = gameLogo;
        self.gameStrategy.gameLogo = gameLogo;
    }
    
    self.gameOpenServer.logoImage = self.detailHeader.imageView.image;
}


#pragma mark - childController
//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController {
    
    [self addChildViewController:newController];
    
    self.isAnimation = YES;
    
    CGFloat floatx = 0;
    if (_isLeft) {
        floatx = kSCREEN_WIDTH;
    } else {
        floatx = -kSCREEN_WIDTH;
    }
    
    newController.view.transform = CGAffineTransformMakeTranslation(floatx, 0);
    
    [self transitionFromViewController:oldController toViewController:newController duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
        
        newController.view.transform = CGAffineTransformIdentity;
        oldController.view.transform = CGAffineTransformMakeTranslation(-floatx, 0);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentViewController = newController;
            
        }else{
            
            self.currentViewController = oldController;
            
        }
        
        self.isAnimation = NO;
    }];
}



#pragma mark - detailHeaderDelegate
- (void)didselectBtnAtIndex:(NSInteger)index {
    
    if (index > _currentIndex) {
        _isLeft = YES;
    } else {
        _isLeft = NO;
    }
    
    
    if (index == _currentIndex || _isAnimation) {
        
    } else {
        _currentIndex = index;
        switch (index) {
            case 0:
            {
                [self replaceController:self.currentViewController newController:self.gameDetail];
            }
                break;
            case 1:
            {
                [self replaceController:self.currentViewController newController:self.gameStrategy];
            }
                break;
            case 2:
            {
                [self replaceController:self.currentViewController newController:self.gameGiftBag];
            }
                break;
            case 3:
            {
                [self replaceController:self.currentViewController newController:self.gameOpenServer];
            }
                break;
            default:
                break;
        }
    }

}

#pragma mark - detailFooterDelegate
- (void)DetailFooter:(DetailFooter *)detailFooter clickCollecBtn:(UIButton *)sender {
    if ([UserModel CurrentUser]) {
        
    } else {
        [GameRequest showAlertWithMessage:@"未登录" dismiss:nil];
        return;
    }
    
    if (self.gameinfo && _gameinfo[@"collect"]) {
        BOOL isCollect = self.detailFooter.isCollection;
        if (isCollect) {
            [GameRequest gameCollectWithType:cancel GameID:_gameID Comoletion:^(NSDictionary * _Nullable content, BOOL success) {
                //取消收藏
                if (success && REQUESTSUCCESS) {
                    self.detailFooter.isCollection = NO;
                } else {
                    
                }

            }];
        } else {
            [GameRequest gameCollectWithType:collection GameID:_gameID Comoletion:^(NSDictionary * _Nullable content, BOOL success) {
                //收藏
                if (success && REQUESTSUCCESS) {
                    self.detailFooter.isCollection = YES;
                } else {
                
                }

            }];
        }
    }
}

#pragma mark - share
/** share */
- (void)DetailFooter:(DetailFooter *)detailFooter clickShareBtn:(UIButton *)sender {
    if (self.gameinfo) {
        
        [self showSharedView];
        
    }
}

- (void)DetailFooter:(DetailFooter *)detailFooter clickDownLoadBtn:(UIButton *)sender {
    
    NSString *isLocal = self.gameinfo[@"isLocal"];
    if ([isLocal isEqualToString:@"1"]) {
        [AppModel openAPPWithIde:self.gameinfo[@"ios_pack"]];
        
    } else {
        NSString *url = self.gameinfo[@"ios_url"];
        
        [GameRequest downLoadAppWithURL:url];
    }
}

- (void)showSharedView {
    
    self.sharedView.transform = CGAffineTransformMakeTranslation(0, 120);
    self.cancleShared.transform = CGAffineTransformMakeTranslation(0, 120);
    [self.sharedWindow makeKeyAndVisible];
    [UIView animateWithDuration:0.2 animations:^{
        self.sharedView.transform = CGAffineTransformIdentity;
        self.cancleShared.transform = CGAffineTransformIdentity;
    }];
    
    
}

- (void)hideSharedView {
    self.sharedWindow = nil;
}

- (void)tapSharedWindow:(UITapGestureRecognizer *)sender {
    [self hideSharedView];
}

- (void)respondsToSharedFirend {
    [self hideSharedView];
    if (self.gameLogo) {
        
        [GameRequest shareToFirednCircleWithTitle:_gameinfo[@"gamename"] SubTitle:_gameinfo[@"abstract"] Url:[NSString stringWithFormat:@"http://m.185sy.com/Game-appGameinfo-id-%@.html",_gameinfo[@"id"]] Image:self.gameLogo];

        
    } else {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_gameinfo[@"logo"]]] options:(SDWebImageDownloaderLowPriority) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (finished) {
                    [GameRequest shareToFirednCircleWithTitle:_gameinfo[@"gamename"] SubTitle:_gameinfo[@"abstract"] Url:[NSString stringWithFormat:@"http://m.185sy.com/Game-appGameinfo-id-%@.html",_gameinfo[@"id"]] Image:image];
                }
            }];
    }
}

- (void)respondsToSharedQQZone {
    [self hideSharedView];
    if (self.gameLogo) {

        [GameRequest shareToQQZoneWithTitle:_gameinfo[@"gamename"] SubTitle:_gameinfo[@"abstract"] Url:[NSString stringWithFormat:@"http://m.185sy.com/Game-appGameinfo-id-%@.html",_gameinfo[@"id"]] Image:[NSString stringWithFormat:IMAGEURL,_gameinfo[@"logo"]]];
        
    } else {

        [GameRequest shareToQQZoneWithTitle:_gameinfo[@"gamename"] SubTitle:_gameinfo[@"abstract"] Url:[NSString stringWithFormat:@"http://m.185sy.com/Game-appGameinfo-id-%@.html",_gameinfo[@"id"]] Image:[NSString stringWithFormat:IMAGEURL,_gameinfo[@"logo"]]];
    }
}


#pragma mark - getter
- (DetailHeader *)detailHeader {
    if (!_detailHeader) {
        _detailHeader = [[DetailHeader alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 124)];

        _detailHeader.layer.shadowColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
        _detailHeader.layer.shadowOpacity = 1.f;
        _detailHeader.layer.shadowRadius = 5.f;
        _detailHeader.layer.shadowOffset = CGSizeMake(0, 5);
        

        _detailHeader.detailHeaderDelegate = self;
        
    }
    return _detailHeader;
}

- (DetailFooter *)detailFooter {
    if (!_detailFooter) {
        _detailFooter = [[DetailFooter alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 50, kSCREEN_WIDTH, 50)];
        _detailFooter.delegate = self;
    }
    return _detailFooter;
}


#pragma mark - childVeiwController
- (GameDetailViewController *)gameDetail {
    if (!_gameDetail) {
        _gameDetail = [[GameDetailViewController alloc] init];
        _gameDetail.view.frame = CGRectMake(0, CGRectGetMaxY(self.detailHeader.frame) + 7, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.detailHeader.frame) - 57);
        
        _gameDetail.view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _gameDetail.view.layer.shadowOpacity = 1.f;
        _gameDetail.view.layer.shadowRadius = 2.f;
        _gameDetail.view.layer.shadowOffset = CGSizeMake(2, 2);
        _gameDetail.view.layer.masksToBounds = YES;

    }
    return _gameDetail;
}

- (GameStrategyViewController *)gameStrategy {
    if (!_gameStrategy) {
        _gameStrategy = [[GameStrategyViewController alloc] init];
        _gameStrategy.view.frame = CGRectMake(0, CGRectGetMaxY(self.detailHeader.frame) + 7, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.detailHeader.frame) - 57);
        
        _gameStrategy.view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _gameStrategy.view.layer.shadowOpacity = 1.f;
        _gameStrategy.view.layer.shadowRadius = 2.f;
        _gameStrategy.view.layer.shadowOffset = CGSizeMake(2, 2);
        _gameStrategy.view.layer.masksToBounds = YES;


    }
    return _gameStrategy;
}

- (GameGiftBagViewController *)gameGiftBag {
    if (!_gameGiftBag) {
        _gameGiftBag = [[GameGiftBagViewController alloc] init];
        _gameGiftBag.view.frame = CGRectMake(0, CGRectGetMaxY(self.detailHeader.frame) + 7, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.detailHeader.frame) -  57);
        
        _gameGiftBag.view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _gameGiftBag.view.layer.shadowOpacity = 1.f;
        _gameGiftBag.view.layer.shadowRadius = 2.f;
        _gameGiftBag.view.layer.shadowOffset = CGSizeMake(2, 2);
        _gameGiftBag.view.layer.masksToBounds = YES;


    }
    return _gameGiftBag;
}

- (GameOpenServerViewController *)gameOpenServer {
    if (!_gameOpenServer) {
        _gameOpenServer = [[GameOpenServerViewController alloc] init];
        _gameOpenServer.view.frame = CGRectMake(0, CGRectGetMaxY(self.detailHeader.frame) + 7, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.detailHeader.frame) -  57);
        
        _gameOpenServer.view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _gameOpenServer.view.layer.shadowOpacity = 1.f;
        _gameOpenServer.view.layer.shadowRadius = 2.f;
        _gameOpenServer.view.layer.shadowOffset = CGSizeMake(2, 2);
        _gameOpenServer.view.layer.masksToBounds = YES;


    }
    return _gameOpenServer;
}

- (WriteCommentController *)writeComment {
    if (!_writeComment) {
        _writeComment = [[WriteCommentController alloc] init];
    }
    return _writeComment;
}

- (UIBarButtonItem *)commentButton {
    if (!_commentButton) {
        _commentButton = [[UIBarButtonItem alloc] initWithTitle:@"我要评论" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToCommentButton)];
    }
    return _commentButton;
}

/** 分享页面 */
- (UIWindow *)sharedWindow {
    if (!_sharedWindow) {
        _sharedWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _sharedWindow.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSharedWindow:)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        
        [_sharedWindow addGestureRecognizer:tap];
        [_sharedWindow addSubview:self.sharedView];
        [_sharedWindow addSubview:self.cancleShared];
    }
    return _sharedWindow;
}

- (UIView *)sharedView {
    if (!_sharedView) {
        _sharedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 120)];
        _sharedView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT - 120);
        _sharedView.backgroundColor = RGBCOLOR(247, 247, 247);
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 119, kSCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        
        [_sharedView addSubview:line];
//        _sharedView.layer.cornerRadius = 10;
//        _sharedView.layer.masksToBounds = YES;
        
        [_sharedView addSubview:self.sharedFirendcycle];
        [_sharedView addSubview:self.firendLabel];
        [_sharedView addSubview:self.sharedQQZone];
        [_sharedView addSubview:self.QzoneLabel];
    }
    return _sharedView;
}

/** 取消分享按钮 */
- (UIButton *)cancleShared {
    if (!_cancleShared) {
        _cancleShared = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cancleShared.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, 60);
        _cancleShared.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT - 30);
        _cancleShared.backgroundColor = RGBCOLOR(247, 247, 247);
        [_cancleShared setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancleShared setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [_cancleShared addTarget:self action:@selector(hideSharedView) forControlEvents:(UIControlEventTouchUpInside)];
        
//        _cancleShared.layer.cornerRadius = 10;
//        _cancleShared.layer.masksToBounds = YES;
    }
    return _cancleShared;
}

/** 分享到朋友圈 */
- (UIButton *)sharedFirendcycle {
    if (!_sharedFirendcycle) {
        _sharedFirendcycle = [[UIButton alloc] init];
        _sharedFirendcycle.bounds = CGRectMake(0, 0, 35, 35);
        _sharedFirendcycle.center = CGPointMake(self.firendLabel.center.x, 50);
        [_sharedFirendcycle setBackgroundImage:[UIImage imageNamed:@"shared_firend"] forState:(UIControlStateNormal)];
        [_sharedFirendcycle setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_sharedFirendcycle addTarget:self action:@selector(respondsToSharedFirend) forControlEvents:(UIControlEventTouchUpInside)];
        
        
    }
    return _sharedFirendcycle;
}

- (UILabel *)firendLabel {
    if (!_firendLabel) {
        _firendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, kSCREEN_WIDTH / 4, 30)];
        _firendLabel.text = @"朋友圈";
        _firendLabel.textAlignment = NSTextAlignmentCenter;
        _firendLabel.textColor = [UIColor lightGrayColor];
    }
    return _firendLabel;
}

/** 分享到QQ空间 */
- (UIButton *)sharedQQZone {
    if (!_sharedQQZone) {
        _sharedQQZone = [[UIButton alloc] init];
        _sharedQQZone.bounds = CGRectMake(0, 0, 35, 35);
        _sharedQQZone.center = CGPointMake(self.QzoneLabel.center.x, 50);
        [_sharedQQZone setBackgroundImage:[UIImage imageNamed:@"shared_Qzone"] forState:(UIControlStateNormal)];
        [_sharedQQZone setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_sharedQQZone addTarget:self action:@selector(respondsToSharedQQZone) forControlEvents:(UIControlEventTouchUpInside)];
        
        
    }
    return _sharedQQZone;
}

- (UILabel *)QzoneLabel {
    if (!_QzoneLabel) {
        _QzoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH / 4, 75, kSCREEN_WIDTH / 4, 30)];
        _QzoneLabel.text = @"QQ空间";
        _QzoneLabel.textAlignment = NSTextAlignmentCenter;
        _QzoneLabel.textColor = [UIColor lightGrayColor];
    }
    return _QzoneLabel;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
