//
//  ChangePasswordTwoViewController.m
//  DrUser
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "ChangePasswordTwoViewController.h"

@interface ChangePasswordTwoViewController () <UITextFieldDelegate>

@end

@implementation ChangePasswordTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"修改密码";
    self.view.backgroundColor=TABLEVIEW_BACKCOLOR;
    [self setUpNav];//设置导航栏
    
    self.sureButton.layer.cornerRadius=3;
    self.sureButton.layer.masksToBounds=YES;
    
    self.passwordTextFiled.delegate=self;
    self.passwordTextFiled.returnKeyType=UIReturnKeyDone;
    self.aginPasswordTextFiled.delegate=self;
    self.aginPasswordTextFiled.returnKeyType=UIReturnKeyDone;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.passwordTextFiled resignFirstResponder];
    [self.aginPasswordTextFiled resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.passwordTextFiled resignFirstResponder];
    [self.aginPasswordTextFiled resignFirstResponder];
    
    return YES;
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//确认按钮点击事件
- (IBAction)sureButtonClicked:(id)sender
{
    if ([_passwordTextFiled.text isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请输入密码"];
        return;
    }
    if ([_aginPasswordTextFiled.text isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请输入确认你输入的密码"];
        return;
    }
    if (![_aginPasswordTextFiled.text isEqualToString:_passwordTextFiled.text]) {
        [CYTSI otherShowTostWithString:@"两次输入的密码不一致"];
        return;
    }
    if (_passwordTextFiled.text.length<6) {
        [CYTSI otherShowTostWithString:@"密码最少六位"];
        return;
    }
    
    [AFRequestManager postRequestWithUrl:DRIVER_DRIVER_MODIFY_PASSWD params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"driver_password":_passwordTextFiled.text,@"verify_code":_codeStr,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        
        [CYTSI otherShowTostWithString:@"修改成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
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
