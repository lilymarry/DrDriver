//
//  CYAlertView.h
//  ETravel
//
//  Created by mac on 2017/5/11.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYAlertView : UIView

@property (strong,nonatomic) void (^cancleBlock)();
@property (strong,nonatomic) void (^phoneBlock)();

@property (strong,nonatomic) NSString * titleStr;//标题
@property (strong,nonatomic) NSString * alertStr;//提示信息
@property (strong,nonatomic) NSString * cancleButtonStr;//取消按钮文字
@property (strong,nonatomic) NSString * sureButtonStr;//确认按钮文字

@property (strong,nonatomic) UILabel * titleLable;
@property (strong,nonatomic) UIButton * cancleButton;
@property (strong,nonatomic) UIButton * phoneButton;
@property (strong,nonatomic) UILabel * alertLable;
@property (assign,nonatomic) BOOL isCanHiden;//背景隐藏按钮是否起作用

@property (strong,nonatomic) UITextField * moneyTextFiled;//金额输入框
@property (strong,nonatomic) UILabel * moneyAlertLable;//金额提示lable
@property (strong,nonatomic) NSString * moneyStr;//输入的金额

-(void)showAlertView;//显示弹出视图
-(void)hideAlertView;//隐藏弹出视图

-(void)setSingleButton;//设置为单个按钮
-(void)setDoubleButton;//还原为两个按钮

-(void)setTextFiled:(BOOL)isHiden;//设置输入框是否隐藏

@end
