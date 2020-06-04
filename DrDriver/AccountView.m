//
//  AccountView.m
//  DrDriver
//
//  Created by fy on 2018/10/10.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "AccountView.h"

@implementation AccountView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame money:(NSString *)string{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self creatViewWith:string];
    }
    return self;
}

-(void)creatViewWith:(NSString *)moneyStr{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    self.bgView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self addSubview:self.bgView];
    
    self.alertView = [[UIView alloc] init];
    self.alertView.layer.cornerRadius = 10;
    self.alertView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(275);
        make.height.mas_offset(250);
        make.center.equalTo(self.bgView);
    }];
    
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.text = @"订单结算";
    self.titleLB.font = [UIFont systemFontOfSize:18];
    self.titleLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self.alertView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertView).offset(15);
        make.centerX.equalTo(self.alertView);
    }];
    
    self.topLineLB = [[UILabel alloc] init];
    self.topLineLB.backgroundColor = [CYTSI colorWithHexString:@"#d8d8d8"];
    [self.alertView addSubview:self.topLineLB];
    [self.topLineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.titleLB.mas_bottom).offset(15);
        make.width.mas_offset(255);
        make.height.mas_offset(1);
    }];
    
    self.moneyLB = [[UILabel alloc] init];
    self.moneyLB.font = [UIFont systemFontOfSize:35];
    self.moneyLB.text = [NSString stringWithFormat:@"¥ %@",moneyStr];
    [self.alertView addSubview:self.moneyLB];
    [self.moneyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.topLineLB.mas_bottom).offset(10);
    }];
    
    self.tfBgView = [[UIView alloc] init];
    self.tfBgView.layer.cornerRadius = 5;
    self.tfBgView.layer.borderWidth = 1;
    self.tfBgView.layer.borderColor = [CYTSI colorWithHexString:@"#999999"].CGColor;
    [self.alertView addSubview:self.tfBgView];
    [self.tfBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.width.mas_offset(210);
        make.height.mas_offset(35);
        make.top.equalTo(self.moneyLB.mas_bottom).offset(10);
    }];
    
    self.moneyTF = [[UITextField alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"¥ 在此输入过桥费高速费等" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:style}];
    self.moneyTF.attributedPlaceholder = attri;
    [self.tfBgView addSubview:self.moneyTF];
    [self.moneyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tfBgView);
        make.width.mas_offset(200);
        make.height.mas_offset(35);
    }];
    
    self.detailLB = [[UILabel alloc] init];
    self.detailLB.numberOfLines = 0;
    self.detailLB.text = @"提示：是能输入高速费、过桥费等合理费用，平台将对乱收费现象进行惩罚";
    self.detailLB.font = [UIFont systemFontOfSize:10];
    self.detailLB.textColor = [CYTSI colorWithHexString:@"#999999"];
    [self.alertView addSubview:self.detailLB];
    [self.detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfBgView.mas_bottom).offset(10);
        make.centerX.equalTo(self.tfBgView);
        make.width.equalTo(self.tfBgView);
    }];
    
    self.confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.alertView addSubview:self.confirmBtn];
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.masksToBounds = YES;
    [self.confirmBtn setTitle:@"确认" forState:(UIControlStateNormal)];
    [self.confirmBtn setBackgroundColor:[UIColor colorWithRed:36/255.0 green:136/255.0 blue:239/255.0 alpha:1.0]];
    [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(114);
        make.height.mas_offset(33);
        make.bottom.equalTo(self.alertView).offset(-17.5);
        make.right.equalTo(self.alertView.mas_centerX).offset(-10);
    }];
    
    self.cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.alertView addSubview:self.cancelBtn];
    self.cancelBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.masksToBounds = YES;
    [self.cancelBtn setTitle:@"返回" forState:(UIControlStateNormal)];
    [self.cancelBtn setBackgroundColor:[UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1.0]];
    [self.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(114);
        make.height.mas_offset(33);
        make.bottom.equalTo(self.alertView).offset(-17.5);
        make.left.equalTo(self.alertView.mas_centerX).offset(10);
    }];
  
}
-(void)confirmAction{
    self.confirmBlock();
}

-(void)cancelAction{
    self.cancelBlock();
}







@end
