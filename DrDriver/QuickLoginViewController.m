//
//  QuickLoginViewController.m
//  DrUser
//
//  Created by mac on 2017/7/10.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "QuickLoginViewController.h"
#import "LoginViewController.h"
#import "WebViewViewController.h"
#import "DriverModel.h"
#import "RegisteViewController.h"
#import "TrueRegisterViewController.h"
#import "ViewController.h"
#import "Add_ONE_ViewController.h"
#import "JPUSHService.h"
#import "ScanCarViewController.h"
#import "UpdateAlertView.h"
#import "CharteredViewController.h"//包车
#import "IndependentTravelView.h"
#import "RegisterCityAndCarTypeViewController.h"

@interface QuickLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton1;

@end

@implementation QuickLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"手机号登录";
    [self setUpNav];//创建导航栏
    if (DeviceHeight>737) {
        self.topLine.constant = 79+44;
    }
    _codeButton.backgroundColor=[CYTSI colorWithHexString:@"#2488ef"];
    _codeButton.layer.cornerRadius=3;
    _codeButton.layer.masksToBounds=YES;
    _codeButton.layer.borderColor=RGBA(129, 185, 251, 1).CGColor;
    _codeButton.layer.borderWidth=2;
    
    self.phoneTextFiled.delegate=self;
    self.phoneTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    self.codeTextFiled.delegate=self;
    self.codeTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    
    self.loginButton.layer.cornerRadius=3;
    self.loginButton.layer.masksToBounds=YES;
    
    self.bgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.bgView.layer.borderWidth=0.5;
    
    [_chooseButton setImage:[UIImage imageNamed:@"cancel_trip_normal"] forState:UIControlStateNormal];
    [_chooseButton setImage:[UIImage imageNamed:@"cancel_trip_pre"] forState:UIControlStateSelected];
    
    _chooseButton.selected=YES;
    
    self.loginButton1.layer.cornerRadius=3;
    self.loginButton1.layer.masksToBounds=YES;
    self.loginButton1.layer.borderColor=[CYTSI colorWithHexString:@"#2488ef"].CGColor;
    self.loginButton1.layer.borderWidth=0.5;
    //检查软件是否需要更新
    [self checkForUpdate];
}

//创建导航栏
-(void)setUpNav
{
    UIButton * navBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame=CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
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
    [self.phoneTextFiled resignFirstResponder];
    [self.codeTextFiled resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneTextFiled resignFirstResponder];
    [self.codeTextFiled resignFirstResponder];
    
    return YES;
}

//清空按钮点击事件
- (IBAction)closeButtonClicked:(UIButton *)sender
{
    _phoneTextFiled.text=@"";
}

//注册按钮点击事件
- (IBAction)resgisterButtonClicked:(id)sender
{
    TrueRegisterViewController * vc=[[TrueRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//快速登录按钮点击事件
- (IBAction)quickLoginButtonClicked:(UIButton *)sender
{
     LoginViewController* vc=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//验证码按钮点击事件
- (IBAction)codeButtonClicked:(UIButton *)sender
{
    [_phoneTextFiled resignFirstResponder];
    
    BOOL isRight=[CYTSI checkTelNumber:_phoneTextFiled.text];
    if (isRight==NO) {
        [CYTSI otherShowTostWithString:@"请输入正确的手机号"];
        return;
    }
    
    NSString * ipAddress=[CYTSI deviceWANIPAdress];
//    NSLog(@"dict === %@",@{@"phone":_phoneTextFiled.text,@"network_ip":ipAddress,@"type":@"driver_login"});
    [AFRequestManager postRequestWithUrl:DRIVER_SEND_VERIFY params:@{@"phone":_phoneTextFiled.text,@"network_ip":ipAddress,@"type":@"driver_login"} tost:YES special:0 success:^(id responseObject) {
        [CYTSI otherShowTostWithString:@"验证码已发送"];
        [self startTime];

    } failure:^(NSError *error) {

    }];
}

//登录按钮点击事件
- (IBAction)loginButtonClicked:(UIButton *)sender
{
    if (_chooseButton.selected==NO) {
        
        [CYTSI otherShowTostWithString:@"请阅读并同意叫车服务条款"];
        return;
        
    }
    
    BOOL isRight=[CYTSI checkTelNumber:_phoneTextFiled.text];
    if (isRight==NO) {
        [CYTSI otherShowTostWithString:@"请输入正确的手机号"];
        return;
    }
    
    if ([_codeTextFiled.text isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请输入验证码"];
        return;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    NSString *iphoneTypeStr = [CYTSI iphoneType];
    NSLog(@"当前应用版本号码：%@",iphoneTypeStr);
    
     [AFRequestManager postRequestWithUrl:DRIVER_LOGIN_QUICK_LOGIN params:@{@"driver_account":self.phoneTextFiled.text,@"verify_code":self.codeTextFiled.text,@"system_type":@"2",@"brand":iphoneTypeStr,@"model":iphoneTypeStr,@"system_version":phoneVersion,@"soft_version":appCurVersion} tost:YES special:0 success:^(id responseObject) {
            
            DriverModel * driver=[DriverModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            
    //    NSLog(@" DRIVER_LOGIN ========%@",responseObject);
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
                    if (_isMainJump) {//从首页进来的
                        NSArray * vcArray=self.navigationController.viewControllers;
                        BOOL isbool = [vcArray containsObject: vc];
    //                    NSLog(@"isbool%d",isbool);
                        if (isbool) {
                            for (ScanCarViewController * vc in vcArray) {
                                
                                if ([vc isKindOfClass:[ScanCarViewController class]]) {
                                    
                                    vc.isNeedReload=YES;
                                    
                                    [self.navigationController popToViewController:vc animated:YES];
                                }
                                
                            }
                        }else{
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                    } else {//从appdelegate进来的
                        
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                        
                    
                }else if ([d_class isEqualToString:@"6"]){//包车进入
                    CharteredViewController * vc=[[CharteredViewController alloc]init];
                    if (_isMainJump) {//从首页进来的
                        NSArray * vcArray=self.navigationController.viewControllers;
                        BOOL isbool = [vcArray containsObject: vc];
    //                    NSLog(@"isbool%d",isbool);
                        if (isbool) {
                            for (CharteredViewController * vc in vcArray) {
                                
                                if ([vc isKindOfClass:[CharteredViewController class]]) {
                                    
                                    vc.isNeedReload=YES;
                                    
                                    [self.navigationController popToViewController:vc animated:YES];
                                }
                                
                            }
                        }else{
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                    } else {//从appdelegate进来的
                        
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    
                }else{//快车/出租车 进入
                    ViewController * vc=[[ViewController alloc]init];
                    if (_isMainJump) {//从首页进来的
                        NSArray * vcArray=self.navigationController.viewControllers;
                        BOOL isbool = [vcArray containsObject: vc];
    //                    NSLog(@"isbool%d",isbool);
                        if (isbool) {
                            for (ViewController * vc in vcArray) {
                                
                                if ([vc isKindOfClass:[ViewController class]]) {
                                    
                                    vc.isNeedReload=YES;
                                    
                                    [self.navigationController popToViewController:vc animated:YES];
                                }
                                
                            }
                        }else{
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                    } else {//从appdelegate进来的
                        
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    
                }
                
            }
            
        } failure:^(NSError *error) {
            
        }];
    
}

//选择按钮点击事件
- (IBAction)chooseButtonClicked:(UIButton *)sender
{
    _chooseButton.selected=!_chooseButton.selected;
}

//协议按钮点击事件
- (IBAction)xieYiButtonClicked:(UIButton *)sender
{
    WebViewViewController * vc=[[WebViewViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)startTime{
    
    __block int timeout= 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [_codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                _codeButton.backgroundColor=[CYTSI colorWithHexString:@"#2488ef"];
                _codeButton.layer.borderColor=RGBA(129, 185, 251, 1).CGColor;
                
                _codeButton.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [UIView beginAnimations:nil context:nil];
                
                [UIView setAnimationDuration:1];
                
                [_codeButton setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                _codeButton.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
                _codeButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
                
                [UIView commitAnimations];
                
                _codeButton.userInteractionEnabled = NO;
                
            });
            
            timeout--;

        }
        
    });
    
    dispatch_resume(_timer);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
