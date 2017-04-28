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


@interface HomeViewController ()<HomeHeaderDelegate,UISearchControllerDelegate,UISearchBarDelegate>


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

@property (nonatomic, strong) UISearchController  *searchController;
/**< 搜索 */
@property (nonatomic, strong) UISearchBar *searchBar;

/**< 应用按钮(左边按钮) */
@property (nonatomic, strong) UIBarButtonItem *downLoadBtn;

/**< 消息按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *messageBtn;

/**< 取消按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *cancelBtn;


@end



@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.titleView = self.searchBar;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.titleView = nil;
}

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
    
    //请求数据总借口
    [RequestUtils postRequestWithURL:URLMAP params:nil completion:^(NSDictionary *content, BOOL success) {
        
    }];

}

/**< 初始化用户界面 */
- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
//    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];


    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.view addSubview:self.selectView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    //页面添加左右轻扫手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipe];
    [self.view addGestureRecognizer:leftSwipe];
    
#warning 导航栏的两个按钮,还没有做处理

//    self.navigationItem.titleView = self.searchController.searchBar;
    
    self.navigationItem.leftBarButtonItem = self.downLoadBtn;
    self.navigationItem.rightBarButtonItem = self.messageBtn;
    
    
}

#pragma mark- responds
/**< 手势的响应事件 */
- (void)respondsToSwipe:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft && _currentIndex >= 0 && _currentIndex < 3) {
        
        [self didselectViewAtIndexPath:_currentIndex + 1];  //切换视图
        self.selectView.index = _currentIndex;  //切换标签

    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight && _currentIndex > 0 && _currentIndex <= 3) {

        [self didselectViewAtIndexPath:_currentIndex - 1];  //切换视图
        self.selectView.index = _currentIndex;  //切换标签
    }
}

- (void)clickDownloadBtn {
    
}

- (void)clickMessageBtn {
    
}

- (void)clickCancelBtn {
    
}

#warning 还未处理,搜索的代理事件,
- (void)willPresentSearchController:(UISearchController *)searchController {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    NSLog(@"didPresentSearchController");
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"应用" style:0 target:self action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"应用" style:0 target:self action:nil];
    NSLog(@"didDismissSearchController");
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    // 创建出搜索使用的表示图控制器
//
//    [self presentViewController:self.searchController animated:YES completion:^{
//        // 当模态推出这个searchController的时候,需要把之前的searchBar隐藏,如果希望搜索的时候看不到热门搜索什么的,可以把这个页面给隐藏
//
//        
//    }];
}


#pragma mark - method
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
            self.currentController = newController;
            
        }else{
            
            self.currentController = oldController;
            
        }
        
        self.isAnimation = NO;
    }];
}


/**< 选择了哪个页面 */
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
/**< 标签按钮的响应 */
- (void)didSelectBtnAtIndexPath:(NSInteger)idx {
    [self didselectViewAtIndexPath:idx];
}

/**< 是否在动画中(如果在动画中则不能切换视图) */
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

/**< 搜索控制器 */
- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:[ControllerManager shareManager].searchResultController];
        
        _searchController.searchResultsUpdater = (id)[ControllerManager shareManager].searchResultController;
        _searchController.delegate = self;
        
        [_searchController.searchBar sizeToFit];
        _searchController.searchBar.backgroundColor = [UIColor clearColor];
        _searchController.searchBar.placeholder= @"请输入关键字搜索";
        _searchController.searchBar.barStyle = UISearchBarStyleDefault;
        
//        _searchController.searchBar.backgroundColor = [UIColor blackColor];
//        _searchController.searchBar.barStyle = UIBarStyleBlack;
        [_searchController.searchBar setBarTintColor:[UIColor blackColor]];
        [_searchController.searchBar setTintColor:[UIColor whiteColor]];
        
        //隐藏导航栏
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.obscuresBackgroundDuringPresentation = NO;
        _searchController.dimsBackgroundDuringPresentation = NO;
    }
    return _searchController;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
        //        [_searchBar sizeToFit];
        
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor whiteColor]];
            searchField.layer.cornerRadius = 14.0f;
            searchField.layer.masksToBounds = YES;
        }
        
//        _searchBar.backgroundColor = [UIColor blackColor];
        _searchBar.placeholder = @"搜索游戏";
        
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UIBarButtonItem *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"homePage_download"] style:(UIBarButtonItemStyleDone) target:self action:@selector(clickDownloadBtn)];
    }
    return _downLoadBtn;
}

- (UIBarButtonItem *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"homePage_message"] style:(UIBarButtonItemStyleDone) target:self action:@selector(clickMessageBtn)];
    }
    return _messageBtn;
}

- (UIBarButtonItem *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickCancelBtn)];
    }
    return _cancelBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
