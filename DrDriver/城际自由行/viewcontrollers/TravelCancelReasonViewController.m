//
//  TravelCancelReasonViewController.m
//  DrDriver
//
//  Created by 王彦森 on 2019/1/31.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "TravelCancelReasonViewController.h"
#import "CancelTripTableViewCell.h"
#import "ChangeModel.h"

@interface TravelCancelReasonViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

{
    UITableView * myTableView;
    UITextView * myTextView;
    NSArray * seasonArray;//原因数组
    NSString * season;//改派原因
}

@end

@implementation TravelCancelReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"取消订单";
    self.view.backgroundColor=TABLEVIEW_BACKCOLOR;
    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    [self creatHttp];//请求界面数据
    
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


//请求界面数据
-(void)creatHttp
{
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_CANCEL_REASON params:@{} tost:NO special:0 success:^(id responseObject) {
        
        seasonArray=[ChangeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [myTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

//创建主要视图
-(void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 260)];
    footerView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 137)];
    bgView.backgroundColor=[UIColor whiteColor];
    [footerView addSubview:bgView];
    
    myTextView=[[UITextView alloc]initWithFrame:CGRectMake(19, 0, DeviceWidth-38, 137)];
    myTextView.delegate=self;
    myTextView.font=[UIFont systemFontOfSize:14];
    myTextView.textColor=[CYTSI colorWithHexString:@"#999999"];
    myTextView.text=@"请输入...";
    [bgView addSubview:myTextView];
    
    UIButton * submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    submitButton.frame=CGRectMake(15, 205, DeviceWidth-30, 44);
    submitButton.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
    submitButton.titleLabel.font=[UIFont systemFontOfSize:16];
    submitButton.layer.cornerRadius=5;
    submitButton.layer.masksToBounds=YES;
    [submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitButton];
    
    [myTableView setTableFooterView:footerView];
    
}

//提交按钮点击事件
-(void)submitButtonClicked
{
    [myTextView resignFirstResponder];
    
    if (season==nil || [season isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请输入取消原因"];
        return;
    }
    
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_UPDATE_ORDER params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"order_id":self.orderID,@"state":@"8",@"cancel_reason":season} tost:YES special:0 success:^(id responseObject) {
        if ([responseObject[@"message"] isEqualToString:@"操作成功"]) {
            self.cancelBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([myTextView.text isEqualToString:@"请输入..."]) {
        myTextView.text=@"";
        season=@"";
        //        [myTableView reloadData];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [myTextView resignFirstResponder];
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([myTextView.text isEqualToString:@""]) {
        myTextView.text=@"请输入...";
    }else{
        season=myTextView.text;
    }
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return seasonArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 36)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, 150, 16)];
    lable.textColor=[CYTSI colorWithHexString:@"#999999"];
    lable.font=[UIFont systemFontOfSize:11];
    lable.text=@"选择取消原因";
    [bgView addSubview:lable];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 36;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 36)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, 150, 16)];
    lable.textColor=[CYTSI colorWithHexString:@"#999999"];
    lable.font=[UIFont systemFontOfSize:11];
    lable.text=@"其他原因";
    [bgView addSubview:lable];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CancelTripTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"canceltripcell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"CancelTripTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row==seasonArray.count-1) {
        cell.lineView.hidden=YES;
    }
    
    ChangeModel * change=seasonArray[indexPath.row];
    
    cell.seasonLable.text=change.title;
    
    if ([change.title isEqualToString:season]) {
        cell.selectButton.selected=YES;
    }
    
    cell.selectButton.tag=10+indexPath.row;
    [cell.selectButton addTarget:self action:@selector(selectedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeModel * change=seasonArray[indexPath.row];
    season=change.title;
    //    [myTableView reloadData];
}

-(void)selectedButtonClicked:(UIButton *)btn
{
    ChangeModel * change=seasonArray[btn.tag-10];
    season=change.title;
    [myTableView reloadData];
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
