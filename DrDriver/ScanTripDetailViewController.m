//
//  ScanTripDetailViewController.m
//  DrUser
//
//  Created by fy on 2018/4/26.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "ScanTripDetailViewController.h"

@interface ScanTripDetailViewController ()<UITextViewDelegate>
{
    UIView * blackView;//评价背景黑视图
    UIView * pingJiaView;//评价视图
    UIButton * pingButton;//评价按钮
    NSString * pingStar;//评价星级
    
    //弹出的评价视图
    UIImageView * pingHeadImageView;
    UILabel * pingDriverLable;
    UILabel * pingCompanyLable;
    UITextView * myTextView;//评价输入框
    UILabel * placeHolderLable;
    
    OrderDetailModel * orderDetail;
}

@end

@implementation ScanTripDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"已完成";
    [self setUpNav];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatHttp];
}
-(void)creatMainView{
    
    self.backGroundImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.backGroundImageView];
    self.backGroundImageView.image = [UIImage imageNamed:@"scanPayDetail"];
    [self.backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(77);
        make.left.equalTo(self.view).offset(13);
        make.bottom.and.right.equalTo(self.view).offset(-13);
    }];
    
    self.orderIDLB = [[UILabel alloc] init];
    self.orderIDLB.text = orderDetail.order_sn;
    self.orderIDLB.textColor = [UIColor colorWithRed:31.0/255.0 green:105.0/255.0 blue:192.0/255.0 alpha:1.0];
    self.orderIDLB.font = [UIFont systemFontOfSize:20];
    self.orderIDLB.textAlignment = NSTextAlignmentCenter;
    self.orderIDLB.font = [UIFont fontWithName:@"Helvetica-Bold"  size:(25.0)];
    [self.view addSubview:self.orderIDLB];
    [self.orderIDLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backGroundImageView);
        make.top.equalTo(self.backGroundImageView).offset(50);
        make.left.equalTo(self.backGroundImageView).offset(20);
        make.right.equalTo(self.backGroundImageView).offset(-20);
    }];
    
    self.timeLB = [[UILabel alloc] init];
    self.timeLB.text = orderDetail.ctime;
    self.timeLB.textColor = [UIColor colorWithRed:31.0/255.0 green:105.0/255.0 blue:192.0/255.0 alpha:1.0];
    self.timeLB.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:self.timeLB];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backGroundImageView).offset(30);
        make.top.equalTo(self.orderIDLB.mas_bottom).offset(10);
    }];
    
    self.headImageView = [[UIImageView alloc] init];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:orderDetail.m_head] placeholderImage:[UIImage imageNamed:@"default_header"]];
    self.headImageView.layer.cornerRadius = 43;
    self.headImageView.layer.masksToBounds = YES; 
    [self.view addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_offset(86);
        make.centerX.equalTo(self.view);
        make.top.mas_offset((DeviceHeight - 25)*2/3 - 30);
    }];
    
    self.expensesLB = [[UILabel alloc] init];
    self.expensesLB.textColor = [UIColor colorWithRed:31.0/255.0 green:105.0/255.0 blue:192.0/255.0 alpha:1.0];
    self.expensesLB.text =[NSString stringWithFormat:@"¥%@",orderDetail.journey_fee];
    self.expensesLB.font = [UIFont systemFontOfSize:60];
    [CYTSI setStringWith:self.expensesLB.text someStr:@"¥" lable:self.expensesLB theFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:self.expensesLB];
    [self.expensesLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backGroundImageView);
        make.top.mas_offset(DeviceHeight/2 - 50);
    }];
    
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.text = orderDetail.order_class_name;
    self.titleLB.textColor = [UIColor colorWithRed:31.0/255.0 green:105.0/255.0 blue:192.0/255.0 alpha:1.0];
    self.titleLB.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.expensesLB.mas_top).offset(-30);
    }];
    
    self.userNameLB = [[UILabel alloc] init];
    self.userNameLB.text = orderDetail.passenger_name;
    self.userNameLB.textColor = [UIColor whiteColor];
    [self.view addSubview:self.userNameLB];
    [self.userNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backGroundImageView);
        make.top.equalTo(self.headImageView.mas_bottom).offset(15);
    }];
    
    self.pingJiaBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.pingJiaBtn setTitle:@"暂未评价" forState:(UIControlStateNormal)];
    [self.view addSubview:self.pingJiaBtn];
    [self.pingJiaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backGroundImageView);
        make.top.equalTo(self.userNameLB.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    self.starView =  [[CYStarView alloc] initWithFrame:CGRectMake(DeviceWidth/2 - 50, 50, 100, 50)];
    self.starView.hidden = YES;
    self.starView.userInteractionEnabled = NO;
    [self.view addSubview:self.starView];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backGroundImageView);
        make.top.equalTo(self.userNameLB.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
    }];
    
    self.modeLB = [[UILabel alloc] init];
    if ([orderDetail.pay_type isEqualToString:@"1"]) {
        self.modeLB.text = @"支付方式：余额支付";
    }else if ([orderDetail.pay_type isEqualToString:@"2"]){
        self.modeLB.text = @"支付方式：支付宝支付";
    }else if ([orderDetail.pay_type isEqualToString:@"7"]){
        self.modeLB.text = @"支付方式：小程序支付";
    }else{
        self.modeLB.text = @"支付方式：微信支付";
    }
    self.modeLB.textColor = [UIColor whiteColor];
    self.modeLB.font = [UIFont systemFontOfSize:19];
    [self.view addSubview:self.modeLB];
    [self.modeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backGroundImageView);
        make.bottom.equalTo(self.backGroundImageView.mas_bottom).offset(-30);
    }];
    
}
//请求订单详情数据
-(void)creatHttp
{
    [AFRequestManager postRequestWithUrl:DRIVER_JOURNEY_ORDER_DETAIL_INFO params:@{@"order_id":self.order_id,@"driver_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {

        NSLog(@"responseObject%@",responseObject[@"data"]);
        [OrderDetailModel mj_setupObjectClassInArray:^NSDictionary *{

            return @{@"locus_point":@"DriverModel"};

        }];

        orderDetail=[OrderDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self creatMainView];
        if (orderDetail.passenger_appraise==1) {//已评价
            self.pingJiaBtn.hidden = YES;
            self.starView.hidden = NO;
            [_starView setViewWithNumber:orderDetail.passenger_star width:18 space:2 enable:NO];
            
        } else {//未评价
            
            self.pingJiaBtn.hidden=NO;
            
            if (orderDetail.journey_state!=5) {
                self.pingJiaBtn.hidden=YES;
            }
            
        }

    } failure:^(NSError *error) {

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
//导航栏返回按钮点击事件
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
