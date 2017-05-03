//
//  MyAppViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "MyAppViewController.h"
#import "AppModel.h"

@interface MyAppViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *showArray;
@property (nonatomic, strong) NSMutableDictionary *data;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MyAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
    [self initDataSource];
}

- (void)initDataSource {
    NSMutableDictionary *dict = [AppModel Apps];
    NSArray *array = [dict allKeys];
    _data = [NSMutableDictionary dictionary];
    [array enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dict[obj][@"applicationType"] isEqualToString:@"System"]) {
            
        } else {
            [_data setObject:dict[obj] forKey:obj];
        
        }
        
    }];
    _showArray = [_data allKeys];
    
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(task) userInfo:nil repeats:YES];
}

- (void)task {
    CLog(@"刷新");
    NSMutableDictionary *dict = [AppModel Apps];
    NSArray *array = [dict allKeys];
    _data = [NSMutableDictionary dictionary];
    [array enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dict[obj][@"applicationType"] isEqualToString:@"System"]) {
            
        } else {
            [_data setObject:dict[obj] forKey:obj];
        }
        
    }];
    _showArray = [_data allKeys];
    
    [self.tableView reloadData];
}


- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"test"];
    }
    
    NSDictionary *dict = _data[_showArray[indexPath.row]];
    
    
    cell.imageView.image = dict[@"appIcon"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 版本(%@)  bundleID:%@",dict[@"localizedName"],dict[@"bundleVersion"],_showArray[indexPath.row]];
    
//    NSNumber *zise = dict[@"staticDiskUsage"];
    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"大小 :%.2lfM 开发人员ID:%@",zise.integerValue / 1024 / 1024.f,dict[@"teamID"]];
    
    
    NSProgress *progress = dict[@"installProgress"];
    
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",progress.localizedDescription];
    
    
//    CLog(@"%@",dict);
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //打开app
//    [AppModel openAPPWithIde:_showArray[indexPath.row]];
    [AppModel installAPPWithIDE:_showArray[indexPath.row]];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}







@end









