//
//  SLPwdView.m
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/30.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "SLPwdView.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface SLPwdView()<UITextFieldDelegate>
@property (strong,nonatomic) UILabel * titleLable;
@property (strong,nonatomic) UIButton * cancleButton;
@property (strong,nonatomic) UIButton * phoneButton;
@property (strong,nonatomic) UILabel * alertLable;


@property (strong,nonatomic) UITextField * moneyTextFiled;//输入密码提示框

@property (strong,nonatomic) NSString * moneyStr;//输入的密码
@property (nonatomic,strong) UIView * alertView;



@end

@implementation SLPwdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
             _alertView=[[UIView alloc]init];
            _alertView.center=CGPointMake(DeviceWidth/2, DeviceHeight/2);
            _alertView.bounds=CGRectMake(0, 0, DeviceWidth*0.741, 180);
            _alertView.backgroundColor=[UIColor whiteColor];
            _alertView.layer.cornerRadius=5;
            _alertView.layer.masksToBounds=YES;
            [self addSubview:_alertView];
            
            self.titleLable=[[UILabel alloc]init];
            self.titleLable.text=@"密码";
            self.titleLable.font=[UIFont systemFontOfSize:16];
            self.titleLable.textAlignment=NSTextAlignmentCenter;
            self.titleLable.textColor=[CYTSI colorWithHexString:@"#333333"];
            [_alertView addSubview:self.titleLable];
            [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.alertView.mas_left).mas_offset(12);
                make.top.equalTo(self.alertView.mas_top).with.offset(30);
                make.width.mas_equalTo(45);
            }];
            self.moneyTextFiled=[[UITextField alloc]init];
           self.moneyTextFiled.delegate=self;
           self.moneyTextFiled.placeholder = @" 请输入密码";
           self.moneyTextFiled.font =[UIFont systemFontOfSize:16];
           self.moneyTextFiled.returnKeyType=UIReturnKeyDone;
           self.moneyTextFiled.layer.cornerRadius=5;
           self.moneyTextFiled.layer.masksToBounds=YES;
           self.moneyTextFiled.keyboardType=UIKeyboardTypeDecimalPad;
           self.moneyTextFiled.backgroundColor=[CYTSI colorWithHexString:@"#f8f8f8"];
           self.moneyTextFiled.layer.borderColor=[CYTSI colorWithHexString:@"#979797"].CGColor;
           self.moneyTextFiled.layer.borderWidth=1;
           self.moneyTextFiled.keyboardType =UIKeyboardTypeASCIICapable;//(根据个人喜好设置键盘)
           [_alertView addSubview:self.moneyTextFiled];
           [self.moneyTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.mas_equalTo(self.titleLable.mas_right).mas_offset(10);
               make.right.equalTo(_alertView.mas_right).with.offset(-15);
               make.height.equalTo(@40);
               make.centerY.equalTo(self.titleLable.mas_centerY);
           }];
            self.cancleButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
            self.cancleButton.titleLabel.font=[UIFont systemFontOfSize:14];
            self.cancleButton.layer.cornerRadius=5;
            self.cancleButton.backgroundColor=[UIColor orangeColor];
            [self.cancleButton addTarget:self action:@selector(cancleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:self.cancleButton];
        
            int buttonHeight=(DeviceWidth*0.741-38-12)/2;
        
            [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_alertView.mas_bottom).with.offset(-40);
                make.left.equalTo(@19);
                make.height.equalTo(@33);
                make.width.mas_equalTo(buttonHeight);
            }];
            
            self.phoneButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.phoneButton setTitle:@"确认" forState:UIControlStateNormal];
            self.phoneButton.backgroundColor=[CYTSI colorWithHexString:@"#2591ff"];
            self.phoneButton.titleLabel.font=[UIFont systemFontOfSize:14];
            self.phoneButton.layer.cornerRadius=5;
            self.phoneButton.layer.masksToBounds=YES;
            [self.phoneButton addTarget:self action:@selector(phoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:self.phoneButton];
            [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_alertView.mas_bottom).with.offset(-40);
                make.right.equalTo(_alertView.mas_right).with.offset(-19);
                make.height.equalTo(@33);
                make.width.mas_equalTo(buttonHeight);
            }];

        self.moneyStr = @"";
    }
    return self;
}

- (void)cancleButtonClicked{
    self.cancleBlock();
}

- (void)phoneButtonClicked{
    
    self.sureBlock(self.moneyStr);
}

#pragma mark textFiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[newString componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    self.moneyStr = filtered;
    return [newString isEqualToString:filtered];
}

- (void)showAlertView{
   UIWindow * window=[UIApplication sharedApplication].delegate.window;
   [window addSubview:self];
}

- (void)hideAlertView{
    [self endEditing:YES];
    [self removeFromSuperview];
}
@end
