//
//  TrueRegisterViewController.m
//  DrUser
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "TrueRegisterViewController.h"
#import "CheckCodeViewController.h"
//#import "PerfectOneViewController.h"

#import "DriverModel.h"
#import "WebViewViewController.h"
#import "Register_ONE_ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "RegisterCityAndCarTypeViewController.h"

@interface TrueRegisterViewController () <UITextFieldDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) NSString * city;//定位城市

@end

@implementation TrueRegisterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_inviteCode!=nil) {
        _invaliteTextFiled.text=_inviteCode;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"注册";
    [self setUpNav];//创建导航栏
//    [self startLocation];//开始定位
    if (DeviceHeight>737) {
        self.topLine.constant = 79+44;
    }
    _codeButton.backgroundColor=[CYTSI colorWithHexString:@"#2488ef"];
    _codeButton.layer.cornerRadius=3;
    _codeButton.layer.masksToBounds=YES;
    _codeButton.layer.borderColor=RGBA(129, 185, 251, 1).CGColor;
    _codeButton.layer.borderWidth=2;
    
    _codeTextFiled.delegate=self;
    _codeTextFiled.returnKeyType=UIReturnKeyDone;
    _codeTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    _phoneTextFiled.delegate=self;
    //    _phoneTextFiled.returnKeyType=UIReturnKeyDone;
    _phoneTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    _passwordTextFiled.delegate=self;
    _passwordTextFiled.returnKeyType=UIReturnKeyDone;
    _invaliteTextFiled.delegate=self;
    _invaliteTextFiled.returnKeyType=UIReturnKeyDone;
    
    _registerButton.layer.cornerRadius=5;
    _registerButton.layer.masksToBounds=YES;
    
    _bgView.layer.borderWidth=0.5;
    _bgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    //    _buttonBgView.layer.borderWidth=0.5;
    //    _buttonBgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    [_chooseButton setImage:[UIImage imageNamed:@"cancel_trip_normal"] forState:UIControlStateNormal];
    [_chooseButton setImage:[UIImage imageNamed:@"cancel_trip_pre"] forState:UIControlStateSelected];
    
    _chooseButton.selected=YES;
    
    //    UIColor * normalColor=[CYTSI colorWithHexString:@"#999999"];
    //    UIColor * selectedColor=[CYTSI colorWithHexString:@"#386AC6"];
    
    //    [_rentCarButton setTitleColor:normalColor forState:UIControlStateNormal];
    //    [_rentCarButton setTitleColor:selectedColor forState:UIControlStateSelected];
    //    [_rentCarButton setImage:[UIImage imageNamed:@"cancel_trip_normal"] forState:UIControlStateNormal];
    //    [_rentCarButton setImage:[UIImage imageNamed:@"cancel_trip_pre"] forState:UIControlStateSelected];
    
    //    [_quickCarButton setTitleColor:normalColor forState:UIControlStateNormal];
    //    [_quickCarButton setTitleColor:selectedColor forState:UIControlStateSelected];
    //    [_quickCarButton setImage:[UIImage imageNamed:@"cancel_trip_normal"] forState:UIControlStateNormal];
    //    [_quickCarButton setImage:[UIImage imageNamed:@"cancel_trip_pre"] forState:UIControlStateSelected];
    
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_codeTextFiled resignFirstResponder];
    [_phoneTextFiled resignFirstResponder];
    [_passwordTextFiled resignFirstResponder];
    [_invaliteTextFiled resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_codeTextFiled resignFirstResponder];
    [_phoneTextFiled resignFirstResponder];
    [_passwordTextFiled resignFirstResponder];
    [_invaliteTextFiled resignFirstResponder];
}

- (IBAction)chooseButtonClicked:(UIButton *)sender
{
    _chooseButton.selected=!_chooseButton.selected;
}

//清除手机号按钮点击事件
- (IBAction)phonCloseButtonClicked:(id)sender
{
    _phoneTextFiled.text=@"";
}

//发送验证码按钮点击事件
- (IBAction)codeButtonClicked:(id)sender
{
    [_phoneTextFiled resignFirstResponder];
    
    BOOL isRight=[CYTSI checkTelNumber:_phoneTextFiled.text];
    if (isRight==NO) {
        [CYTSI otherShowTostWithString:@"请输入正确的手机号"];
        return;
    }
    
    //    NSString * ipAddress=[CYTSI deviceWANIPAdress];
    
    [AFRequestManager postRequestWithUrl:DRIVER_SEND_VERIFY params:@{@"phone":_phoneTextFiled.text} tost:YES special:0 success:^(id responseObject) {
        
        [CYTSI otherShowTostWithString:@"验证码已发送"];
        [self startTime];
        
    } failure:^(NSError *error) {
        
    }];
}

//二维码按钮点击事件
- (IBAction)invaliteButtonClicked:(id)sender
{
    CheckCodeViewController *vc = [[CheckCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//注册按钮点击事件
- (IBAction)registerButtonClicked:(id)sender
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
    
    BOOL isRightSecret=[CYTSI checkIsIncludeNumberWithLetter:_passwordTextFiled.text];
    if (isRightSecret==NO) {
        [CYTSI otherShowTostWithString:@"请输入6-12位字母加数字组合密码"];
        return;
    }
    NSString * ipAddress=[CYTSI deviceWANIPAdress];
    [AFRequestManager postRequestWithUrl:DRIVER_DRIVER_REGISTER params:@{@"driver_account":_phoneTextFiled.text,@"driver_password":_passwordTextFiled.text,@"verify_code":_codeTextFiled.text,@"register_ip":ipAddress,@"invite_code":_invaliteTextFiled.text} tost:YES special:0 success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        DriverModel * driver=[DriverModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [CYTSI otherShowTostWithString:@"注册成功"];
//        UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        Register_ONE_ViewController * RVC = [board instantiateViewControllerWithIdentifier:@"Register_ONE_id"];
//        RVC.choosedCity=[NSString stringWithFormat:@"%@",self.city];
//        RVC.driver=driver;
//        [self.navigationController pushViewController:RVC animated:YES];
        
        RegisterCityAndCarTypeViewController *vc = [[RegisterCityAndCarTypeViewController alloc] init];
        vc.driver = driver;
        vc.type = @"regist";
        [self.navigationController pushViewController:vc animated:YES];
        
        
    } failure:^(NSError *error) {
        
    }];

    
}

//协议按钮点击事件
- (IBAction)xieYiButtonClicked:(id)sender
{
    WebViewViewController * vc=[[WebViewViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//出租车按钮点击事件
//- (IBAction)rentCarButtonClicked:(id)sender
//{
//    _rentCarButton.selected=YES;
//    _quickCarButton.selected=NO;
//}
//
////快车按钮点击事件
//- (IBAction)quickCarButtonClicked:(id)sender
//{
//    _quickCarButton.selected=YES;
//    _rentCarButton.selected=NO;
//}

//定位按钮点击事件
-(void)startLocation
{
    [AMapServices sharedServices].enableHTTPS = YES;
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
//        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
//            NSLog(@"reGeocode:%@", regeocode);
            
            self.city=regeocode.city;
            
        }
    }];
    
}

-(void)startTime
{
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
                _codeButton.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
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

/**
 *  字符串显示不同颜色
 *  string:         lable显示的文本
 *  str:            要改变颜色的文字
 *  button:          要设置的button
 *  textColor:      要改变的部分文字的颜色
 */
-(void)setDefrientColorWith:(NSString *)string someStr:(NSString *)str theLable:(UIButton *)button theColor:(UIColor *)textColor
{
    NSMutableAttributedString * theStr=[[NSMutableAttributedString alloc]initWithString:string];
    NSRange range=NSMakeRange([[theStr string] rangeOfString:str].location, [[theStr string] rangeOfString:str].length);
    [theStr addAttribute:NSForegroundColorAttributeName value:textColor range:range];
    
    [button.titleLabel setAttributedText:theStr];
    //    [lable sizeToFit];
    
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
