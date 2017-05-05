//
//  HomeClassifyController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/20.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "HomeClassifyController.h"
#import "ClassfiyTableViewCell.h"
#import "GameModel.h"

#import <SDWebImageDownloader.h>
#import <UIImageView+WebCache.h>

#define CellIDE @"ClassfiyTableViewCell"
#define BTNTAG 1700


@interface HomeClassifyController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<NSDictionary *> *showArry;

@property (nonatomic, strong) NSArray *classifyArray;

@property (nonatomic, strong) UIView *headerView;

@end

@implementation HomeClassifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [GameModel postGameClassifyWithChannel:@"185" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        self.classifyArray = content[@"data"][@"class"];
        self.showArry = content[@"data"][@"classData"];
//        CLog(@"%@",content);
    }];
    

    
}

- (void)initUserInterface {
    [self.view addSubview:self.tableView];
}


#pragma makr - setter
- (void)setShowArry:(NSArray<NSDictionary *> *)showArry {
    _showArry = showArry;
    [self.tableView reloadData];
}

- (void)setClassifyArray:(NSArray *)classifyArray {
    _classifyArray = classifyArray;
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:_classifyArray.count];
    
    [_classifyArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *string = obj[@"name"];
        [titleArray addObject:string];
    }];
    
    CGFloat height = titleArray.count / 4.f;
    NSInteger height1 = height;
    
    if (height > height1) {
        height1++;
    }
    
    self.headerView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH / 4 * height1);
    
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    [_classifyArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *title = obj[@"name"];
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        button.frame = CGRectMake(kSCREEN_WIDTH / 4 * (idx % 4), kSCREEN_WIDTH / 4 * (idx / 4), kSCREEN_WIDTH / 4, kSCREEN_WIDTH / 4);
        [button setTitle:title forState:(UIControlStateNormal)];
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,obj[@"logo"]]] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            
            [button setImage:image forState:(UIControlStateNormal)];
//            CLog(@"图片加载");
        }];
        
        button.tag = idx + BTNTAG;
        [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        
        [button addTarget:self action:@selector(respondsToBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.headerView addSubview:button];
    }];
    
}

- (void)respondsToBtn:(UIButton *)sender {
    
    
    
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showArry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassfiyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIDE];
    NSDictionary *dict = self.showArry[indexPath.section];
    NSArray *gameArray = dict[@"list"];
    NSArray<UIImageView *> *ImageArray = @[cell.imageView1,cell.imageView2,cell.imageView3,cell.imageView4];
    for (NSInteger i = 0; i < gameArray.count; i++) {
        NSDictionary *gamedict = gameArray[i];
        [ImageArray[i] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,gamedict[@"logo"]]]];
    }
    
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
    
    label.backgroundColor = [UIColor lightGrayColor];
    
    NSString *string = self.showArry[section][@"className"];
    
    label.text = [NSString stringWithFormat:@"     %@",string];
    
    return label;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_HEIGHT, kSCREEN_HEIGHT - 145) style:(UITableViewStylePlain)];
        
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ClassifyCell1"];
        [_tableView registerNib:[UINib nibWithNibName:@"ClassfiyTableViewCell" bundle:nil] forCellReuseIdentifier:CellIDE];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
        
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.tableHeaderView = self.headerView;
        
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
    }
    return _headerView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
