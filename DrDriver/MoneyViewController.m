//
//  MoneyViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "MoneyViewController.h"
#import "MoneyTableViewCell.h"
#import "BankCardViewController.h"
#import "SureTiXianViewController.h"
#import "BankCardModel.h"
#import "DriverModel.h"
#import "RecordModel.h"

@interface MoneyViewController () <UITableViewDelegate,UITableViewDataSource>

{
    UITableView * myTableView;
    UIButton * frontButton;
    UIButton * afterButton;
    UILabel * dateLable;
    UILabel * moneyLable;
    
    NSString * currentYear;//当前年份
    NSString * currentMonth;//当前月份
    NSString * lastDateStr;//最后一次请求的时间
    NSString * currentPage;//当前分页数
    
    NSArray * bankArray;//银行卡列表
    NSMutableArray * recordArray;//收支记录数组
    
    DriverModel * driver;//司机信息
    
}

@end

@implementation MoneyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestBankCardList];//请求银行卡列表
    [self requestBalance];//请求余额
//    [self requestRecord];//请求收支记录
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"钱包";
    recordArray = [[NSMutableArray alloc]init];
    currentPage = @"1";
    
    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    [self receveDate];//获取当前时间
    
}

//请求银行卡列表
-(void)requestBankCardList
{
    [AFRequestManager postRequestWithUrl:DRIVER_DRIVERBANK_LIST params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:NO special:0 success:^(id responseObject) {
        
        bankArray=[BankCardModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        
    }];
}

//请求余额
-(void)requestBalance
{
    [AFRequestManager postRequestWithUrl:DRIVER_BASE_DATA params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:NO special:0 success:^(id responseObject) {
        
        driver=[DriverModel mj_objectWithKeyValues:responseObject[@"data"]];
        moneyLable.text=[NSString stringWithFormat:@"账号余额：¥%@",driver.driver_balance];
        
        UIColor * color=[CYTSI colorWithHexString:@"#386ac6"];
        [CYTSI setStringWith:moneyLable.text someStr:[NSString stringWithFormat:@"¥%@",driver.driver_balance] lable:moneyLable theFont:[UIFont systemFontOfSize:25] theColor:color];
        
    } failure:^(NSError *error) {
        
    }];
}

//请求收支记录
-(void)requestRecord:(NSString *)dateStr
{
    [AFRequestManager postRequestWithUrl:DRIVER_CASH_RECORD params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"cash_date":dateStr,@"p":currentPage} tost:YES special:0 success:^(id responseObject) {
        
        NSArray *array=[RecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        if ([currentPage intValue] == 1) {
            
            [recordArray removeAllObjects];
        }
        
        [recordArray addObjectsFromArray:array];
        [myTableView reloadData];
        
        if ([currentPage intValue] >= [responseObject[@"total_page"] intValue]) {
            
            [myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [myTableView.mj_footer endRefreshing];
        }
        
        [myTableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [myTableView.mj_header endRefreshing];
        [myTableView.mj_footer endRefreshing];
        
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
    
    UIButton *  bankCardButton=[UIButton buttonWithType:UIButtonTypeCustom];
    bankCardButton.frame=CGRectMake(0, 0, 40, 20);
    [bankCardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bankCardButton setTitle:@"银行卡" forState:UIControlStateNormal];
    bankCardButton.titleLabel.font=[UIFont systemFontOfSize:13];
    
    [bankCardButton addTarget:self action:@selector(bankCardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:bankCardButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

//导航栏返回按钮点击事件
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

//银行卡按钮点击事件
-(void)bankCardButtonClicked
{
    BankCardViewController * vc=[[BankCardViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


//获取当前时间
-(void)receveDate
{
    currentYear=[NSString stringWithFormat:@"%ld",(long)[CYTSI receiveDateType:0]];
    currentMonth=[NSString stringWithFormat:@"%ld",(long)[CYTSI receiveDateType:1]];

    //更新时间
    [self updateDate];
    
}

//下拉刷新
-(void)refreshDown
{
    currentPage=@"1";
    [self requestRecord:lastDateStr];
}

//下拉加载
-(void)refreshUp
{
    currentPage=[NSString stringWithFormat:@"%d",[currentPage intValue]+1];
    [self requestRecord:lastDateStr];
}

//创建主要视图
-(void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:myTableView];
    
    //添加下拉刷新及上拉加载
    myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDown)];
    myTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
    
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 93)];
    headView.backgroundColor=[UIColor whiteColor];
    
    UIButton * tiXianButton=[UIButton buttonWithType:UIButtonTypeCustom];
    tiXianButton.frame=CGRectMake(DeviceWidth-90, 0, 90, 93);
    [tiXianButton setTitle:@"申请提现" forState:UIControlStateNormal];
    [tiXianButton setTitleColor:[CYTSI colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    tiXianButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [tiXianButton setImage:[UIImage imageNamed:@"money_after"] forState:UIControlStateNormal];
    [tiXianButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [tiXianButton setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
    [tiXianButton addTarget:self action:@selector(tiXianButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:tiXianButton];
    
    moneyLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 28.5, DeviceWidth-90, 36)];
    moneyLable.text=@"账号余额：¥0.00";
    moneyLable.textColor=[CYTSI colorWithHexString:@"#333333"];
    moneyLable.font=[UIFont systemFontOfSize:14];
    moneyLable.textAlignment=NSTextAlignmentCenter;
    [headView addSubview:moneyLable];
    
    UIColor * color=[CYTSI colorWithHexString:@"#386ac6"];
    [CYTSI setStringWith:moneyLable.text someStr:@"¥24.00" lable:moneyLable theFont:[UIFont systemFontOfSize:25] theColor:color];
    
    [myTableView setTableHeaderView:headView];
}

//提现按钮点击事件
-(void)tiXianButtonClicked
{
    if (bankArray.count==0) {
        
        [CYTSI otherShowTostWithString:@"请先添加银行卡"];
        return;
    }
    SureTiXianViewController * vc=[[SureTiXianViewController alloc]init];
    vc.moneyStr=driver.driver_balance;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return recordArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 54)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    UIView * smallView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, DeviceWidth, 44)];
    smallView.backgroundColor=[UIColor whiteColor];
    [bgView addSubview:smallView];
    
    dateLable=[[UILabel alloc]init];
    dateLable.text=[NSString stringWithFormat:@"%@年%@月",currentYear,currentMonth];
    dateLable.textAlignment=NSTextAlignmentCenter;
    dateLable.font=[UIFont systemFontOfSize:14];
    dateLable.textColor=[CYTSI colorWithHexString:@"#333333"];
    [smallView addSubview:dateLable];
    [dateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(smallView.mas_centerY);
        make.centerX.equalTo(smallView.mas_centerX);
        make.height.equalTo(@20);
        make.width.equalTo(@120);
    }];
    
    frontButton=[UIButton buttonWithType:UIButtonTypeCustom];
    frontButton.frame=CGRectMake(0, 0, 60, 44);
    if ([currentMonth integerValue] ==1) {
       [frontButton setTitle:@"12月" forState:UIControlStateNormal];
    }else{
     [frontButton setTitle:[NSString stringWithFormat:@"%d月",[currentMonth intValue]-1] forState:UIControlStateNormal];
        
    }
   
    frontButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [frontButton setTitleColor:[CYTSI colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [frontButton setImage:[UIImage imageNamed:@"money_front"] forState:UIControlStateNormal];
    [frontButton addTarget:self action:@selector(frontButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [smallView addSubview:frontButton];
    
    afterButton=[UIButton buttonWithType:UIButtonTypeCustom];
    afterButton.frame=CGRectMake(DeviceWidth-60, 0, 60, 44);
    if ([currentMonth integerValue] == 12) {
        [afterButton setTitle:@"1月" forState:UIControlStateNormal];

    }else{
        [afterButton setTitle:[NSString stringWithFormat:@"%d月",[currentMonth intValue]+1] forState:UIControlStateNormal];

        
    }
    afterButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [afterButton setTitleColor:[CYTSI colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [afterButton setImage:[UIImage imageNamed:@"money_after"] forState:UIControlStateNormal];
    [afterButton addTarget:self action:@selector(afterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [smallView addSubview:afterButton];
    
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 43, DeviceWidth, 0.5)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [smallView addSubview:lineView];
    
    [self setFrontButtonLayout:frontButton.titleLabel.text];
    [self setAfterButtonLayout:afterButton.titleLabel.text];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoneyTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"moneycell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"MoneyTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row==9) {
        cell.lineView.hidden=YES;
    }
    
    RecordModel * record=recordArray[indexPath.row];
    cell.dateLable.text=record.ctime;
    if (![record.operate_intro isEqualToString:@"提现"]) {
        cell.typeLable.text=record.operate_intro;
    }else{
        [CYTSI setDefrientColorWith:[NSString stringWithFormat:@"%@%@",record.operate_intro,record.withdraw_state] someStr:record.withdraw_state theLable:cell.typeLable theColor:[UIColor redColor]];
    }
    cell.moneyLable.text=record.money;
    
    return cell;
}

//前一月按钮点击事件
-(void)frontButtonClicked
{
    currentPage = @"1";
    if ([currentMonth intValue]==1) {
        currentMonth=@"12";
        currentYear=[NSString stringWithFormat:@"%d",[currentYear intValue]-1];
    } else {
        currentMonth=[NSString stringWithFormat:@"%d",[currentMonth intValue]-1];
    }
    
    //更新时间
    [self updateDate];
    
}

//后一月按钮点击事件
-(void)afterButtonClicked
{
    currentPage = @"1";
    NSString * year=[NSString stringWithFormat:@"%ld",(long)[CYTSI receiveDateType:0]];
    NSString * month=[NSString stringWithFormat:@"%ld",(long)[CYTSI receiveDateType:1]];
    if ([currentYear isEqualToString:year] && [currentMonth isEqualToString:month]) {
        [CYTSI otherShowTostWithString:@"已到最新时间~"];
        return;
    }
    
    if ([currentMonth intValue]==12) {
        currentMonth=@"1";
        currentYear=[NSString stringWithFormat:@"%d",[currentYear intValue]+1];
    } else {
        currentMonth=[NSString stringWithFormat:@"%d",[currentMonth intValue]+1];
    }
    
    //更新时间
    [self updateDate];
    
}

//更新时间
-(void)updateDate
{
    dateLable.text=[NSString stringWithFormat:@"%@年%@月",currentYear,currentMonth];
    if ([currentMonth intValue] == 1) {
        
        [frontButton setTitle:@"12月" forState:UIControlStateNormal];
        
    } else {
        
        [frontButton setTitle:[NSString stringWithFormat:@"%d月",[currentMonth intValue]-1] forState:UIControlStateNormal];
        
    }
    if ([currentMonth intValue]==12) {
        
        [afterButton setTitle:@"1月" forState:UIControlStateNormal];
        
    }else{
        
        [afterButton setTitle:[NSString stringWithFormat:@"%d月",[currentMonth intValue]+1] forState:UIControlStateNormal];
        
    }
    [self setAfterButtonLayout:[NSString stringWithFormat:@"%d月",[currentMonth intValue]+1]];
    
    NSString * dateStr=[NSString stringWithFormat:@"%@-%02d-01",currentYear,[currentMonth intValue]];
    lastDateStr = dateStr;
    [self requestRecord:dateStr];
    
}

//设置前一月按钮偏移量
-(void)setFrontButtonLayout:(NSString *)str
{
    [frontButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
}

//设置后一月按钮偏移量
-(void)setAfterButtonLayout:(NSString *)str
{
    int width=[CYTSI planRectWidth:str font:16];
    [afterButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -width+25, 0, width-25)];
    [afterButton setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -30)];
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
