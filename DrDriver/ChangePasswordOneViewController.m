//
//  ChangePasswordOneViewController.m
//  DrUser
//
//  Created by mac on 2017/6/17.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "ChangePasswordOneViewController.h"
#import "ChangePasswordTwoViewController.h"
#import "CodeModel.h"

@interface ChangePasswordOneViewController () <UITextFieldDelegate>

{
    NSString * codeStr;//验证码
}

@end

@implementation ChangePasswordOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"修改密码";
//    self.view.backgroundColor=TABLEVIEW_BACKCOLOR;
    [self setUpNav];//设置导航栏
    [self creatSmallView];//设置小视图
    [self sendCodeRequest];//发送验证码请求
    
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

//发送验证码请求
-(void)sendCodeRequest
{
    NSString * ipAddress=[CYTSI deviceWANIPAdress];
    
    [AFRequestManager postRequestWithUrl:DRIVER_DRIVER_MODIFY_SEND_VERIFY params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"network_ip":ipAddress} tost:NO special:0 success:^(id responseObject) {
        
        CodeModel * code=[CodeModel mj_objectWithKeyValues:responseObject[@"data"]];
        _phoneLable.text=code.phone;
        
    } failure:^(NSError *error) {
        
    }];
}

//设置小视图
-(void)creatSmallView
{
    self.bgView.layer.cornerRadius=22;
    self.bgView.layer.masksToBounds=YES;
    self.bgView.layer.borderWidth=0.5;
    self.bgView.layer.borderColor=[CYTSI colorWithHexString:@"#2488ef"].CGColor;
    
    _codeTextFiled.delegate=self;
    _codeTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    [_codeTextFiled becomeFirstResponder];
    
    for (int i=0; i<6; i++) {
        
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(11.5+(20+10)*i, 12, 20, 20);
        [button setImage:[UIImage imageNamed:@"cancel_trip_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"code_selected"] forState:UIControlStateSelected];
        button.tag=10+i;
        [self.bgView addSubview:button];
        
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"文字长度：%u",textField.text.length);
    NSString * str=[NSString stringWithFormat:@"%@%@",textField.text,string];
//    NSLog(@"文字：%@",str);
    
    if (textField.text.length>5 && ![string isEqualToString:@""]) {
        
        return NO;
    }
    
    if (![string isEqualToString:@""]) {
        
        UIButton * button=[self.bgView viewWithTag:10+textField.text.length];
        button.selected=YES;
        
        if (str.length==6) {
            
            codeStr=str;
            [self performSelector:@selector(jump) withObject:self afterDelay:0.5];
            
        }
        
    }else{
        
        UIButton * button=[self.bgView viewWithTag:10+textField.text.length-1];
        button.selected=NO;
        
    }
    
    return YES;
}

//修改密码
-(void)jump
{
    ChangePasswordTwoViewController * vc=[[ChangePasswordTwoViewController alloc]init];
    vc.codeStr=codeStr;
    [self.navigationController pushViewController:vc animated:YES
     ];
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
