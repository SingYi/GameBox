//
//  GameDetailViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/20.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GameDetailViewController.h"
#import "DetailTableCell.h"
#import "DetialTableHeader.h"
#import "ControllerManager.h"

#import "GameDetailTableViewCell.h"
#import "GDLikesTableViewCell.h"
#import "GDCommentTableViewCell.h"
#import "GifTableViewCell.h"

#import "GDCommentDetailController.h"

#import "ChangyanSDK.h"
#import <UIImage+GIF.h>
#import <UIImageView+WebCache.h>

#import <UIView+WebCache.h>


#import <ImageIO/ImageIO.h>
#import "objc/runtime.h"
#import "NSImage+WebCache.h"



#define DetailTableCellIDE @"GameDetailTableViewCell"
#define GDLIKESCELL @"GDLikesTableViewCell"
#define GDCOMMENTCELLIDE @"GDCommentTableViewCell"
#define GIFCELLIDE @"GifTableViewCell"

@interface GameDetailViewController ()<UITableViewDelegate,UITableViewDataSource,GDLikesTableViewCellDelegate>

/**头部视图*/
@property (nonatomic, strong) DetialTableHeader *headerView;

/**尾部视图:点击显示更多评论*/
@property (nonatomic, strong) UIView *footerView;

/**游戏内容和评论*/
@property (nonatomic, strong) UITableView *tableView;

/**用于显示的数组*/
@property (nonatomic, strong) NSArray *showArray;

/**section显示的数组*/
@property (nonatomic, strong) NSArray * sectionTitleArray;

/** 上次点击的cell */
@property (nonatomic, strong) GameDetailTableViewCell *lastCell;

/** 返回的行高 */
@property (nonatomic, strong) NSMutableArray *rowHeightArray;

/** 更多评论页码 */
@property (nonatomic, strong) GDCommentDetailController *GDCommentController;


@end

@implementation GameDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterFace];
    _sectionTitleArray = @[@"    游戏简介:",@"    游戏特征:",@"    精彩时刻:",@"     VIP价格:",@"    猜你喜欢:",@"    用户评论:"];
    
    _rowHeightArray = [@[@100.f,@100.f,@100.f,@100.f] mutableCopy];
    _commentArray = @[];

}


- (void)initUserInterFace {
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - method
- (void)goToTop {
    [self.tableView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark - setter
- (void)setImagasArray:(NSArray *)imagasArray {
    _imagasArray = imagasArray;
    self.headerView.imageArray = imagasArray;
}

- (void)setLikes:(NSArray *)likes {
    _likes = likes;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    [self.tableView reloadData];
}

#pragma mark - respond
- (void)respondsToMoreCommentBtn {
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    self.GDCommentController.gameID = _gameID;
    [self.navigationController pushViewController:self.GDCommentController animated:YES];
}


#pragma mark - getter
//游戏简介
- (void)setAbstract:(NSString *)abstract {
    NSMutableString *str = [abstract mutableCopy];
    NSString *last = [str substringFromIndex:str.length - 1];
    while ([last isEqualToString:@"\n"]) {
        str = [[str substringToIndex:str.length - 1] mutableCopy];
        last = [str substringFromIndex:str.length - 1];
    }
    
    CGSize size = [self sizeForString:str Width:kSCREEN_WIDTH Height:MAXFLOAT];
    
    
    if ((size.height + 10.f) > 100.f) {
        [_rowHeightArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:(size.height + 30.f)]];
    } else {
        [_rowHeightArray replaceObjectAtIndex:0 withObject:@100.f];
    }
    

    
    _abstract = str;
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
    [self.tableView reloadData];
}

//游戏特征
- (void)setFeature:(NSString *)feature {
    NSMutableString *str = [feature mutableCopy];
    
    CGSize size = [self sizeForString:str Width:kSCREEN_WIDTH Height:MAXFLOAT];
    
    
    if ((size.height + 10.f) > 100.f) {
        [_rowHeightArray replaceObjectAtIndex:1 withObject:[NSNumber numberWithFloat:(size.height + 30.f)]];
    } else {
        [_rowHeightArray replaceObjectAtIndex:1 withObject:@100.f];
    }
    
    
    _feature = str;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:(UITableViewRowAnimationNone)];
}

//游戏返利
- (void)setRebate:(NSString *)rebate {
    NSMutableString *str = [rebate mutableCopy];
    if (str.length != 0) {
        
        NSString *last = [str substringFromIndex:str.length - 1];
        while ([last isEqualToString:@"\n"]) {
            str = [[str substringToIndex:str.length - 1] mutableCopy];
            last = [str substringFromIndex:str.length - 1];
        }
    }
    
    
    
    CGSize size = [self sizeForString:str Width:kSCREEN_WIDTH Height:MAXFLOAT];
    
    
    if ((size.height + 10.f) > 100.f) {
        [_rowHeightArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithFloat:(size.height + 30.f)]];
    } else {
        [_rowHeightArray replaceObjectAtIndex:2 withObject:@100.f];
    }
    
    
    _rebate = str;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:(UITableViewRowAnimationNone)];
}

//gifUrl
- (void)setGifUrl:(NSString *)gifUrl {
    _gifUrl = gifUrl;
    
//    GifTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
//    
//    cell.isLoadGif = NO;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:(UITableViewRowAnimationNone)];
}

//gifModel
- (void)setGifModel:(NSString *)gifModel {
    _gifModel = gifModel;
//    
//    GifTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
//    
//    cell.isLoadGif = NO;
    

    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:(UITableViewRowAnimationNone)];
}

// vip
- (void)setVip:(NSString *)vip {
    NSMutableString *str = [vip mutableCopy];
    
    CGSize size = [self sizeForString:str Width:kSCREEN_WIDTH Height:MAXFLOAT];
    
    
    if ((size.height + 10.f) > 100.f) {
        [_rowHeightArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithFloat:(size.height + 30.f)]];
    } else {
        [_rowHeightArray replaceObjectAtIndex:3 withObject:@100.f];
    }
    
    
    _vip = str;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:(UITableViewRowAnimationNone)];
}

//评论
- (void)setCommentArray:(NSArray *)commentArray {
    _commentArray = commentArray;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:_sectionTitleArray.count - 1] withRowAnimation:(UITableViewRowAnimationNone)];
}

- (void)setGameID:(NSString *)gameID {
    _gameID = gameID;
}

/** 计算字符串需要的尺寸 */
- (CGSize)sizeForString:(NSString *)string Width:(CGFloat)width Height:(CGFloat)height {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize retSize = [string boundingRectWithSize:CGSizeMake(width, height)
                                       options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    return retSize;
}



#pragma mark - tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == _sectionTitleArray.count - 1) {
        return _commentArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GameDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailTableCellIDE];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.layer.masksToBounds = YES;
    
    switch (indexPath.section) {
            //游戏简介
        case 0: {
            cell.detail.text = self.abstract;
            cell.detail.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, ((NSNumber *)_rowHeightArray[indexPath.section]).floatValue);
            cell.isOpen = NO;
            cell.tag = 10086;
            if (cell.isOpen) {
                cell.detail.lineBreakMode = NSLineBreakByWordWrapping;
            } else {
                cell.detail.lineBreakMode = NSLineBreakByTruncatingMiddle;
            }
            break;
        }
            //游戏特性
        case 1: {
            cell.detail.text = self.feature;
            cell.detail.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, ((NSNumber *)_rowHeightArray[indexPath.section]).floatValue);
            cell.isOpen = NO;
            cell.tag = 10086;
            if (cell.isOpen) {
                cell.detail.lineBreakMode = NSLineBreakByWordWrapping;
            } else {
                cell.detail.lineBreakMode = NSLineBreakByTruncatingMiddle;
            }
            break;
        }
            //GIF
        case 2: {
#warning GIF
            GifTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GIFCELLIDE];
            
            
            if ([_gifModel isEqualToString:@"1"]) {
                
                cell.gifImageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.618);
                
            } else {

                cell.gifImageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH * 0.618 * 0.618, kSCREEN_WIDTH * 0.618);
                
                cell.gifImageView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH * 0.618 / 2);
            }
            
            
            [cell.gifImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_gifUrl]]];
            
            cell.isLoadGif = NO;
            
            NSData *length = UIImageJPEGRepresentation(cell.gifImageView.image,1);
            
            syLog(@"GIF图(静) = %lfM",length.length / 1024.f / 1024.f);
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_gifUrl]] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                long len = data.length;
                syLog(@"GIF图(动) = %lfM",len / 1024 / 1024.f);
                
            }];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.contentView addSubview:cell.label];
            cell.label.text = @"GIF";
        
            return cell;

            break;
        }
            //VIP价格
        case 3: {
            cell.detail.text = self.vip;
            cell.detail.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, ((NSNumber *)_rowHeightArray[indexPath.section]).floatValue);
            cell.isOpen = NO;
            cell.tag = 10086;
            
            if (cell.isOpen) {
                cell.detail.lineBreakMode = NSLineBreakByWordWrapping;
            } else {
                cell.detail.lineBreakMode = NSLineBreakByTruncatingMiddle;
            }
            break;
        }
            //猜你喜欢
        case 4: {
            GDLikesTableViewCell *celllieks = [tableView dequeueReusableCellWithIdentifier:GDLIKESCELL];
            celllieks.array = self.likes;
            
            celllieks.delegate = self;
            
            return celllieks;
            
            break;
        }
            //用户评论
        default: {
            GDCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GDCOMMENTCELLIDE];
            
            cell.userNick = _commentArray[indexPath.row][@"passport"][@"nickname"];
            
            cell.contentStr = _commentArray[indexPath.row][@"content"];
            
            NSMutableString *time = [NSMutableString stringWithFormat:@"%@",_commentArray[indexPath.row][@"create_time"]];
            
            time = [[time substringToIndex:time.length - 3] mutableCopy];
            
            NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"YYYY-MM-dd";
            cell.time = [formatter stringFromDate:creatDate];
            
            
            return cell;
        }
            break;
    }
    
    

    return cell;
}

#pragma mark - tableViewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        GifTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.isLoadGif) {
            
        } else {
            
            cell.gifUrl = _gifUrl;
            cell.isLoadGif = YES;
        }

    }
    
    if (indexPath.section < 4 && indexPath.section != 2) {
        
        GameDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [tableView beginUpdates];
        if (_lastCell) {
            if (cell.tag == _lastCell.tag) {
                cell.isOpen = !cell.isOpen;
            } else {
                _lastCell.isOpen = NO;
                cell.isOpen = YES;
                _lastCell = cell;
            }
        } else {
            cell.isOpen = YES;
            _lastCell = cell;
        }
        
        if (cell.isOpen) {
            cell.detail.lineBreakMode = NSLineBreakByWordWrapping;
        } else {
            cell.detail.lineBreakMode = NSLineBreakByTruncatingMiddle;
        }
        
        [tableView endUpdates];
    } else {
        
        
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        switch (_gifModel.integerValue) {
            case 0:
                return 0;
            default:
                return kSCREEN_WIDTH * 0.618;
        }
    }
    
    switch (indexPath.section) {
        case 0:
        case 1:
//        case 2:
        case 3: {
            GameDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell.isOpen) {
                return ((NSNumber *)_rowHeightArray[indexPath.section]).floatValue;
                //                return 400;
            } else {
                return 100;
            }
        }
       case 4:
            return 100;
        default:
            return 80;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        switch (_gifModel.integerValue) {
            case 0:
                return 0;
            default:
                return 30;
        }
    } else {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, kSCREEN_WIDTH, 28)];
    label.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    if (section < 4) {
        
        label.text = self.sectionTitleArray[section];
    } else {
        label.text = [NSString stringWithFormat:@"%@",self.sectionTitleArray[section]];
    }
    

    
    
    [view addSubview:label];
    
    
    return view;
}

#pragma mark - gdlikesCellDelegate
- (void)GDLikesTableViewCell:(GDLikesTableViewCell *)cell clickGame:(NSDictionary *)dict {
    [ControllerManager shareManager].detailView.gameID = dict[@"id"];
    
    [ControllerManager shareManager].detailView.gameLogo = dict[@"gameLogo"];
}



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 245) style:(UITableViewStylePlain)];

//        syLog(@"%lf[======%lf",self.view.frame.size.height,CGRectGetHeight(self.view.frame));
        [_tableView registerNib:[UINib nibWithNibName:@"GameDetailTableViewCell" bundle:nil] forCellReuseIdentifier:DetailTableCellIDE];
        
        [_tableView registerNib:[UINib nibWithNibName:@"GDLikesTableViewCell" bundle:nil] forCellReuseIdentifier:GDLIKESCELL];
        
        [_tableView registerNib:[UINib nibWithNibName:@"GDCommentTableViewCell" bundle:nil] forCellReuseIdentifier:GDCOMMENTCELLIDE];
        
        [_tableView registerClass:[GifTableViewCell class] forCellReuseIdentifier:GIFCELLIDE];
        
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.estimatedRowHeight = 100;
        _tableView.autoresizesSubviews = YES;
        
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
//        _tableView.tableFooterView = [UIView new];
        
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
//        _tableView.bounces = NO;
    }
    
    return _tableView;
}


- (DetialTableHeader *)headerView {
    if (!_headerView) {
        _headerView = [[DetialTableHeader alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH,46)];
        
        _footerView.backgroundColor = RGBCOLOR(247, 247, 247);
        
        //响应事件
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, 1, kSCREEN_WIDTH, 44);
        
        [button setTitle:@"点击查看更多评论>" forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        [button addTarget:self action:@selector(respondsToMoreCommentBtn) forControlEvents:(UIControlEventTouchUpInside)];
        button.backgroundColor = [UIColor whiteColor];
        
        [_footerView addSubview:button];
        
        
        
    }
    return _footerView;
}

- (GDCommentDetailController *)GDCommentController {
    if (!_GDCommentController) {
        _GDCommentController = [[GDCommentDetailController alloc] init];
    }
    return _GDCommentController;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark =================================================================
- (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}


- (UIImage *)gifImage:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            duration += [self sd_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

- (NSDictionary *)gifDict:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    NSDictionary *dict;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
        dict = @{@"images":@[animatedImage],@"duration":@0};
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            duration += [self sd_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        dict = @{@"images":images,@"duration":[NSNumber numberWithFloat:duration]};
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return dict;
}



@end
