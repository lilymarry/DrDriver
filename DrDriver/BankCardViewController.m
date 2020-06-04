//
//  BankCardViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "BankCardViewController.h"
#import "BankCardTableViewCell.h"
#import "CardTiXianViewController.h"
#import "BankCardModel.h"

@interface BankCardViewController () <UITableViewDataSource,UITableViewDelegate>

{
    UITableView * myTableView;
    NSMutableArray * cardArray;
    NSString * currentPage;//当前分页数
}

@end

@implementation BankCardViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshDown];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"银行卡";
    self.view.backgroundColor=TABLEVIEW_BACKCOLOR;
    cardArray=[[NSMutableArray alloc]init];
    
    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    
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
    [AFRequestManager postRequestWithUrl:DRIVER_DRIVERBANK_LIST params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"p":currentPage} tost:YES special:0 success:^(id responseObject) {
        
        NSArray * array=[BankCardModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        if ([currentPage intValue]==1) {
            [cardArray removeAllObjects];
        }
        [cardArray addObjectsFromArray:array];
        [myTableView reloadData];
        
        [myTableView.mj_header endRefreshing];
        [myTableView.mj_footer endRefreshing];
        
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
    
    UIButton *  myButton=[UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame=CGRectMake(0, 0, 40, 20);
    [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myButton setTitle:@"添加" forState:UIControlStateNormal];
    myButton.titleLabel.font=[UIFont systemFontOfSize:13];
    
    [myButton addTarget:self action:@selector(myButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:myButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

//导航栏返回按钮点击事件
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加按钮点击事件
-(void)myButtonClicked
{
    CardTiXianViewController * vc=[[CardTiXianViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//创建主要视图
-(void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, DeviceWidth-20, DeviceHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:myTableView];
    
    //添加下拉刷新及上拉加载
    myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDown)];
//    myTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
    
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return cardArray.count;
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
    return 64;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"bankcardcell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"BankCardTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    BankCardModel * card=cardArray[indexPath.section];
    [cell.cardImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HTTP_IMG_URL,card.bank_logo]]];
    cell.nameLable.text=card.bank_name;
    cell.numberLable.text=card.account;
    
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardModel * card=cardArray[indexPath.section];
    
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        
        [AFRequestManager postRequestWithUrl:DRIVER_DRIVERBANK_DELETE_DRIVER_BANK params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"bank_id":card.bank_id,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
            
            [CYTSI otherShowTostWithString:@"删除成功"];
            [cardArray removeObjectAtIndex:indexPath.section];
            [myTableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    deleteRowAction.backgroundColor=[CYTSI colorWithHexString:@"#e64343"];
    
    return @[deleteRowAction];
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
