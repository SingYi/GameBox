//
//  SearchGiftResultController.m
//  GameBox
//
//  Created by 石燚 on 2017/5/16.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "SearchGiftResultController.h"
#import "GiftRequest.h"
#import "GiftBagCell.h"
#import "ControllerManager.h"

#import <UIImageView+WebCache.h>

#define CELLIDE @"GiftBagCell"

@interface SearchGiftResultController ()<UITableViewDataSource,UITableViewDelegate,GiftBagCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *showArray;

@end

@implementation SearchGiftResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"搜索结果";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - settter
- (void)setKeyword:(NSString *)keyword {
    if (keyword && ![keyword isEqualToString:_keyword]) {
        _showArray = nil;
        _keyword = keyword;
        [GiftRequest giftSearchWithkeyWord:keyword Completion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success && REQUESTSUCCESS) {
                _showArray = [content[@"data"][@"list"] mutableCopy];
            } else {
                [GiftRequest showAlertWithMessage:@"未查询到相关礼包" dismiss:nil];
            }
            [self.tableView reloadData];

            
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GiftBagCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    cell.currentIdx = indexPath.row;
    
    //礼包logo
    [cell.packLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"pack_logo"]]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];
    
    cell.dict = _showArray[indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    
    [self.navigationController pushViewController:[ControllerManager shareManager].detailView animated:YES];
}

#pragma mark - cellDelegate
- (void)getGiftBagCellAtIndex:(NSInteger)idx {
    NSString *str = _showArray[idx][@"card"];
    
    if ([str isKindOfClass:[NSNull class]]) {
        //领取礼包
        [GiftRequest getGiftWithGiftID:_showArray[idx][@"id"] Completion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success && REQUESTSUCCESS) {
                NSMutableDictionary *dict = [_showArray[idx] mutableCopy];
                [dict setObject:content[@"data"] forKey:@"card"];
                [_showArray replaceObjectAtIndex:idx withObject:dict];
                
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
                
                [GiftRequest showAlertWithMessage:@"已领取礼包兑换码" dismiss:^{
                    
                }];
            } else {
                [GiftRequest showAlertWithMessage:@"礼包发送完了" dismiss:nil];
            }
        }];
        
    } else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        pasteboard.string = str;
        
        [GiftRequest showAlertWithMessage:@"已复制礼包兑换码" dismiss:^{
            
        }];
    }
}
#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"GiftBagCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _tableView.tableFooterView = [UIView new];
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
        
    }
    return _tableView;
}
@end
