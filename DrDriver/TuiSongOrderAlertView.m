//
//  TuiSongOrderAlertView.m
//  DrDriver
//
//  Created by fy on 2019/7/19.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "TuiSongOrderAlertView.h"

@implementation TuiSongOrderAlertView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self creatView];
    }
    return self;
}

-(void)creatView{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    self.bgView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self addSubview:self.bgView];
    
    self.orderView = [[UIView alloc] init];
    self.orderView.backgroundColor = [UIColor whiteColor];
    self.orderView.layer.cornerRadius = 10;
    [self.bgView addSubview:self.orderView];
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.width.mas_offset(280);
        make.height.mas_offset(275);
    }];
    
    self.carTypeLB = [[UILabel alloc] init];
    self.carTypeLB.font = [UIFont systemFontOfSize:16];
    [self.orderView addSubview:self.carTypeLB];
    self.carTypeLB.textColor = [CYTSI colorWithHexString:@"#f5a623"];
    [self.carTypeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderView).mas_offset(12);
        make.top.equalTo(self.orderView).mas_offset(15);
    }];
    
    self.timeLB = [[UILabel alloc] init];
    self.timeLB.font = [UIFont systemFontOfSize:16];
    [self.orderView addSubview:self.timeLB];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderView).mas_offset(-12);
        make.top.equalTo(self.orderView).mas_offset(15);
    }];
  
    self.startImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trip_cell_star"]];
    [self.orderView addSubview:self.startImageView];
    
    self.startNameLB = [[UILabel alloc] init];
    self.startNameLB.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.startNameLB];
    
    self.startAddressLB = [[UILabel alloc] init];
    self.startAddressLB.font = [UIFont systemFontOfSize:12];
    self.startAddressLB.textColor = [UIColor lightGrayColor];
    [self.orderView addSubview:self.startAddressLB];
    
    
    self.endImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trip_cell_end"]];
    [self.orderView addSubview:self.endImageView];
    
    self.endNameLB = [[UILabel alloc] init];
    self.endNameLB.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.endNameLB];
    
    self.endAddressLB = [[UILabel alloc] init];
    self.endAddressLB.font = [UIFont systemFontOfSize:12];
    self.endAddressLB.textColor = [UIColor lightGrayColor];
    [self.orderView addSubview:self.endAddressLB];
    
    [self.startImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.carTypeLB.mas_bottom).mas_offset(25);
        make.left.equalTo(self.orderView).mas_offset(8);
        make.width.and.height.mas_offset(8);
    }];
    
    [self.startNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startImageView.mas_right).mas_offset(5);
        make.centerY.equalTo(self.startImageView);
        make.right.equalTo(self.orderView).mas_offset(-3);
    }];
    
    [self.startAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startImageView.mas_right).mas_offset(5);
        make.top.equalTo(self.startNameLB.mas_bottom);
        make.right.equalTo(self.orderView).mas_offset(-3);
    }];
    
    [self.endImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startImageView.mas_bottom).mas_offset(40);
        make.left.equalTo(self.orderView).mas_offset(8);
        make.width.and.height.mas_offset(8);
    }];
    
    [self.endNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endImageView.mas_right).mas_offset(5);
        make.centerY.equalTo(self.endImageView);
        make.right.equalTo(self.orderView).mas_offset(-3);
    }];
    
    [self.endAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endImageView.mas_right).mas_offset(5);
        make.top.equalTo(self.endNameLB.mas_bottom);
        make.right.equalTo(self.orderView).mas_offset(-3);
    }];
    
    
    
    self.userDistanceLB = [[UILabel alloc] init];
    self.userDistanceLB.font = [UIFont systemFontOfSize:14];
    [self.orderView addSubview:self.userDistanceLB];
    
    self.distanceLB = [[UILabel alloc] init];
    self.distanceLB.font = [UIFont systemFontOfSize:14];
    [self.orderView addSubview:self.distanceLB];
    
    [self.userDistanceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderView).mas_offset(8);
        make.top.equalTo(self.endAddressLB.mas_bottom).offset(25);
    }];
    
    [self.distanceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderView).mas_offset(-8);
        make.top.equalTo(self.endAddressLB.mas_bottom).offset(25);
    }];
    
    self.bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景11"]];
    [self.orderView addSubview:self.bottomImageView];
    self.bottomImageView.layer.cornerRadius = 20;
    self.bottomImageView.layer.masksToBounds = YES;
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.orderView).offset(-3);
        make.width.mas_offset(288);
        make.centerX.equalTo(self.orderView);
        make.height.mas_offset(98);
    }];
    
    self.takeOrderBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.takeOrderBtn setImage:[UIImage imageNamed:@"按钮11"] forState:(UIControlStateNormal)];
    [self.takeOrderBtn addTarget:self action:@selector(takeOrderAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.orderView addSubview:self.takeOrderBtn];
    [self.takeOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomImageView);
        make.width.and.height.mas_offset(80);
    }];
   
    self.closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.closeBtn setImage:[UIImage imageNamed:@"取消11"] forState:(UIControlStateNormal)];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.orderView.mas_top).offset(2);
        make.left.equalTo(self.orderView.mas_right).offset(-2);
        make.height.and.width.mas_offset(30);
    }];

}

-(void)setDataDic:(NSDictionary *)dataDic{
    self.order_id = dataDic[@"order_id"];
    self.order_type = dataDic[@"order_type"];
    self.appoint_type = dataDic[@"appoint_type"];
    self.carTypeLB.text = dataDic[@"order_type_name"];
    self.timeLB.text = dataDic[@"ctime"];
    self.startAddressLB.text = dataDic[@"start_address"];
    self.startNameLB.text = dataDic[@"start_name"];
    if ([dataDic[@"end_address"] isEqualToString:@""]) {
        self.endAddressLB.text = @"";
        self.endNameLB.text = @"目的地待与乘客确认";
    }else{
        self.endAddressLB.text = dataDic[@"end_address"];
        self.endNameLB.text = dataDic[@"end_name"];
    }
    self.userDistanceLB.text = dataDic[@"distance"];
    self.distanceLB.text = dataDic[@"miles"];
}
-(void)takeOrderAction{
    self.takeOrderBlock(self.order_id, self.order_type, self.appoint_type);
}
-(void)closeAction{
    self.closeBlock();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
