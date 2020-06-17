//
//  CYAlertView.m
//  ETravel
//
//  Created by mac on 2017/5/11.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "CYAlertView.h"

@interface CYAlertView () <UITextFieldDelegate>

//@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UIView * alertView;

@end

@implementation CYAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self creatAlertView];//创建弹出视图
        
    }
    
    return self;
}

-(void)setTitleStr:(NSString *)titleStr
{
    if (titleStr!=nil) {
        self.titleLable.text=titleStr;
    }
}

-(void)setAlertStr:(NSString *)alertStr
{
    if (alertStr!=nil) {
        self.alertLable.text=alertStr;
        self.moneyAlertLable.text=alertStr;
        int lableHeight=[CYTSI planRectHeight:self.alertLable.text font:14 theWidth:DeviceWidth*0.741-66];
        [self.alertLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(lableHeight);
        }];
    }
}

-(void)setCancleButtonStr:(NSString *)cancleButtonStr
{
    if (cancleButtonStr!=nil) {
        [self.cancleButton setTitle:cancleButtonStr forState:UIControlStateNormal];
    }
}

-(void)setSureButtonStr:(NSString *)sureButtonStr
{
    if (sureButtonStr!=nil) {
        [self.phoneButton setTitle:sureButtonStr forState:UIControlStateNormal];
    }
}

//创建弹出视图
-(void)creatAlertView
{
    _alertView=[[UIView alloc]init];
    _alertView.center=CGPointMake(DeviceWidth/2, DeviceHeight/2);
    _alertView.bounds=CGRectMake(0, 0, DeviceWidth*0.741, 173);
    _alertView.backgroundColor=[UIColor whiteColor];
    _alertView.layer.cornerRadius=5;
    _alertView.layer.masksToBounds=YES;
    [self addSubview:_alertView];
    
    self.titleLable=[[UILabel alloc]init];
    self.titleLable.text=self.titleStr;
    self.titleLable.font=[UIFont systemFontOfSize:16];
    self.titleLable.textAlignment=NSTextAlignmentCenter;
    self.titleLable.textColor=[CYTSI colorWithHexString:@"#333333"];
    [_alertView addSubview:self.titleLable];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(_alertView.mas_right).with.offset(-12);
        make.top.equalTo(@10);
        make.height.equalTo(@22);
    }];
    
    UIView * lineView=[[UIView alloc]init];
    lineView.backgroundColor=TABLEVIEW_BACKCOLOR;
    [_alertView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(_alertView.mas_right).with.offset(-12);
        make.height.equalTo(@1.5);
        make.top.equalTo(self.titleLable.mas_bottom).with.offset(8);
    }];
    
    int buttonHeight=(DeviceWidth*0.741-38-12)/2;
    
    self.cancleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleButton setTitle:self.cancleButtonStr forState:UIControlStateNormal];
    self.cancleButton.titleLabel.font=[UIFont systemFontOfSize:14];
    self.cancleButton.layer.cornerRadius=5;
    self.cancleButton.layer.masksToBounds=YES;
//    self.cancleButton.layer.borderColor=[CYTSI colorWithHexString:@"#ed4848"].CGColor;
//    self.cancleButton.layer.borderWidth=0.5;
    self.cancleButton.backgroundColor=[CYTSI colorWithHexString:@"#ed4848"];
    [self.cancleButton addTarget:self action:@selector(cancleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:self.cancleButton];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_alertView.mas_bottom).with.offset(-11);
        make.left.equalTo(@19);
        make.height.equalTo(@33);
        make.width.mas_equalTo(buttonHeight);
    }];
    
    self.phoneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.phoneButton setTitle:self.sureButtonStr forState:UIControlStateNormal];
    self.phoneButton.backgroundColor=[CYTSI colorWithHexString:@"#2591ff"];
    self.phoneButton.titleLabel.font=[UIFont systemFontOfSize:14];
    self.phoneButton.layer.cornerRadius=5;
    self.phoneButton.layer.masksToBounds=YES;
    [self.phoneButton addTarget:self action:@selector(phoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:self.phoneButton];
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_alertView.mas_bottom).with.offset(-11);
        make.right.equalTo(_alertView.mas_right).with.offset(-19);
        make.height.equalTo(@33);
        make.width.mas_equalTo(buttonHeight);
    }];
    
    UIView * labelBgView=[[UIView alloc]init];
    labelBgView.backgroundColor=[UIColor whiteColor];
    [_alertView addSubview:labelBgView];
    [labelBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).with.offset(5);
        make.bottom.equalTo(self.cancleButton.mas_top).with.offset(-5);
        make.left.equalTo(@33);
        make.right.equalTo(_alertView.mas_right).with.offset(-33);
    }];
    
    self.alertLable=[[UILabel alloc]init];
    self.alertLable.text=self.alertStr;
    int lableHeight=[CYTSI planRectHeight:self.alertLable.text font:14 theWidth:DeviceWidth*0.741-66];
    self.alertLable.textColor=[CYTSI colorWithHexString:@"#333333"];
    self.alertLable.font=[UIFont systemFontOfSize:14];
    self.alertLable.numberOfLines=0;
    self.alertLable.textAlignment=NSTextAlignmentCenter;
    [labelBgView addSubview:self.alertLable];
    [self.alertLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelBgView.mas_centerX);
        make.centerY.equalTo(labelBgView.mas_centerY);
        make.width.equalTo(labelBgView.mas_width);
        make.height.mas_equalTo(lableHeight);
    }];
    
    self.moneyAlertLable=[[UILabel alloc]init];
    self.moneyAlertLable.text=@"请输入本次行程费用";
    self.moneyAlertLable.textColor=[CYTSI colorWithHexString:@"#333333"];
    self.moneyAlertLable.font=[UIFont systemFontOfSize:14];
    self.moneyAlertLable.textAlignment=NSTextAlignmentCenter;
    self.moneyAlertLable.hidden=YES;
    [labelBgView addSubview:self.moneyAlertLable];
    [self.moneyAlertLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@4);
        make.left.equalTo(@0);
        make.right.equalTo(labelBgView.mas_right);
        make.height.equalTo(@20);
    }];
    
    self.moneyTextFiled=[[UITextField alloc]init];
    self.moneyTextFiled.delegate=self;
    
    UIView * leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 24, 40)];
    leftView.backgroundColor=[CYTSI colorWithHexString:@"#f8f8f8"];
    
    UILabel * leftLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 24, 40)];
    leftLable.text=@"¥";
    leftLable.textAlignment=NSTextAlignmentCenter;
    leftLable.font=[UIFont systemFontOfSize:14];
    leftLable.textColor=[CYTSI colorWithHexString:@"#333333"];
    [leftView addSubview:leftLable];
    
    self.moneyTextFiled.leftView=leftView;
    self.moneyTextFiled.leftViewMode=UITextFieldViewModeAlways;
    self.moneyTextFiled.returnKeyType=UIReturnKeyDone;
    self.moneyTextFiled.layer.cornerRadius=5;
    self.moneyTextFiled.layer.masksToBounds=YES;
    self.moneyTextFiled.keyboardType=UIKeyboardTypeDecimalPad;
    self.moneyTextFiled.backgroundColor=[CYTSI colorWithHexString:@"#f8f8f8"];
    self.moneyTextFiled.layer.borderColor=[CYTSI colorWithHexString:@"#979797"].CGColor;
    self.moneyTextFiled.layer.borderWidth=1;
    [labelBgView addSubview:self.moneyTextFiled];
    [self.moneyTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(labelBgView.mas_right).with.offset(-15);
        make.height.equalTo(@40);
        make.top.equalTo(self.moneyAlertLable.mas_bottom).with.offset(9);
    }];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if ([textField.text floatValue] <0.1) {
//        [CYTSI otherShowTostWithString:@"输入金额不能小于0.1元"];
//        textField.text = @"";
//    }
    [self.moneyTextFiled resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    if ([textField.text floatValue] <0.1) {
//        [CYTSI otherShowTostWithString:@"输入金额不能小于0.1元"];
//        textField.text = @"";
//    }
    self.moneyStr=textField.text;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"文字长度：%u",textField.text.length);
    NSString * str=[NSString stringWithFormat:@"%@%@",textField.text,string];
//    NSLog(@"文字：%@",str);
    
    self.moneyStr=str; 
    
    return YES;
}

//设置为单个按钮
-(void)setSingleButton
{
    self.cancleButton.hidden=YES;
    [self.phoneButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(DeviceWidth*0.741-38);
    }];
}

//还原为两个按钮
-(void)setDoubleButton
{
    self.cancleButton.hidden=NO;
    [self.phoneButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((DeviceWidth*0.741-38-12)/2);
    }];
}

//设置输入框是否隐藏
-(void)setTextFiled:(BOOL)isHiden
{
    if (isHiden) {//隐藏输入框
        self.alertLable.hidden=NO;
        self.moneyTextFiled.hidden=YES;
        self.moneyAlertLable.hidden=YES;
    } else {//显示输入框
        self.alertLable.hidden=YES;
        self.moneyTextFiled.hidden=NO;
        self.moneyAlertLable.hidden=NO;
    }
}

//显示弹出视图
-(void)showAlertView
{
    self.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight);
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = 0.3;// 动画时间
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    [self.alertView.layer addAnimation:animation forKey:nil];
    
}

//隐藏弹出视图
-(void)hideAlertView
{
//    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    
//    animation.duration = 0.5;// 动画时间
//    
//    NSMutableArray *values = [NSMutableArray array];
//    
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
//    
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
//    
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01, 0.01, 1.0)]];
//    
//    animation.values = values;
//    
//    [self.alertView.layer addAnimation:animation forKey:nil];
//    
//    [self performSelector:@selector(hide) withObject:self afterDelay:0.4];
    
    self.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
    
}

-(void)hidenBgButtonClicked
{
    if (self.moneyTextFiled.hidden==NO) {
        
        [self.moneyTextFiled resignFirstResponder];
        return;
        
    }
    if (_isCanHiden) {
        self.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
    }
}

//取消按钮点击事件
-(void)cancleButtonClicked
{
    [self.moneyTextFiled resignFirstResponder];
    self.cancleBlock();
}

//拨打电话按钮点击事件
-(void)phoneButtonClicked
{
    [self.moneyTextFiled resignFirstResponder];
    self.phoneBlock();
}

@end
