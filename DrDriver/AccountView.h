//
//  AccountView.h
//  DrDriver
//
//  Created by fy on 2018/10/10.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountView : UIView

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *alertView;
@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,strong)UILabel *topLineLB;
@property(nonatomic,strong)UILabel *moneyLB;//价钱
@property(nonatomic,strong)UIView *tfBgView;//输入框背景View
@property(nonatomic,strong)UITextField *moneyTF;//费用输入框
@property(nonatomic,strong)UILabel *detailLB;//描述
@property(nonatomic,strong)UIButton *confirmBtn;//确认按钮
@property(nonatomic,strong)UIButton *cancelBtn;//取消按钮

-(instancetype)initWithFrame:(CGRect)frame money:(NSString *)string;

@property(nonatomic,strong) void (^cancelBlock)();
@property(nonatomic,strong) void (^confirmBlock)();

@end
