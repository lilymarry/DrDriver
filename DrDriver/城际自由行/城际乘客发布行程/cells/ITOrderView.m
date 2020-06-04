//
//  ITOrderView.m
//  DrUser
//
//  Created by fy on 2019/1/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITOrderView.h"

@implementation ITOrderView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self creatView];
    }
    return self;
}
-(void)creatView{
    self.stateTitleLB = [[UILabel alloc] init];
    self.stateTitleLB.font = [UIFont systemFontOfSize:15];
    self.stateTitleLB.text = @"当前状态";
    [self addSubview:self.stateTitleLB];
    [self.stateTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
    }];
    
    self.stateLB = [[UILabel alloc] init];
    self.stateLB.font = [UIFont systemFontOfSize:15];
    self.stateLB.text = @"------";
    [self addSubview:self.stateLB];
    [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stateTitleLB.mas_right).offset(15);
        make.centerY.equalTo(self.stateTitleLB);
    }];
    
//    self.tuikuanLB = [[UILabel alloc] init];
//    self.tuikuanLB.font = [UIFont systemFontOfSize:9];
//    self.tuikuanLB.text = @"(退款金额将在48小时之内原路退回至您的账户)";
//    self.tuikuanLB.textColor = [UIColor lightGrayColor];
//    self.tuikuanLB.numberOfLines = 0;
//    self.tuikuanLB.hidden = YES;
//    [self addSubview:self.tuikuanLB];
//    [self.tuikuanLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.stateLB);
//        make.top.equalTo(self.stateLB.mas_bottom).offset(3);
//        make.right.equalTo(self).offset(-60);
//    }];
    
    self.priceTitleLB = [[UILabel alloc] init];
    self.priceTitleLB.font = [UIFont systemFontOfSize:15];
    self.priceTitleLB.text = @"支付金额";
    [self addSubview:self.priceTitleLB];
    [self.priceTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.stateTitleLB.mas_bottom).offset(15);
    }];
    
    self.priceLB = [[UILabel alloc] init];
    self.priceLB.font = [UIFont systemFontOfSize:15];
    self.priceLB.text = @"------";
    [self addSubview:self.priceLB];
    [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceTitleLB.mas_right).offset(15);
        make.centerY.equalTo(self.priceTitleLB);
    }];
    
    
    self.timeTitleLB = [[UILabel alloc] init];
    self.timeTitleLB.font = [UIFont systemFontOfSize:15];
    self.timeTitleLB.text = @"发车时间";
    [self addSubview:self.timeTitleLB];
    [self.timeTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.priceTitleLB.mas_bottom).offset(15);
    }];
    
    self.timeLB = [[UILabel alloc] init];
    self.timeLB.font = [UIFont systemFontOfSize:15];
    self.timeLB.text = @"------";
    self.timeLB.textColor = RGBA(245, 166, 35, 1.0);
    [self addSubview:self.timeLB];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeTitleLB.mas_right).offset(15);
        make.centerY.equalTo(self.timeTitleLB);
    }];
    
//    self.remarkLB = [[UILabel alloc] init];
//    self.remarkLB.text = @"注：请在发车前5分钟到达上车点，若您迟到，司机有权取消您的订单";
//    self.remarkLB.font = [UIFont systemFontOfSize:9];
//    self.remarkLB.textColor = [UIColor lightGrayColor];
//    [self addSubview:self.remarkLB];
//    [self.remarkLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.timeTitleLB);
//        make.top.equalTo(self.timeTitleLB.mas_bottom).offset(5);
//    }];
    
//    self.kefuBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [self.kefuBtn setImage:[UIImage imageNamed:@"客服"] forState:(UIControlStateNormal)];
//    [self.kefuBtn addTarget:self action:@selector(kefuAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.kefuBtn];
//    [self.kefuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(15);
//        make.right.equalTo(self).offset(-15);
//        make.height.and.width.mas_offset(40);
//    }];
//    
//    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [btn  setTitle:@"联系客服" forState:(UIControlStateNormal)];
//    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [btn addTarget:self action:@selector(kefuAction) forControlEvents:(UIControlEventTouchUpInside)];
//    [self addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.kefuBtn.mas_bottom);
//        make.width.mas_offset(100);
//        make.centerX.equalTo(self.kefuBtn);
//        make.height.mas_offset(30);
//    }];
}
-(void)setData:(NSDictionary *)dic{
    self.stateLB.text  = dic[@"state_name"];
    self.priceLB.text = dic[@"driver_money"];
    self.timeLB.text = dic[@"estimate_time"];
}
//-(void)kefuAction{
//    self.kefuBlock();
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
