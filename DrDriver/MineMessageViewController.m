//
//  MineMessageViewController.m
//  DrDriver
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "MineMessageViewController.h"
#import "MineMessageModel.h"
#import "MineMessageTableViewCell.h"

@interface MineMessageViewController () <UITableViewDelegate,UITableViewDataSource>

{
    UITableView * myTableView;
    NSArray * dataArray;
    NSString * currentPage;//当前分页数
}
@property(nonatomic,strong)NSMutableArray *dateArr;

@end

@implementation MineMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"消息中心";
    currentPage=@"1";
    self.dateArr = [NSMutableArray array];
    [self setUpNav];//设置导航栏
    [self creatHttp];//请求界面数据
    self.view.backgroundColor =[UIColor whiteColor];
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"jpushMessage"];
    
    
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
//请求界面数据
-(void)creatHttp
{
    [AFRequestManager postRequestWithUrl:DRIVER_DRIVERMESSAGE_DRIVER_MESSAGE_INFO params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"p":currentPage} tost:YES special:0 success:^(id responseObject) {
        //分出日期添加的数组dateArr中
        NSMutableArray *dateArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            NSString *ctime = dic[@"ctime"];
            NSArray *array = [ctime componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
            NSString *str = array[0];
            if (![dateArr containsObject:str]) {
                [dateArr addObject:str];
            }
        }
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSString *str in dateArr) {
            NSMutableArray *arr = [NSMutableArray array];
            [dataArr addObject:@{str:arr}];
        }
        //对应日期添加当天的消息到数组中
        for (NSDictionary *datadic in responseObject[@"data"]) {
            NSString *ctime = datadic[@"ctime"];
            NSArray *array = [ctime componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
            NSString *str = array[0];
            for (NSDictionary *dic in dataArr) {
                if ([dic.allKeys[0] isEqualToString:str]) {
                    NSMutableArray *arr = dic.allValues[0];
                    [arr addObject:datadic];
                }
            }
        }
        if ([currentPage intValue]==1) {
            [self.dateArr removeAllObjects];
            [self.dateArr addObjectsFromArray:dataArr];
            [self creatMainView];//创建主要视图
        }else{
            [self.dateArr addObjectsFromArray:dataArr];
            [myTableView reloadData];
        }
        NSLog(@"self.dataArrayself.dataArray%@",self.dateArr);
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
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
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
    return self.dateArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = self.dateArr[section];
    NSMutableArray *arr = dic.allValues[0];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat height=44;
//
//    MineMessageModel * mineMessage=dataArray[indexPath.row];
//    CGFloat textHeight=[CYTSI planRectHeight:mineMessage.content font:14 theWidth:DeviceWidth-42];
//    if (textHeight>44) {
//        height=textHeight;
//    }
    
    return 110;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
    }];
    
    NSDictionary *dic = self.dateArr[section];
    label.text = dic.allKeys[0];
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineMessageTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"minemessagecell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"MineMessageTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.dateArr[indexPath.section];
    cell.titleLB.text=@"系统通知";
    cell.detailLB.text=dic.allValues[0][indexPath.row][@"content"];
    cell.timeLB.text = dic.allValues[0][indexPath.row][@"ctime"];
    
    return cell;
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
