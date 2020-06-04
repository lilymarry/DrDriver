//
//  GetOrderAlertView.m
//  DrDriver
//
//  Created by fy on 2019/2/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "GetOrderAlertView.h"

@implementation GetOrderAlertView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        [self creatView];
    }
    return self;
}
-(void)creatView{
    self.alertView = [[UIView alloc] init];
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.cornerRadius=5;
    self.alertView.layer.masksToBounds=YES;
    [self addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_offset(DeviceWidth - 120);
        make.height.mas_offset(170);
    }];
    
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.text = @"抢单成功";
    self.titleLB.font = [UIFont systemFontOfSize:22];
    self.titleLB.textColor = RGBA(245, 166, 35, 1.0);
    [self.alertView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.alertView).offset(15);
    }];
    
    self.detailLB = [[UILabel alloc] init];
    self.detailLB.numberOfLines = 0;
    self.detailLB.font = [UIFont systemFontOfSize:15];
    self.detailLB.text = @"成功抢到的订单将会显示在您的行程列表";
    [self.alertView addSubview:self.detailLB];
    [self.detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.titleLB.mas_bottom).offset(15);
        make.width.mas_offset(DeviceWidth - 170);
    }];
    
    self.btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setTitle:@"确定" forState:UIControlStateNormal];
    self.btn.titleLabel.font=[UIFont systemFontOfSize:16];
    self.btn.layer.cornerRadius=5;
    self.btn.layer.masksToBounds=YES;
    self.btn.backgroundColor=[CYTSI colorWithHexString:@"#2488ef"];
    [self.btn addTarget:self action:@selector(payOrderButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.width.mas_offset(DeviceWidth - 170);
        make.height.mas_offset(35);
        make.top.equalTo(self.detailLB.mas_bottom).offset(20);
    }];
}
-(void)payOrderButtonClicked{
    [self hidenOrderAlertView];
    self.popViewBlock(self.travel_id);
}
-(void)showOrderAlertView:(NSString *)travel_id{
    self.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight);
    self.travel_id = travel_id;
}
-(void)hidenOrderAlertView{
    self.frame = CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
