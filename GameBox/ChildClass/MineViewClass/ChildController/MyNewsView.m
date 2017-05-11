//
//  MyNewsView.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "MyNewsView.h"
#import "HomeHeader.h"
#import "MNCommentController.h"
#import "MNNtificationController.h"

@interface MyNewsView ()<HomeHeaderDelegate>

/** 头部选择 */
@property (nonatomic, strong) HomeHeader *headerSelect;
/** 评论视图 */
@property (nonatomic, strong) MNCommentController *commentController;
/** 通知视图 */
@property (nonatomic, strong) MNNtificationController *nitificationController;

/**当前视图*/
@property (nonatomic, strong) UIViewController *currentController;

/**当前按钮下标*/
@property (nonatomic, assign) NSInteger currentIndex;

/**动画效果状态*/
@property (nonatomic, assign) BOOL isAnimation;

/**向左滑*/
@property (nonatomic, assign) BOOL isLeft;

@end

@implementation MyNewsView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [self addChildViewController:self.commentController];
    self.currentController = self.commentController;
    _currentIndex = 0;
    [self.view addSubview:self.commentController.view];
    _isAnimation = NO;
    _isLeft = NO;
}


- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的消息";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.headerSelect];
    
    
    //页面添加左右轻扫手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipe];
    [self.view addGestureRecognizer:leftSwipe];

}

/** 手势的响应事件 */
- (void)respondsToSwipe:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft && _currentIndex == 0) {
        
        [self didselectViewAtIndexPath:_currentIndex + 1];  //切换视图
        self.headerSelect.index = _currentIndex;  //切换标签
        
    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight && _currentIndex == 1) {
        
        [self didselectViewAtIndexPath:_currentIndex - 1];  //切换视图
        self.headerSelect.index = _currentIndex;  //切换标签
    }
}

#pragma mark - headerDelegate
/** 标签按钮的响应 */
- (void)didSelectBtnAtIndexPath:(NSInteger)idx {
    [self didselectViewAtIndexPath:idx];
}

/** 是否在动画中(如果在动画中则不能切换视图) */
- (void)setIsAnimation:(BOOL)isAnimation {
    _isAnimation = isAnimation;
    self.headerSelect.isAnimation = isAnimation;
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
                [self replaceController:self.currentController newController:self.commentController];
            }
                break;
            case 1:
            {
                [self replaceController:self.currentController newController:self.nitificationController];
            }
                break;
            default:
                break;
        }
    }
    
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


#pragma mark - getter 
/** 头部选择器 */
- (HomeHeader *)headerSelect {
    if (!_headerSelect) {
        _headerSelect = [[HomeHeader alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 44) WithBtnArray:@[@"评论",@"通知"]];
        _headerSelect.backgroundColor = [UIColor whiteColor];
        
        _headerSelect.delegate = self;
    }
    return _headerSelect;
}

/** 评论视图 */
- (MNCommentController *)commentController {
    if (!_commentController) {
        _commentController = [[MNCommentController alloc] init];
        _commentController.view.frame = CGRectMake(0, 108, kSCREEN_WIDTH, kSCREEN_HEIGHT - 108);
    }
    return _commentController;
}

/** 开服提醒 */
- (MNNtificationController *)nitificationController {
    if (!_nitificationController) {
        _nitificationController = [[MNNtificationController alloc] init];
        _nitificationController.view.frame = CGRectMake(0, 108, kSCREEN_WIDTH, kSCREEN_HEIGHT - 108);
    }
    return _nitificationController;
}


@end








