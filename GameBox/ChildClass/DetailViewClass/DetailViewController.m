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

#import "GameModel.h"

#import "GameDetailViewController.h"
#import "GameStrategyViewController.h"
#import "GameGiftBagViewController.h"
#import "GameOpenServerViewController.h"

#import "ChangyanSDK.h"
#import "UIImageView+WebCache.h"



@interface DetailViewController ()<DetailHeaderDelegate>

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
/**当前视图*/
@property (nonatomic, strong) UIViewController *currentViewController;
/**当前下标*/
@property (nonatomic, assign) NSInteger currentIndex;
/**动画效果状态*/
@property (nonatomic, assign) BOOL isAnimation;
/**向左滑*/
@property (nonatomic, assign) BOOL isLeft;

/**游戏数据*/
@property (nonatomic, strong) NSDictionary * gameinfo;
/**猜你喜欢*/
@property (nonatomic, strong) NSArray *likes;



@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [self addChildViewController:self.gameDetail];
    self.currentViewController = self.gameDetail;
    _currentIndex = 0;
    _isAnimation = NO;
    _isLeft = NO;
    [self.view addSubview:self.gameDetail.view];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.detailHeader.btnArray = @[@"详情",@"攻略",@"礼包",@"开服"];
    
    self.navigationItem.title = @"游戏详情";
    
    [self.view addSubview:self.detailHeader];
    [self.view addSubview:self.gameDetail.view];
    [self.view addSubview:self.detailFooter];
    
    
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

#pragma mark - setter
- (void)setGameID:(NSString *)gameID {
    
    _gameID = gameID;
    
    //请求游戏详情
    [GameModel postGameInfoWithGameID:gameID UserID:@"0" ChannelID:@"185" Comoletion:^(NSDictionary * _Nullable content, BOOL success) {
        
        if (success && !((NSString *)content[@"status"]).boolValue) {
            
            self.gameinfo = content[@"data"][@"gameinfo"];
            
            self.likes = content[@"data"][@"like"];

        }
    }];
    
#warning 1
    //获取评论
//    [ChangyanSDK getTopicComments:[NSString stringWithFormat:@"game_%@",gameID] pageSize:@"5" pageNo:@"5" orderBy:nil style:nil depth:nil subSize:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
//        syLog(@"%@",responseStr);
//    }];
    
    UIViewController *listViewController = [ChangyanSDK getListCommentViewController:@""
                                                                             topicID:nil
                                                                       topicSourceID:[NSString stringWithFormat:@"game_%@",gameID]
                                                                          categoryID:nil
                                                                          topicTitle:nil];
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:listViewController];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
    
    
    [ChangyanSDK getTopicComments:[NSString stringWithFormat:@"game_%@",gameID] pageSize:@"3" pageNo:@"1" orderBy:nil style:nil depth:nil subSize:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        syLog(@"%d",statusCode);
        syLog(@"%@",responseStr);
    }];
    
    
    //请求评论
    [ChangyanSDK getCommentCount:[NSString stringWithFormat:@"game_%@",gameID] topicSourceID:nil topicUrl:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        syLog(@"%d",statusCode);
        syLog(@"%@",responseStr);
    
//        switch (statusCode) {
//                CYSuccess           = 0,    /* 成功 */
//                CYParamsError       = 1,    /* 参数错误 */
//                CYLoginError        = 2,    /* 登录错误 */
//                CYOtherError        = 3,    /* 其他错误 */
//            case CYSuccess:
//                syLog(<#format, ...#>)
//                break;
//
//            default:
//                break;
//        }
    
    }];
    
    
    self.gameGiftBag.gameID = gameID;
    self.gameOpenServer.gameID = gameID;
    self.gameStrategy.gameID = gameID;
}

#pragma markg - gameInfo
/** 设置游戏信息 */
- (void)setGameinfo:(NSDictionary *)gameinfo {
    _gameinfo = gameinfo;
    
    syLog(@"%@",gameinfo);

    //设置游戏名称
    self.detailHeader.gameNameLabel.text = _gameinfo[@"gamename"];
    [self.detailHeader.gameNameLabel sizeToFit];
    
    //设置标签
    NSArray *types = [((NSString *)_gameinfo[@"types"]) componentsSeparatedByString:@" "];
    NSInteger j = 0;
    for (; j < types.count; j++) {
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
    self.detailHeader.source = 3.5;
    
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
    
    //设置游戏轮播图
    self.gameDetail.imagasArray = gameinfo[@"imgs"];
    
    //设置游戏简介
    self.gameDetail.abstract = gameinfo[@"abstract"];
    
    //设置游戏特性
    self.gameDetail.feature = gameinfo[@"feature"];
    
    //设置游戏返利
    self.gameDetail.rebate = gameinfo[@"rebate"];
    
    //是否收藏
    NSString *isCollection = gameinfo[@"collect"];
    self.detailFooter.isCollection = isCollection.boolValue;
    
    [self.gameDetail goToTop];
}

//设置猜你喜欢
- (void)setLikes:(NSArray *)likes {
    self.gameDetail.likes = likes;
//    syLog(@"%@",likes);
}


//设置游戏logo
- (void)setGameLogo:(UIImage *)gameLogo {
    
    UIImage *image = [UIImage imageNamed:@"image_downloading"];
    
    NSData *data1 = UIImagePNGRepresentation(image);
    
    NSData *data2 = UIImagePNGRepresentation(gameLogo);
    
    if ([data1 isEqual:data2]) {
        [self.detailHeader.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_gameinfo[@"lgog"]]] placeholderImage:image];
    
    } else {
        
        self.detailHeader.imageView.image = gameLogo;

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


#pragma mark - getter
- (DetailHeader *)detailHeader {
    if (!_detailHeader) {
        _detailHeader = [[DetailHeader alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 124)];

        _detailHeader.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _detailHeader.layer.shadowOpacity = 1.f;
        _detailHeader.layer.shadowRadius = 2.f;
        _detailHeader.layer.shadowOffset = CGSizeMake(2, 2);
        

        _detailHeader.detailHeaderDelegate = self;
        
    }
    return _detailHeader;
}

- (DetailFooter *)detailFooter {
    if (!_detailFooter) {
        _detailFooter = [[DetailFooter alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 50, kSCREEN_WIDTH, 50)];
    }
    return _detailFooter;
}


#pragma mark - childVeiwController
- (GameDetailViewController *)gameDetail {
    if (!_gameDetail) {
        _gameDetail = [[GameDetailViewController alloc] init];
        _gameDetail.view.frame = CGRectMake(0, CGRectGetMaxY(self.detailHeader.frame) + 5, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.detailHeader.frame) -  255);
        
        _gameDetail.view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _gameDetail.view.layer.shadowOpacity = 1.f;
        _gameDetail.view.layer.shadowRadius = 2.f;
        _gameDetail.view.layer.shadowOffset = CGSizeMake(2, 2);

    }
    return _gameDetail;
}

- (GameStrategyViewController *)gameStrategy {
    if (!_gameStrategy) {
        _gameStrategy = [[GameStrategyViewController alloc] init];
        _gameStrategy.view.frame = CGRectMake(0, CGRectGetMaxY(self.detailHeader.frame) + 5, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.detailHeader.frame) -  255);

    }
    return _gameStrategy;
}

- (GameGiftBagViewController *)gameGiftBag {
    if (!_gameGiftBag) {
        _gameGiftBag = [[GameGiftBagViewController alloc] init];
        _gameGiftBag.view.frame = CGRectMake(0, CGRectGetMaxY(self.detailHeader.frame) + 5, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.detailHeader.frame) -  255);

    }
    return _gameGiftBag;
}

- (GameOpenServerViewController *)gameOpenServer {
    if (!_gameOpenServer) {
        _gameOpenServer = [[GameOpenServerViewController alloc] init];
        _gameOpenServer.view.frame = CGRectMake(0, CGRectGetMaxY(self.detailHeader.frame) + 5, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.detailHeader.frame) -  255);

    }
    return _gameOpenServer;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
