//
//  ITOrderDetailView.m
//  DrUser
//
//  Created by fy on 2019/1/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITOrderDetailView.h"

@implementation ITOrderDetailView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
//        self.state = state;
        [self creatView];
    }
    return self;
}
-(void)creatView{
    self.startCityLB = [[UILabel alloc] init];
    self.startCityLB.text = @"--";
    self.startCityLB.font = [UIFont systemFontOfSize:15];
    self.startCityLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.startCityLB];
    
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头"]];
    [self addSubview:self.arrowImageView];
    
    self.endCityLB = [[UILabel alloc] init];
    self.endCityLB.text = @"--";
    self.endCityLB.font = [UIFont systemFontOfSize:15];
    self.endCityLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.endCityLB];
///////////////startView
    self.startImageLB  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"坐标-起始q"]];
    [self addSubview:self.startImageLB];
    
    self.startMapBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.startMapBtn setImage:[UIImage imageNamed:@"导航q"] forState:(UIControlStateNormal)];
    [self.startMapBtn addTarget:self action:@selector(mapAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.startMapBtn];
    
    self.startAdLB = [[UILabel alloc] init];
    self.startAdLB.text = @"--";
    self.startAdLB.font = [UIFont systemFontOfSize:15];
    self.startAdLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.startAdLB];
    
    self.startAddressLB = [[UILabel alloc] init];
    self.startAddressLB.text = @"------";
    self.startAddressLB.font = [UIFont systemFontOfSize:9];
    self.startAddressLB.textColor = [UIColor lightGrayColor];
    [self addSubview:self.startAddressLB];
    [self.startCityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.endCityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.startCityLB);
        make.width.and.height.mas_offset(30);
    }];
    
    
    [self.startMapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-10);
        make.centerY.equalTo(self.mas_centerY).offset(-10);
        make.width.and.height.mas_offset(90);
    }];
    
    [self.startImageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_offset(25);
        make.top.equalTo(self.startCityLB.mas_bottom).offset(15);
        make.left.equalTo(self).offset(10);
    }];
    
    [self.startAdLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startImageLB.mas_right).offset(7);
        make.centerY.equalTo(self.startImageLB.mas_centerY).offset(-3);
        make.right.equalTo(self.startMapBtn.mas_left);
    }];
    
    [self.startAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startImageLB.mas_right).offset(7);
        make.top.equalTo(self.startAdLB.mas_bottom);
        make.right.equalTo(self.startMapBtn.mas_left);
    }];
    
    self.startDetailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"乘车点"]];
    [self addSubview:self.startDetailImageView];
    [self.startDetailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startAddressLB.mas_bottom).offset(5);
        make.left.equalTo(self.startAddressLB);
        make.width.mas_offset(52);
        make.height.mas_offset(13);
    }];

    self.startAcrossLine = [[UILabel alloc] init];
    self.startAcrossLine.backgroundColor = RGBA(245, 166, 35, 1.0);
    [self addSubview:self.startAcrossLine];
    [self.startAcrossLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startImageLB.mas_bottom).mas_offset(-5);
        make.width.mas_offset(1);
        make.centerX.equalTo(self.startImageLB);
        make.bottom.equalTo(self.startDetailImageView.mas_centerY);
    }];

    self.startVerticalLine = [[UILabel alloc] init];
    self.startVerticalLine.backgroundColor = RGBA(245, 166, 35, 1.0);
    [self addSubview:self.startVerticalLine];
    [self.startVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startAcrossLine.mas_centerX).mas_offset(-0.5);
        make.height.mas_offset(1);
        make.centerY.equalTo(self.startDetailImageView);
        make.right.equalTo(self.startDetailImageView.mas_left).mas_offset(2);
    }];

    self.startDetailNameLB = [[UILabel alloc] init];
    self.startDetailNameLB.text = @"------";
    self.startDetailNameLB.font = [UIFont systemFontOfSize:15];
    self.startDetailNameLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.startDetailNameLB];
    [self.startDetailNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startDetailImageView);
        make.left.equalTo(self.startDetailImageView.mas_right).offset(3);
        make.right.equalTo(self.startMapBtn.mas_left);
    }];

    self.startDetailAddressLB = [[UILabel alloc] init];
    self.startDetailAddressLB.text = @"------";
    self.startDetailAddressLB.font = [UIFont systemFontOfSize:9];
    self.startDetailAddressLB.textColor = [UIColor lightGrayColor];
    [self addSubview:self.startDetailAddressLB];
    [self.startDetailAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startDetailNameLB.mas_left);
        make.top.equalTo(self.startDetailNameLB.mas_bottom);
        make.right.equalTo(self.startMapBtn.mas_left);
    }];

////////////  endView
    self.endImageLB  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"坐标-终点q"]];
    [self addSubview:self.endImageLB];

    self.endAdLB = [[UILabel alloc] init];
    self.endAdLB.text = @"--";
    self.endAdLB.font = [UIFont systemFontOfSize:15];
    self.endAdLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.endAdLB];

    self.endAddressLB = [[UILabel alloc] init];
    self.endAddressLB.text = @"------";
    self.endAddressLB.font = [UIFont systemFontOfSize:9];
    self.endAddressLB.textColor = [UIColor lightGrayColor];
    [self addSubview:self.endAddressLB];


    [self.endImageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_offset(25);
        make.top.equalTo(self.startDetailAddressLB.mas_bottom).offset(15);
        make.left.equalTo(self).offset(10);

    }];

    [self.endAdLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endImageLB.mas_right).offset(7);
        make.centerY.equalTo(self.endImageLB.mas_centerY).offset(-3);
        make.right.equalTo(self.startMapBtn.mas_left);
    }];

    [self.endAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endImageLB.mas_right).offset(7);
        make.top.equalTo(self.endAdLB.mas_bottom);
        make.right.equalTo(self.startMapBtn.mas_left);
    }];
    
    self.endDetailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"到达点"]];
    [self addSubview:self.endDetailImageView];
    [self.endDetailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endAddressLB.mas_bottom).offset(5);
        make.left.equalTo(self.endAddressLB);
        make.width.mas_offset(52);
        make.height.mas_offset(13);
    }];
    
    self.endAcrossLine = [[UILabel alloc] init];
    self.endAcrossLine.backgroundColor = [CYTSI colorWithHexString:@"#2488ef"];
    [self addSubview:self.endAcrossLine];
    [self.endAcrossLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endImageLB.mas_bottom).mas_offset(-5);
        make.width.mas_offset(1);
        make.centerX.equalTo(self.endImageLB);
        make.bottom.equalTo(self.endDetailImageView.mas_centerY);
    }];
    
    self.endVerticalLine = [[UILabel alloc] init];
    self.endVerticalLine.backgroundColor = [CYTSI colorWithHexString:@"#2488ef"];
    [self addSubview:self.endVerticalLine];
    [self.endVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endAcrossLine.mas_centerX).mas_offset(-0.5);
        make.height.mas_offset(1);
        make.centerY.equalTo(self.endDetailImageView);
        make.right.equalTo(self.endDetailImageView.mas_left).mas_offset(2);
    }];
    
    self.endDetailNameLB = [[UILabel alloc] init];
    self.endDetailNameLB.text = @"------";
    self.endDetailNameLB.font = [UIFont systemFontOfSize:15];
    self.endDetailNameLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.endDetailNameLB];
    [self.endDetailNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.endDetailImageView);
        make.left.equalTo(self.endDetailImageView.mas_right).offset(3);
        make.right.equalTo(self.startMapBtn.mas_left);
    }];
    
    self.endDetailAddressLB = [[UILabel alloc] init];
    self.endDetailAddressLB.text = @"------";
    self.endDetailAddressLB.font = [UIFont systemFontOfSize:9];
    self.endDetailAddressLB.textColor = [UIColor lightGrayColor];
    [self addSubview:self.endDetailAddressLB];
    [self.endDetailAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endDetailNameLB.mas_left);
        make.top.equalTo(self.endDetailNameLB.mas_bottom);
        make.right.equalTo(self.startMapBtn.mas_left);
    }];

    self.timeLB = [[UILabel alloc] init];
    self.timeLB.text = @"发车时间  --";
    self.timeLB.font = [UIFont systemFontOfSize:15];
    self.timeLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.timeLB];

    self.priceLB = [[UILabel alloc] init];
    self.priceLB.text = @"--元/位";
    self.priceLB.font = [UIFont systemFontOfSize:15];
    self.priceLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.priceLB];

    //        self.sumPriceLB = [[UILabel alloc] init];
    //        self.sumPriceLB.text = @"一口价包车--元";
    //        self.sumPriceLB.font = [UIFont systemFontOfSize:15];
    //        self.sumPriceLB.textColor = [CYTSI colorWithHexString:@"#f5a623"];
    //        [self addSubview:self.sumPriceLB];

    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.endDetailAddressLB.mas_bottom).offset(15);
    }];



    [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.timeLB.mas_bottom).offset(10);
    }];
//
//            [self.sumPriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.mas_right).offset(-15);
//                make.top.equalTo(self.priceLB.mas_bottom).offset(5);
//            }];
    
}
-(void)mapAction{
    self.mapBlock(self.dic);
}

-(void)setData:(NSDictionary *)dic{
    self.startCityLB.text  = [NSString stringWithFormat:@"%@%@",dic[@"start_city"],dic[@"start_county"]];
    self.endCityLB.text = [NSString stringWithFormat:@"%@%@",dic[@"end_city"],dic[@"end_county"]];
    self.startAdLB.text= dic[@"old_start_name"];
    self.startAddressLB.text = dic[@"old_start_address"];
    self.endAdLB.text = dic[@"old_end_name"];
    self.endAddressLB.text = dic[@"old_end_address"];
    if ([dic[@"start_distance"] isEqualToString:@"0.00"]) {
        self.startDetailNameLB.text = @"使用默认上车地点";
        self.startDetailAddressLB.hidden = YES;
    }else{
        self.startDetailNameLB.text = dic[@"start_name"];
        self.startDetailAddressLB.text = dic[@"start_address"];
    }
    if ([dic[@"end_distance"] isEqualToString:@"0.00"]) {
        self.endDetailNameLB.text = @"使用默认下车地点";
        self.endDetailAddressLB.hidden = YES;
    }else{
        self.endDetailNameLB.text = dic[@"end_name"];
        self.endDetailAddressLB.text = dic[@"end_address"];
    }
    self.dic = @{@"start_lat":dic[@"start_lat"],@"start_lng":dic[@"start_lng"],@"end_lat":dic[@"end_lat"],@"end_lng":dic[@"end_lng"]};
    self.timeLB.text = [NSString stringWithFormat:@"发车时间 %@",dic[@"estimate_time"]];
    self.priceLB.text = dic[@"state"];
//    if ([dic[@"is_baoche"] isEqualToString:@"0"]) {
//        self.priceLB.text = [NSString stringWithFormat:@"拼团 乘车人数%@人",dic[@"passenger_num"]];
//    }else if ([dic[@"is_baoche"] isEqualToString:@"1"]){
//        self.priceLB.text = @"轿车包车";
//    }else{
//        self.priceLB.text = @"商务七人座包车";
//    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
