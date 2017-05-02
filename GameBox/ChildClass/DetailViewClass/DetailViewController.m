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

#import "UIImageView+WebCache.h"

#import "ChangyanSDK.h"


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

/** 游戏logo */
@property (nonatomic, strong) UIImage * dataImage;


@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.detailHeader.btnArray = @[@"详情",@"攻略",@"礼包",@"开服"];
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
/**< 手势的响应事件 */
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
    [GameModel postGameInfoWithGameID:gameID UserID:@"0" ChannelID:@"185" Comoletion:^(NSDictionary * _Nullable content, BOOL success) {
        
        if (success && !((NSString *)content[@"status"]).boolValue) {
            
            self.gameinfo = content[@"data"][@"gameinfo"];
            self.likes = content[@"data"][@"like"];
            self.navigationItem.title = self.gameinfo[@"gamename"];
            
//            CLog(@"%@",content);
        }
        

    }];
    
    
    self.gameGiftBag.gameID = gameID;
    self.gameOpenServer.gameID = gameID;
    self.gameStrategy.gameID = gameID;
    
    
    /////评论测试
    UIButton *listCommentViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    listCommentViewBtn.backgroundColor = [UIColor blueColor];
    [listCommentViewBtn setTitle:@"评论列表页" forState:UIControlStateNormal];
    listCommentViewBtn.frame = CGRectMake(215, 450, 100, 40);
    [listCommentViewBtn addTarget:self action:@selector(listCommentView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listCommentViewBtn];
    
    
}

- (void)listCommentView {
    UIViewController *listViewController = [ChangyanSDK getListCommentViewController:@""
                                                                             topicID:nil
                                                                       topicSourceID:_gameID
                                                                          categoryID:nil
                                                                          topicTitle:nil];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:listViewController];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
    
//    [self.navigationController pushViewController:listViewController animated:YES];
}

- (void)setGameinfo:(NSDictionary *)gameinfo {
    _gameinfo = gameinfo;
    self.detailHeader.gameNameLabel.text = _gameinfo[@"gamename"];
    self.detailHeader.downLoadNumber.text = [NSString stringWithFormat:@"%@ 次下载",_gameinfo[@"download"]];
    [self.detailHeader.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_gameinfo[@"logo"]]]];
    self.dataImage = self.detailHeader.imageView.image;
    self.gameDetail.imagasArray = gameinfo[@"imgs"];
    self.gameDetail.abstract = gameinfo[@"abstract"];
    self.gameDetail.feature = gameinfo[@"feature"];
}

- (void)setLikes:(NSArray *)likes {
    self.gameDetail.likes = likes;
}

- (void)setDataImage:(UIImage *)dataImage {
    self.gameOpenServer.logoImage = dataImage;
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
        _detailHeader = [[DetailHeader alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 112)];
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
        _gameDetail.view.frame = CGRectMake(0, 180, kSCREEN_WIDTH, kSCREEN_HEIGHT - 230);

    }
    return _gameDetail;
}

- (GameStrategyViewController *)gameStrategy {
    if (!_gameStrategy) {
        _gameStrategy = [[GameStrategyViewController alloc] init];
        _gameStrategy.view.frame = CGRectMake(0, 180, kSCREEN_WIDTH, kSCREEN_HEIGHT - 230);

    }
    return _gameStrategy;
}

- (GameGiftBagViewController *)gameGiftBag {
    if (!_gameGiftBag) {
        _gameGiftBag = [[GameGiftBagViewController alloc] init];
        _gameGiftBag.view.frame = CGRectMake(0, 180, kSCREEN_WIDTH, kSCREEN_HEIGHT - 230);

    }
    return _gameGiftBag;
}

- (GameOpenServerViewController *)gameOpenServer {
    if (!_gameOpenServer) {
        _gameOpenServer = [[GameOpenServerViewController alloc] init];
        _gameOpenServer.view.frame = CGRectMake(0, 180, kSCREEN_WIDTH, kSCREEN_HEIGHT - 230);

    }
    return _gameOpenServer;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
