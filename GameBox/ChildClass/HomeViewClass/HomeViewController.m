//
//  HomeViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/13.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeader.h"
#import "ControllerManager.h"

#import "HomeRecommentController.h"
#import "HomeNewGameController.h"
#import "HomeHotGameController.h"
#import "HomeClassifyController.h"

#import "RequestUtils.h"


#define RecommendCellIDE @"RecommendCell"
#define NewGameCellIDE @"NewGameCell"
#define HotCellIDE @"HotCell"
#define ClassifyCellIDE @"ClassifyCell"


@interface HomeViewController ()<HomeHeaderDelegate>


/**头部选择标签视图*/
@property (nonatomic, strong) HomeHeader *selectView;

/**最上面4个滑动的子视图*/
/**推荐视图*/
@property (nonatomic, strong) HomeRecommentController *hRecommentController;

/**新游视图*/
@property (nonatomic, strong) HomeNewGameController *hNewgameController;

/**热门视图*/
@property (nonatomic, strong) HomeHotGameController *hHotGameController;

/**分类视图*/
@property (nonatomic, strong) HomeClassifyController *hClassifyController;

/**当前视图*/
@property (nonatomic, strong) UIViewController *currentController;

/**当前按钮下标*/
@property (nonatomic, assign) NSInteger currentIndex;

/**动画效果状态*/
@property (nonatomic, assign) BOOL isAnimation;

/**向左滑*/
@property (nonatomic, assign) BOOL isLeft;


@end



@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [self addChildViewController:self.hRecommentController];
    self.currentController = self.hRecommentController;
    _currentIndex = 0;
    [self.view addSubview:self.hRecommentController.view];
    _isAnimation = NO;
    _isLeft = NO;
    
    [RequestUtils postRequestWithURL:URLMAP params:nil completion:^(NSDictionary *content, BOOL success) {
//        NSLog(@"%@",content);
    }];

}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.view addSubview:self.selectView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipe];
    [self.view addGestureRecognizer:leftSwipe];
}

- (void)respondsToSwipe:(UISwipeGestureRecognizer *)sender {
    
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft && _currentIndex >= 0 && _currentIndex < 3) {
        
        [self didselectViewAtIndexPath:_currentIndex + 1];
        self.selectView.index = _currentIndex;

    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight && _currentIndex > 0 && _currentIndex <= 3) {

        [self didselectViewAtIndexPath:_currentIndex - 1];
        self.selectView.index = _currentIndex;
    }
}


#pragma mark - method
//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
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
            self.currentController = newController;
            
        }else{
            
            self.currentController = oldController;
            
        }
        
        self.isAnimation = NO;
    }];
}

- (void)didselectViewAtIndexPath:(NSInteger)idx {
    if (idx > _currentIndex) {
        _isLeft = YES;
    } else {
        _isLeft = NO;
    }
    
    
    if (idx == _currentIndex || _isAnimation) {
        
    } else {
        _currentIndex = idx;
        switch (idx) {
            case 0:
            {
                [self replaceController:self.currentController newController:self.hRecommentController];
            }
                break;
            case 1:
            {
                [self replaceController:self.currentController newController:self.hNewgameController];
            }
                break;
            case 2:
            {
                [self replaceController:self.currentController newController:self.hHotGameController];
            }
                break;
            case 3:
            {
                [self replaceController:self.currentController newController:self.hClassifyController];
            }
                break;
            default:
                break;
        }
    }
    
}


#pragma mark - headerDelegate
- (void)didSelectBtnAtIndexPath:(NSInteger)idx {
    [self didselectViewAtIndexPath:idx];
}

- (void)setIsAnimation:(BOOL)isAnimation {
    _isAnimation = isAnimation;
    self.selectView.isAnimation = isAnimation;
}

#pragma mark - getter 
- (HomeHeader *)selectView {
    if (!_selectView) {
        _selectView = [[HomeHeader alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 32) WithBtnArray:@[@"推荐",@"新游",@"热门",@"分类"]];
        _selectView.backgroundColor = [UIColor whiteColor];
        
        _selectView.delegate = self;
    }
    return _selectView;
}


/**推荐视图*/
- (HomeRecommentController *)hRecommentController {
    if (!_hRecommentController) {
        _hRecommentController = [[HomeRecommentController alloc] init];
        _hRecommentController.view.frame = CGRectMake(0, 96, kSCREEN_WIDTH, kSCREEN_HEIGHT - 145);
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSwipe:)];
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
        
        [_hHotGameController.view addGestureRecognizer:swipe];
    }
    return _hRecommentController;
}

/**新游视图*/
- (HomeNewGameController *)hNewgameController {
    if (!_hNewgameController) {
        _hNewgameController = [[HomeNewGameController alloc] init];
        _hNewgameController.view.frame = CGRectMake(0, 96, kSCREEN_WIDTH, kSCREEN_HEIGHT - 145);
        
    }
    return _hNewgameController;
}

/**热门视图*/
- (HomeHotGameController *)hHotGameController {
    if (!_hHotGameController) {
        _hHotGameController = [[HomeHotGameController alloc] init];
        _hHotGameController.view.frame = CGRectMake(0, 96, kSCREEN_WIDTH, kSCREEN_HEIGHT - 145);
        
    }
    return _hHotGameController;
}

/**分类视图*/
- (HomeClassifyController *)hClassifyController {
    if (!_hClassifyController) {
        _hClassifyController = [[HomeClassifyController alloc] init];
        _hClassifyController.view.frame = CGRectMake(0, 96, kSCREEN_WIDTH, kSCREEN_HEIGHT - 145);
        
    }
    return _hClassifyController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
