//
//  ITScanTripViewController.m
//  DrDriver
//
//  Created by fy on 2019/5/23.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITScanTripViewController.h"

#import "OrdeModel.h"
#import "ScanTripDetailViewController.h"
#import "ScanTripTableViewCell.h"
#import "IndependentTravelView.h"


@interface ITScanTripViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView * myTableView;
    NSMutableArray * orderArray;
    NSString * currentPage;//当前分页数
    BOOL isNeedReload;
}

@end

@implementation ITScanTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"行程";
    isNeedReload = NO;
    currentPage=@"1";
    orderArray=[[NSMutableArray alloc]init];
    
    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    [self requestOrder];//请求订单列表
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
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"8"]){
        NSArray * vcArray=self.navigationController.viewControllers;
        for (IndependentTravelView * vc in vcArray) {
            
            if ([vc isKindOfClass:[IndependentTravelView class]]) {
                
                vc.isNeedReload = isNeedReload;
                
                [self.navigationController popToViewController:vc animated:YES];
            }
            
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//下拉刷新
-(void)refreshDown
{
    currentPage=@"1";
    [self requestOrder];
}

//上拉加载
-(void)refreshUp
{
    currentPage=[NSString stringWithFormat:@"%d",[currentPage intValue]+1];
    [self requestOrder];
}
//请求订单列表
-(void)requestOrder
{
    
    [AFRequestManager postRequestWithUrl:DRIVER_JOURNEY_ORDER_LIST params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"p":currentPage,@"isqrcode":@"1"} tost:YES special:0 success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *array = [NSArray array];
        
        array = [OrdeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        if ([currentPage intValue]==1) {
            [orderArray removeAllObjects];
        }
        [orderArray addObjectsFromArray:array];
        
        [myTableView reloadData];
        
        [myTableView.mj_header endRefreshing];
        if ([currentPage intValue]>[responseObject[@"total_page"] intValue]) {
            [myTableView .mj_footer endRefreshingWithNoMoreData];
        }else{
            [myTableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        
        [myTableView.mj_header endRefreshing];
        [myTableView.mj_footer endRefreshing];
        
    }];
}

//创建主要视图
-(void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 114 - Top_Height - Bottom_Height) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[ScanTripTableViewCell class] forCellReuseIdentifier:@"ScanTripTableViewCell"];
    
    //添加下拉刷新及上拉加载
    myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDown)];
    myTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
    
    UIView * footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 30)];
    footView.backgroundColor=TABLEVIEW_BACKCOLOR;
    [myTableView setTableFooterView:footView];
    
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return orderArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 10)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 93;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrdeModel * order=orderArray[indexPath.section];
    ScanTripTableViewCell *ScanTripTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ScanTripTableViewCell" forIndexPath:indexPath];
    ScanTripTableViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
    ScanTripTableViewCell.timeLB.text = order.ctime;
    ScanTripTableViewCell.expensesLB.text = [NSString stringWithFormat:@"费用：%@",order.actual_price];
    ScanTripTableViewCell.orderIDLB.text = [NSString stringWithFormat:@"订单号：%@",order.order_sn];
    return ScanTripTableViewCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrdeModel * order=orderArray[indexPath.section];
    ScanTripDetailViewController *scan = [[ScanTripDetailViewController alloc] init];
    scan.order_id = order.order_id;
    [self.navigationController pushViewController:scan animated:YES];
    
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
