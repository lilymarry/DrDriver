//
//  SLContratViewController.m
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/14.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "SLContratViewController.h"
#import "SchoolViewCell.h"
#import "SLContractDetialController.h"
#import "SLContract.h"

@interface SLContratViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSString * currentPage;//当前分页数
}
@property(nonatomic, strong, readwrite) UITableView *tabelView;
@property(nonatomic, strong, readwrite) NSMutableArray *dataArray;
@end

@implementation SLContratViewController

#pragma mark - 声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"合约列表";
    self.view.backgroundColor = TABLEVIEW_BACKCOLOR;
    [self setUpTableView];
    [self setUpNav];
    
     self.dataArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshDown];
}

//下拉刷新
-(void)refreshDown
{
    currentPage=@"1";
    [self creatHttp];
}

//上拉加载
-(void)refreshUp
{
    currentPage=[NSString stringWithFormat:@"%d",[currentPage intValue]+1];
    [self creatHttp];
}

//请求数据
-(void)creatHttp
{
    __weak typeof(self) weakSelf = self;
    
    NSString *urlStr= @"";
    NSDictionary *dict = @{};
    
    
    if ([self.whichType isEqualToString:@"0"]) {
        urlStr = DRIVER_SCHOOLBUS_CONTRACT_LIST;
        
    }else{
        urlStr = DRIVER_WORK_CONTRACT_LIST;
    }
    dict = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"p":currentPage};
    [AFRequestManager postRequestWithUrl:urlStr params:dict tost:YES special:0 success:^(id responseObject) {
        
//        NSLog(@"DRIVER_SCHOOLBUS_CONTRACT_LIST ==== %@",responseObject[@"data"]);
        NSArray * array=[SLContract mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        if ([currentPage intValue]==1) {
            [weakSelf.dataArray removeAllObjects];
        }
        
        [weakSelf.dataArray addObjectsFromArray:array];
        [weakSelf.tabelView reloadData];
        
        [weakSelf.tabelView.mj_header endRefreshing];
        [weakSelf.tabelView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakSelf.tabelView.mj_header endRefreshing];
        [weakSelf.tabelView.mj_footer endRefreshing];
        
    }];
}

//设置导航栏
-(void)setUpNav
{
    UIButton * navBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame=CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}
//导航栏返回按钮
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView
- (void)setUpTableView{
    
    self.tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    self.tabelView.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    self.tabelView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.tabelView];
       //添加下拉刷新及上拉加载
        self.tabelView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDown)];
        self.tabelView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
        
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SchoolViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolViewCell"];
    if (!cell) {
        cell  = [[SchoolViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SchoolViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.contract = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SLContractDetialController *detialVC = [[SLContractDetialController alloc] init];
    SLContract *contract = self.dataArray[indexPath.row];
    detialVC.contract_id = contract.contract_id;
    detialVC.whichType = self.whichType;
    [self.navigationController pushViewController:detialVC animated:YES];
}

@end
