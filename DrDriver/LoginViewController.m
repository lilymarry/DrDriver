//
//  LoginViewController.m
//  DrUser
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisteViewController.h"
#import "TrueRegisterViewController.h"
#import "DriverModel.h"
#import "ViewController.h"
#import "Add_ONE_ViewController.h"
#import "JPUSHService.h"
#import "ScanCarViewController.h"
#import "UpdateAlertView.h"
#import "CharteredViewController.h"//包车
#import "IndependentTravelView.h"
#import "RegisterCityAndCarTypeViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.accountTextFiled.text = @"";
    self.passwordTextFiled.text = @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"登录";
    
    [self setUpNav];//创建导航栏
    if (DeviceHeight>737) {
        self.topLine.constant = 79+44;
    }
    self.accountTextFiled.delegate=self;
    self.accountTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    self.passwordTextFiled.delegate=self;
    self.passwordTextFiled.returnKeyType=UIReturnKeyDone;
    
    self.loginButton.layer.cornerRadius=3;
    self.loginButton.layer.masksToBounds=YES;
    
    self.bgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.bgView.layer.borderWidth=0.5;

    //检查软件是否需要更新
    [self checkForUpdate];
  
}
#pragma mark ---- 检查软件是否需要更新
-(void)checkForUpdate{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [AFRequestManager postRequestWithUrl:DRIVER_VERSION_DRIVER_CLIENT_UPDATE_IOS params:@{@"version":[infoDictionary objectForKey:@"CFBundleShortVersionString"]} tost:YES special:0 success:^(id responseObject) {
//        NSLog(@"CFBundleShortVersionString%@",responseObject);
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
            if ([responseObject[@"data"][@"is_force"] isEqualToString:@"1"]) {
            if (![responseObject[@"data"][@"version"]  isEqualToString:[infoDictionary objectForKey:@"CFBundleShortVersionString"]]) {
                //关闭广告弹窗
#pragma mark ------ 创建更新alertView
                UpdateAlertView *updateAlertView = [[UpdateAlertView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
                updateAlertView.descriptionLabel.text = responseObject[@"data"][@"description"];
                updateAlertView.versionNumberLabel.text = [NSString stringWithFormat:@"V %@",responseObject[@"data"][@"version"]];
                [[UIApplication sharedApplication].keyWindow addSubview:updateAlertView];
            }
          }
        }
    } failure:^(NSError *error) {
        
    }];
}
//创建导航栏
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.accountTextFiled resignFirstResponder];
    [self.passwordTextFiled resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.accountTextFiled resignFirstResponder];
    [self.passwordTextFiled resignFirstResponder];
    
    return YES;
}

//清除账户按钮点击事件
- (IBAction)closeButtonClicked:(id)sender
{
    self.accountTextFiled.text=@"";
}



//忘记密码按钮点击事件
- (IBAction)forgetPasswordButtonClicked:(id)sender
{
    RegisteViewController * vc=[[RegisteViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//登录按钮点击事件
- (IBAction)loginButtonClicked:(id)sender
{
    [self.accountTextFiled resignFirstResponder];
    [self.passwordTextFiled resignFirstResponder];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isError"];
    
    BOOL isRight=[CYTSI checkTelNumber:self.accountTextFiled.text];
    if (isRight==NO) {
        [CYTSI otherShowTostWithString:@"请输入正确的手机号"];
        return;
    }
    
    if ([self.passwordTextFiled.text isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请输入密码"];
        return;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
//    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
//    NSLog(@"手机型号: %@",phoneModel );
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSLog(@"当前应用软件版本:%@",appCurVersion);
    NSString *iphoneTypeStr = [CYTSI iphoneType];
//    NSLog(@"当前应用版本号码：%@",iphoneTypeStr);
    
    [AFRequestManager postRequestWithUrl:DRIVER_LOGIN params:@{@"driver_account":self.accountTextFiled.text,@"driver_password":self.passwordTextFiled.text,@"system_type":@"2",@"brand":iphoneTypeStr,@"model":iphoneTypeStr,@"system_version":phoneVersion,@"soft_version":appCurVersion} tost:YES special:0 success:^(id responseObject) {
        
        DriverModel * driver=[DriverModel mj_objectWithKeyValues:responseObject[@"data"]];
        if ([responseObject[@"data"][@"audit_state"] isEqualToString:@"3"] || [responseObject[@"data"][@"audit_state"] isEqualToString:@"4"]) {
            if ([responseObject[@"data"][@"audit_state"] isEqualToString:@"3"] ) {
                [CYTSI otherShowTostWithString:@"审核未通过，请补充信息"];

            }else{
                [CYTSI otherShowTostWithString:@"请补全您的个人信息"];                
            }
            RegisterCityAndCarTypeViewController *vc = [[RegisterCityAndCarTypeViewController alloc] init];
            vc.driver = driver;
            vc.type = @"login";
            vc.ModelDic = responseObject[@"data"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([responseObject[@"data"][@"audit_state"] isEqualToString:@"5"]){
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"data"][@"audit_fail_reason"]
                                                             delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
             [alert show];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:driver.driver_id forKey:@"userid"];
            [[NSUserDefaults standardUserDefaults] setObject:driver.token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:driver.driver_class forKey:@"driver_class"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"order_id"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"orderState"];
            [[NSUserDefaults standardUserDefaults] setObject:driver.driver_name forKey:@"Dname"];
            [CYTSI otherShowTostWithString:@"登录成功"];
        
        [JPUSHService setTags:nil alias:driver.driver_id fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            
            CYLog(@"推送注册:%@",iAlias);
            
        }];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"leftView" object:self userInfo:nil];

            NSString *d_class = [[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"];
            if ([d_class isEqualToString:@"3"]) {//扫码车进入
                ScanCarViewController * vc=[[ScanCarViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([d_class isEqualToString:@"6"]){//包车进入
                
                CharteredViewController * vc=[[CharteredViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                   
            }else{//快车/出租车 进入
                ViewController * vc=[[ViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
