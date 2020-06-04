//
//  ITFindUserOrderViewController.m
//  DrDriver
//
//  Created by fy on 2019/2/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITFindUserOrderViewController.h"
#import "ITUserOrderTableViewCell.h"
#import "ITUserDetailViewController.h"

@interface ITFindUserOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *currentPage;//当前分页数
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UILabel *nullLabel;

@end

@implementation ITFindUserOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"匹配列表";
    self.view.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.dataArr = [NSMutableArray array];
    [self setUpNav];
    currentPage = @"1";
    [self creatTableView];
    self.nullLabel = [[UILabel alloc] init];
    self.nullLabel.text = @"暂无匹配乘客";
    self.nullLabel.font = [UIFont systemFontOfSize:22];
    self.nullLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.nullLabel];
    [self.nullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_top).offset(30);
    }];
    [self creatHttp];
}
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
-(void)creatHttp{
    NSDictionary *dic = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],
                          @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                          @"travel_id":self.travel_id};
    NSLog(@"NSDictionary *dic =%@",dic);
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_MATCH_ORDER_LIST params:dic tost:YES special:0 success:^(id responseObject) {
        NSLog(@"responseObjectresponseObject%@",responseObject);
        
        if ([currentPage intValue]==1) {
            [self.dataArr removeAllObjects];
        }
        
        [self.dataArr addObjectsFromArray:responseObject[@"data"]];
        [self.tableView reloadData];
        if (self.dataArr.count == 0) {
            self.nullLabel.hidden = NO;
        }else{
            self.nullLabel.hidden = YES;
        }
        
        [self.tableView.mj_header endRefreshing];
        if ([currentPage intValue]>[responseObject[@"total_page"] intValue]) {
            [self.tableView .mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
-(void)creatTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, k_Height_NavBar, DeviceWidth, self.view.frame.size.height - k_Height_NavBar - Bottom_Height) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ITUserOrderTableViewCell class] forCellReuseIdentifier:@"InTravelTableViewCell"];
    //    self.tableView.tableHeaderView = self.topView;
    
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDown)];
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max ? 34 : 0;
}
#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ITUserOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InTravelTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setData:self.dataArr[indexPath.row]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        NSDictionary *dic = self.dataArr[indexPath.row];
    //    if ([self.searchModel.passenger_num isEqualToString:@"-"]) {
    //        self.selectBlock(dic[@"travel_id"],@"1");
    //    }else{
    //        self.selectBlock(dic[@"travel_id"],self.searchModel.passenger_num);
    //    }
    ITUserDetailViewController *vc = [[ITUserDetailViewController alloc] init];
    vc.state = @"find";
    vc.order_id = dic[@"order_id"];
    vc.travel_id = self.travel_id;
    vc.isCanListen = self.isCanListen;
    vc.getMainData = ^{
        
    };
    [self.navigationController pushViewController:vc animated:YES];
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

//导航栏返回按钮点击事件
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
