//
//  SLMoreViewController.m
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/31.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "SLMoreViewController.h"
#import "ChildMoreModel.h"
#import "SLMoreInfoTableViewCell.h"
@interface SLMoreViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView * myTableView;
}

@property(nonatomic,strong)ChildMoreModel *childMore;
@end

@implementation SLMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
    [self setUpNav];
    [self creatMainView];
    
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;
    [AFRequestManager postRequestWithUrl:DRIVER_SCHOOLBUS_ORDER_DETIAL params:@{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"order_id": self.order_id} tost:YES special:0 success:^(id responseObject) {
        weakSelf.childMore = [ChildMoreModel mj_objectWithKeyValues:responseObject[@"data"]];
        NSLog(@"responseObject[]  ============ %@",responseObject[@"data"]);
        [myTableView reloadData];
    
        } failure:^(NSError *error) {
           //        CYLog(@"error ===== %@", error)
    }];
}

-(void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:myTableView];
}

#pragma mark - 表的代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 650;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLMoreInfoTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"SLMoreInfoTableViewCell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"SLMoreInfoTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.childmore = self.childMore;
    return cell;
}
@end
