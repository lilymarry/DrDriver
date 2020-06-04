//
//  RegisteViewController.m
//  ETravel
//
//  Created by mac on 2017/5/15.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "RegisteViewController.h"
#import "DriverModel.h"
#import "LoginViewController.h"

@interface RegisteViewController () <UITextFieldDelegate>

{
    DriverModel * driver;
}

@end

@implementation RegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_isLogin) {
        
        self.title=@"注册";
        _backViewHeight.constant=132;
        _secretLable.text=@"密码";
        [_sureButton setTitle:@"注册" forState:UIControlStateNormal];
        _xieYiButton.hidden=NO;
        
        UIColor * btnColor=[CYTSI colorWithHexString:@"#386ac6"];
        [self setDefrientColorWith:@"登录即表示同意APP名称《用户使用协议》" someStr:@"《用户使用协议》" theLable:_xieYiButton theColor:btnColor];
        
    }else{
        
        _xieYiButton.hidden=YES;
        
        if (_isChange==NO) {
            self.title=@"忘记密码";
            _topView.hidden=YES;
        }else{
            self.title=@"修改密码";
            _topView.hidden=NO;
            _bgViewTop.constant=30;
        }
        
    }
    
    [self setUpNav];//创建导航栏
    
    _codeButton.backgroundColor=[CYTSI colorWithHexString:@"#2488ef"];
    _codeButton.layer.cornerRadius=3;
    _codeButton.layer.masksToBounds=YES;
    _codeButton.layer.borderColor=RGBA(129, 185, 251, 1).CGColor;
    _codeButton.layer.borderWidth=2;
    
    _codeTextFiled.delegate=self;
    _codeTextFiled.returnKeyType=UIReturnKeyDone;
    _codeTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    _phoneTextFiled.delegate=self;
    _phoneTextFiled.returnKeyType=UIReturnKeyDone;
    _phoneTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    _miMaTextFiled.delegate=self;
    _miMaTextFiled.returnKeyType=UIReturnKeyDone;
    _secretTextFiled.delegate=self;
    _secretTextFiled.returnKeyType=UIReturnKeyDone;
    
    _miMaTextFiled.secureTextEntry=YES;
    _secretTextFiled.secureTextEntry=YES;
    
    _sureButton.layer.cornerRadius=5;
    _sureButton.layer.masksToBounds=YES;
    
    _bgView.layer.masksToBounds=YES;
    
    
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
    [_miMaTextFiled resignFirstResponder];
    [_secretTextFiled resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_codeTextFiled resignFirstResponder];
    [_phoneTextFiled resignFirstResponder];
    [_miMaTextFiled resignFirstResponder];
    [_secretTextFiled resignFirstResponder];
}

//发送验证码按钮点击事件
- (IBAction)codeButtonClicked:(UIButton *)sender
{
    [_codeTextFiled resignFirstResponder];
    [_phoneTextFiled resignFirstResponder];
    [_miMaTextFiled resignFirstResponder];
    [_secretTextFiled resignFirstResponder];
    
    if (_isChange==NO) {
        
        BOOL isRight=[CYTSI checkTelNumber:_phoneTextFiled.text];
        if (isRight==NO) {
            [CYTSI otherShowTostWithString:@"请输入正确的手机号"];
            return;
        }
        
    }
    
    NSString * ipAddress=[CYTSI deviceWANIPAdress];
    
    if (_isChange==NO) {
        
        [AFRequestManager postRequestWithUrl:DRIVER_RESET_SEND_VERIFY params:@{@"phone":_phoneTextFiled.text,@"network_ip":ipAddress} tost:YES special:0 success:^(id responseObject) {
            
            driver = [DriverModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            [self startTime];
            [CYTSI otherShowTostWithString:@"验证码已发送"];
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        
        [AFRequestManager postRequestWithUrl:DRIVER_DRIVER_MODIFY_SEND_VERIFY params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"network_ip":ipAddress} tost:NO special:0 success:^(id responseObject) {
            
//            CodeModel * code=[CodeModel mj_objectWithKeyValues:responseObject[@"data"]];
//            _phoneLable.text=code.phone;
            
            [self startTime];
            [CYTSI otherShowTostWithString:@"验证码已发送"];
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
    
    
}

//协议按钮点击事件
- (IBAction)xieYiButtonClicked:(UIButton *)sender
{
    
}

//确认按钮点击事件
- (IBAction)sureButtonClicked:(UIButton *)sender
{
    if (_isChange==NO) {
        
        BOOL isRight=[CYTSI checkTelNumber:_phoneTextFiled.text];
        if (isRight==NO) {
            [CYTSI otherShowTostWithString:@"请输入正确的手机号"];
            return;
        }
        
    }
    if ([_codeTextFiled.text isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请输入验证码"];
        return;
    }
    BOOL isRightSecret=[CYTSI checkIsIncludeNumberWithLetter:_miMaTextFiled.text];
    if (isRightSecret==NO) {
        [CYTSI otherShowTostWithString:@"请输入6-12位字母加数字组合密码"];
        return;
    }
    if (![_miMaTextFiled.text isEqualToString:_secretTextFiled.text]) {
        [CYTSI otherShowTostWithString:@"两次输入密码不一致"];
        return;
    }
    if (_miMaTextFiled.text.length<6) {
        [CYTSI otherShowTostWithString:@"最少六位密码"];
        return;
    }
    
    if (_isChange) {
        
        [AFRequestManager postRequestWithUrl:DRIVER_DRIVER_MODIFY_PASSWD params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"driver_password":_miMaTextFiled.text,@"verify_code":_codeTextFiled.text,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
            
            [CYTSI otherShowTostWithString:@"修改成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        if (driver.driver_id == nil) {
            [CYTSI otherShowTostWithString:@"请先获取验证码"];
        }else{
        [AFRequestManager postRequestWithUrl:DRIVER_RESET_PASSWD params:@{@"driver_id":driver.driver_id,@"driver_password":_miMaTextFiled.text,@"verify_code":_codeTextFiled.text} tost:YES special:0 success:^(id responseObject) {
            
            [CYTSI otherShowTostWithString:@"重置密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
                
            
        } failure:^(NSError *error) {
            
        }];
        }
    }
    
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
