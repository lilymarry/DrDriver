//
//  LeftViewController.m
//  DrUser
//
//  Created by mac on 2017/6/17.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftViewTableViewCell.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#import "CYLableView.h"
#import "CYStarView.h"
#import "PersonalViewController.h"
#import "TripViewController.h"
#import "MoneyViewController.h"
#import "InvitationViewController.h"
#import "SuggestionViewController.h"
#import "AboutViewController.h"
#import "ShouYeModel.h"
#import "LoginViewController.h"
#import "OnlineTimeViewController.h"
#import "ChangeCarTypeViewController.h"
#import "ShopViewController.h"
#import "QueueUpViewController.h"
#import "ITTripViewController.h"
#import "NewTripViewController.h"


@interface LeftViewController () <UITableViewDelegate,UITableViewDataSource>

{
    UITableView * myTableView;
    NSArray * imageArray;
    NSArray * titleArray;
    
    CYLableView * leftView;
    CYLableView * rightView;
    CYStarView * starView;
    UILabel * nickNamelable;
    UIButton * headButon;
    
    ShouYeModel * shouYe;
    
}

@end

@implementation LeftViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *d_class = [[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"];
    if ([d_class isEqualToString:@"3"]||[d_class isEqualToString:@"6"]) {//扫码车进入
        imageArray=@[@"left_trip",@"person_qianbao",@"person_invalite",@"person_suggestion",@"商城",@"person_about"];
        titleArray=@[@"行程",@"钱包",@"邀请好友",@"意见反馈",@"易出行商城",@"关于"];
    }else{
        imageArray=@[@"left_trip",@"person_qianbao",@"onlineTime",@"person_invalite",@"person_suggestion",@"商城",@"站点",@"person_about"];
        titleArray=@[@"行程",@"钱包",@"在线时长",@"邀请好友",@"意见反馈",@"易出行商城",@"站点排队",@"关于"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftView) name:@"leftView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMessage:) name:@"change_message" object:nil];
    
    [self creatMainView];//创建主要视图
    
}
-(void)leftView{
    NSString *d_class = [[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"];
    if ([d_class isEqualToString:@"3"]||[d_class isEqualToString:@"6"]) {//扫码车进入
        imageArray=@[@"left_trip",@"person_qianbao",@"person_invalite",@"person_suggestion",@"商城",@"person_about"];
        titleArray=@[@"行程",@"钱包",@"邀请好友",@"意见反馈",@"易出行商城",@"关于"];
    }else{
        imageArray=@[@"left_trip",@"person_qianbao",@"onlineTime",@"person_invalite",@"person_suggestion",@"商城",@"站点",@"person_about"];
        titleArray=@[@"行程",@"钱包",@"在线时长",@"邀请好友",@"意见反馈",@"易出行商城",@"站点排队",@"关于"];
    }
    [myTableView reloadData];
}

//改变左滑菜单的个人信息
-(void)changeMessage:(NSNotification *)noti
{
    NSDictionary * dic=noti.userInfo;
    shouYe=dic[@"message"];
    [headButon sd_setImageWithURL:[NSURL URLWithString:shouYe.driver_head] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_header"]];
    nickNamelable.text=shouYe.driver_name;
    int height=[CYTSI planRectWidth:nickNamelable.text font:14];
    [nickNamelable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(height);
    }];
    [starView setViewWithNumber:shouYe.appraise_stars width:14 space:2 enable:NO];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"3"]) {
        leftView.bottomLable.text=[NSString stringWithFormat:@"%ld",(long)shouYe.cumulate_count];
        rightView.bottomLable.text=@"100%";
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]){
        leftView.bottomLable.text=[NSString stringWithFormat:@"%ld",(long)shouYe.cumulate_count];
        rightView.bottomLable.text=shouYe.complete_rate;
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"8"]){
        leftView.bottomLable.text=[NSString stringWithFormat:@"%ld",(long)shouYe.cumulate_count];
        rightView.bottomLable.text=shouYe.complete_rate;
    }else{
        leftView.bottomLable.text=shouYe.order_count;
        rightView.bottomLable.text=shouYe.complete_rate;
    }
    self.typeLB.font = [UIFont systemFontOfSize:9];
    NSLog(@"shouYe.driver_classshouYe.driver_class%ld",shouYe.driver_class);
    if (shouYe.driver_class == 1) {
        self.typeLB.text = @"快 车";
    }else if (shouYe.driver_class == 2){
        self.typeLB.text = @"出租车";
    }else if (shouYe.driver_class == 3){
        self.typeLB.text = @"扫码车";
    }else if (shouYe.driver_class == 4){
        self.typeLB.text = @"专 车";
    }else if (shouYe.driver_class == 5){
        self.typeLB.text = @"豪华车";
    }else if (shouYe.driver_class == 6){
        self.typeLB.text = @"包 车";
    }else if (shouYe.driver_class == 7){
        self.typeLB.font = [UIFont systemFontOfSize:7];
        self.typeLB.text = @"出租快车";
    }else if (shouYe.driver_class == 8){
        self.typeLB.font = [UIFont systemFontOfSize:5];
        self.typeLB.text = @"自由行";
    }
    
    [myTableView reloadData];
    
}

//创建主要视图
-(void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 100) style:UITableViewStylePlain];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.dataSource = self;
//    if (DeviceWidth<375) {
//        myTableView.scrollEnabled=YES;
//    }else{
//        myTableView.scrollEnabled=NO;
//    }
    [self.view addSubview:myTableView];
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 210)];
    
    leftView=[[CYLableView alloc]init];
    leftView.backgroundColor=[UIColor whiteColor];
    leftView.topLable.text=@"总订单数";
    leftView.bottomLable.text=@"0";
    [headerView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.centerX.equalTo(headerView.mas_centerX).with.offset(-45);
        make.bottom.equalTo(headerView.mas_bottom);
        make.width.equalTo(@80);
    }];
    
    NSLog(@"屏幕宽度：%f",DeviceWidth);
    rightView=[[CYLableView alloc]init];
    rightView.backgroundColor=[UIColor whiteColor];
    rightView.topLable.text=@"总成交率";
    rightView.bottomLable.text=@"0.00%";
    [headerView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.equalTo(leftView.mas_right).with.offset(10);
        make.bottom.equalTo(headerView.mas_bottom);
        make.width.equalTo(@80);
    }];
    
    starView=[[CYStarView alloc]init];
    [starView setViewWithNumber:0 width:14 space:2 enable:NO];
    [headerView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.height.equalTo(@14);
        make.width.equalTo(@78);
        make.top.equalTo(rightView.mas_top).with.offset(-27);
    }];
    
    nickNamelable=[[UILabel alloc]init];
    nickNamelable.text=@"";
    nickNamelable.textColor=[CYTSI colorWithHexString:@"#666666"];
    nickNamelable.font=[UIFont systemFontOfSize:14];
    nickNamelable.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:nickNamelable];
    [nickNamelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
        make.bottom.equalTo(starView.mas_top).with.offset(-5);
    }];
    
    UIView * leftLineView=[[UIView alloc]init];
    leftLineView.backgroundColor=[UIColor lightGrayColor];
    [headerView addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nickNamelable.mas_centerY);
        make.height.equalTo(@0.5);
        make.width.equalTo(@62);
        make.right.equalTo(nickNamelable.mas_left).with.offset(-3);
    }];
    
    UIView * rightLineView=[[UIView alloc]init];
    rightLineView.backgroundColor=[UIColor lightGrayColor];
    [headerView addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nickNamelable.mas_centerY);
        make.height.equalTo(@0.5);
        make.width.equalTo(@62);
        make.left.equalTo(nickNamelable.mas_right).with.offset(3);
    }];
    
    headButon=[UIButton buttonWithType:UIButtonTypeCustom];
    headButon.layer.cornerRadius=41;
    headButon.layer.masksToBounds=YES;
    [headButon addTarget:self action:@selector(headButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headButon];
    [headButon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(nickNamelable.mas_top).with.offset(-15);
        make.centerX.equalTo(headerView.mas_centerX);
        make.height.and.width.equalTo(@82);
    }];
    
    self.typeLB = [[UILabel alloc] init];
    [headerView addSubview:self.typeLB];
    self.typeLB.layer.cornerRadius = 15;
    self.typeLB.layer.masksToBounds=YES;
    self.typeLB.textColor = [UIColor whiteColor];
    self.typeLB.backgroundColor = [CYTSI colorWithHexString:@"#4480e0"];
    self.typeLB.textAlignment = NSTextAlignmentCenter;
    self.typeLB.text = @"--";
    self.typeLB.font = [UIFont systemFontOfSize:9];
    [self.typeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headButon.mas_right);
        make.bottom.equalTo(headButon.mas_bottom);
        make.width.and.height.mas_offset(30);
    }];
    
    [myTableView setTableHeaderView:headerView];
    
    UIButton * exitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton setImage:[UIImage imageNamed:@"left_exit"] forState:UIControlStateNormal];
    [exitButton setTitle:@"退出" forState:UIControlStateNormal];
    [exitButton setTitleColor:[CYTSI colorWithHexString:@"#4a4c5b"] forState:UIControlStateNormal];
    //    [self setButtonSpace:exitButton buttonTitle:@"退出"];
    exitButton.tag=9;
    exitButton.titleLabel.font=[UIFont systemFontOfSize:10];
    [exitButton addTarget:self action:@selector(exitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-40);
        make.height.width.equalTo(@50);
    }];
    
    [self setButtonSpace:exitButton buttonTitle:@"退出"];
    
//    UIButton * changeButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    [changeButton setImage:[UIImage imageNamed:@"切换角色"] forState:UIControlStateNormal];
//    [changeButton setTitle:@"切换运营类型" forState:UIControlStateNormal];
//    [changeButton setTitleColor:[CYTSI colorWithHexString:@"#4a4c5b"] forState:UIControlStateNormal];
//    changeButton.tag=10;
//    changeButton.titleLabel.font=[UIFont systemFontOfSize:10];
//    [changeButton addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:changeButton];
//    [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset((WIDTH - 100) - 60);
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(-40);
//        make.height.width.equalTo(@50);
//    }];
//    
//    [self setChanegButtonSpace:changeButton buttonTitle:@"切换运营类型"];
    
}

//头像按钮点击事件
-(void)headButtonClicked
{
    AppDelegate * appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController * nav=appDelegate.shouyeNav;
    [appDelegate.leftSlider closeLeftView];//关闭左侧视图
    PersonalViewController * vc=[[PersonalViewController alloc]init];
    [nav pushViewController:vc animated:YES];
}

//退出登录按钮点击事件
-(void)exitButtonClicked
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Dname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"driver_class"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stop_listen" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
    
    AppDelegate * appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController * nav=appDelegate.shouyeNav;
    [appDelegate.leftSlider closeLeftView];//关闭左侧视图
    
    
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
        CYLog(@"取消推送注册:%@",iAlias);
        
    }];
    
    BOOL isHave=NO;
    NSArray * vcArray=self.navigationController.viewControllers;
    for (LoginViewController * vc in vcArray) {
        
        if ([vc isKindOfClass:[LoginViewController class]]) {
            
            isHave=YES;
            [nav popToViewController:vc animated:YES];
            
        }
        
    }
    
    if (isHave==NO) {
        
        LoginViewController * vc=[[LoginViewController alloc]init];
        vc.isMainJump=YES;
        [nav pushViewController:vc animated:YES];
        
    }
    
}
#pragma mark --- 切换运营类型
-(void)changeAction{
    AppDelegate * appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController * nav=appDelegate.shouyeNav;
    [appDelegate.leftSlider closeLeftView];//关闭左侧视图
    ChangeCarTypeViewController * vc=[[ChangeCarTypeViewController alloc]init];
    [nav pushViewController:vc animated:YES];
}
#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *d_class = [[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"];
    if ([d_class isEqualToString:@"3"] ||[d_class isEqualToString:@"6"]) {//扫码车进入
        return 6;
    }else{
        return 8;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        return 44;
    }else{
        return 54;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftViewTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"leftviewcell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"LeftViewTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSLog(@"indexPath.row%ld   ",indexPath.row);
    [cell.theButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:UIControlStateNormal];
    cell.myLable.text=titleArray[indexPath.row];
    
    if (indexPath.row==1) {
        cell.otherLable.hidden=NO;
        cell.otherLable.text=[NSString stringWithFormat:@"¥%@",shouYe.driver_balance];
        int height=[CYTSI planRectWidth:cell.otherLable.text font:14];
        cell.moneyWidth.constant=height;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController * nav=appDelegate.shouyeNav;
    [appDelegate.leftSlider closeLeftView];//关闭左侧视图
    NSString *d_class = [[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"];
    if ([d_class isEqualToString:@"3"] ||[d_class isEqualToString:@"6"]) {//扫码车进入
        switch (indexPath.row) {
            case 0://行程
            {
                //                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"8"]){
                //                    ITTripViewController *vc = [[ITTripViewController alloc] init];
                //                    [nav pushViewController:vc animated:YES];
                //                }else{
                TripViewController * vc=[[TripViewController alloc]init];
                [nav pushViewController:vc animated:YES];
                //                }
            }
                break;
            case 1://钱包
            {
                MoneyViewController * vc=[[MoneyViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            }
                break;
            case 2://邀请
            {
                InvitationViewController * vc=[[InvitationViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            }
                break;
            case 3://意见反馈
            {
                SuggestionViewController * vc=[[SuggestionViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            }
                break;
            case 4://商城
            {
                ShopViewController * vc=[[ShopViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            }
                break;
            case 5://关于
            {
                AboutViewController * vc=[[AboutViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0://行程
            {
                NewTripViewController * vc=[[NewTripViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            }
                break;
            case 1://钱包
            {
                MoneyViewController * vc=[[MoneyViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            }
                break;
            case 2://在线时长
            {
                OnlineTimeViewController * vc=[[OnlineTimeViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            }
                break;
            case 3://邀请
            {
                InvitationViewController * vc=[[InvitationViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            }
                break;
            case 4://意见反馈
            {
                SuggestionViewController * vc=[[SuggestionViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            }
                break;
            case 5://商城
            {
                ShopViewController * vc=[[ShopViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            }
                break;
            case 6://站点排队
            {
                QueueUpViewController * vc=[[QueueUpViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            }
                break;
            case 7://关于
            {
                AboutViewController * vc=[[AboutViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

//设置button的文字图片间距
-(void)setButtonSpace:(UIButton *)button buttonTitle:(NSString *)title
{
    CGFloat buttonWidth =50;//按钮的宽度
    CGFloat textWidth = [CYTSI planRectWidth:title font:10];//按钮上的文字宽度
    CGFloat imageTopGap = 20;//图片距上部距离
    CGFloat textTopGap = 6;//文字距离图片的距离
    
    //CGFloat buttonImageWidth=button.imageView.frame.size.width;
    //if (buttonImageWidth>50) {
    CGFloat buttonImageWidth=buttonImageWidth=45;
    //}
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake((buttonImageWidth + imageTopGap) + textTopGap,(buttonWidth - textWidth)/2 - buttonImageWidth-7,0,0 )];
    [button setImageEdgeInsets:UIEdgeInsetsMake(imageTopGap,(buttonWidth-buttonImageWidth)/2,0, 0)];
    
    //[button setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,0 )];
}
//设置button的文字图片间距
-(void)setChanegButtonSpace:(UIButton *)button buttonTitle:(NSString *)title
{
    CGFloat buttonWidth =50;//按钮的宽度
    CGFloat textWidth = [CYTSI planRectWidth:title font:10];//按钮上的文字宽度
    CGFloat imageTopGap = 20;//图片距上部距离
    CGFloat textTopGap = 6;//文字距离图片的距离
    
    //CGFloat buttonImageWidth=button.imageView.frame.size.width;
    //if (buttonImageWidth>50) {
    CGFloat buttonImageWidth=buttonImageWidth=45;
    //}
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake((buttonImageWidth + imageTopGap) + textTopGap,(buttonWidth - textWidth)/2 - buttonImageWidth + 13,0,0 )];
    [button setImageEdgeInsets:UIEdgeInsetsMake(imageTopGap,(buttonWidth-buttonImageWidth)/2,0, 0)];
    
    //[button setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,0 )];
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
