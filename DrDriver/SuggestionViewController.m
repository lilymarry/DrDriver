//
//  SuggestionViewController.m
//  takeOut
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 tangchaoke. All rights reserved.
//

#import "SuggestionViewController.h"

@interface SuggestionViewController ()<UITextViewDelegate,UITextFieldDelegate>

@end

@implementation SuggestionViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"意见反馈";
    self.view.backgroundColor=VIEW_BACKGROUND_COLOR;
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 20, 40);
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * lefItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=lefItem;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _contentTextView.delegate=self;
    _contentTextView.layer.cornerRadius=5;
    _contentTextView.layer.masksToBounds=YES;
    _contentTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _contentTextView.layer.borderWidth=1;
    
    _phoneTextFiled.delegate=self;
    _phoneTextFiled.returnKeyType=UIReturnKeyDone;
    _phoneTextFiled.layer.cornerRadius=5;
    _phoneTextFiled.layer.masksToBounds=YES;
    _phoneTextFiled.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _phoneTextFiled.layer.borderWidth=1;
    
    UIColor * color=[CYTSI colorWithHexString:@"#999999"];
    NSMutableAttributedString *moneyText = [[NSMutableAttributedString alloc]initWithString:_phoneTextFiled.placeholder attributes:@{NSForegroundColorAttributeName :color,NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    _phoneTextFiled.attributedPlaceholder = moneyText;
    
    UIView * leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 44)];
    leftView.backgroundColor=[UIColor whiteColor];
    _phoneTextFiled.leftViewMode=UITextFieldViewModeAlways;
    _phoneTextFiled.leftView=leftView;
    
}

//返回按钮
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提交按钮
- (IBAction)comitButtonClicked:(UIButton *)sender
{
    [_phoneTextFiled resignFirstResponder];
    [_contentTextView resignFirstResponder];
    
//    BOOL isRight=[CYTSI checkTelNumber:_phoneTextFiled.text];
    if ([_contentTextView.text isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请输入您的宝贵意见"];
        return;
    }
//    if (isRight==NO) {
//        [CYTSI otherShowTostWithString:@"请输入正确的手机号"];
//        return;
//    }
    
    [AFRequestManager postRequestWithUrl:DRIVER_FEEDBACK_ADD_BACK params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"content":_contentTextView.text} tost:YES special:0 success:^(id responseObject) {
        
        [CYTSI otherShowTostWithString:@"反馈成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneTextFiled resignFirstResponder];
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==_contentTextView) {
        if ([_contentTextView.text length] == 0) {
            [_placeHolderLable setHidden:NO];
        }else{
            [_placeHolderLable setHidden:YES];
        }
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    if (textView.text.length>=200 && ![text isEqualToString:@""]) {
        
        [CYTSI otherShowTostWithString:@"最多输入200字"];
        return NO;
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_phoneTextFiled resignFirstResponder];
    [_contentTextView resignFirstResponder];
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
