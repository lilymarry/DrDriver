//
//  ITOrderDriverDetailView.m
//  DrUser
//
//  Created by fy on 2019/1/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITOrderDriverDetailView.h"

@implementation ITOrderDriverDetailView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self creatView];
    }
    return self;
}
-(void)creatView{
    //    self.state = state;
    self.driverHeaderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_header"]];
    [self addSubview:self.driverHeaderImageView];
    self.driverHeaderImageView.layer.cornerRadius = 30;
    self.driverHeaderImageView.layer.masksToBounds = YES;
    self.driverHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.driverHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(10);
        make.height.and.width.mas_offset(60);
    }];
    
    self.driverNameLB = [[UILabel alloc] init];
    self.driverNameLB.text = @"--- 师傅";
    self.driverNameLB.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.driverNameLB];
    [self.driverNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.driverHeaderImageView.mas_top).mas_offset(4);
        make.left.equalTo(self.driverHeaderImageView.mas_right).offset(10);
    }];
    
    self.cyStarView=[[CYStarView alloc]init];
    [self.cyStarView setViewWithNumber:5 width:10 space:2 enable:NO];
    [self addSubview:self.cyStarView];
    [self.cyStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.driverNameLB.mas_bottom).offset(8);
        make.width.mas_offset(70.0/414.0 * DeviceWidth);
        make.height.mas_offset(10.0/414.0 * DeviceWidth);
        make.left.equalTo(self.driverHeaderImageView.mas_right).offset(10);
    }];
    
    //    self.sumNumberLB = [[UILabel alloc] init];
    //    self.sumNumberLB.text = @"核定载客位数--人";
    //    self.sumNumberLB.font = [UIFont systemFontOfSize:12];
    //    self.sumNumberLB.textColor = [CYTSI colorWithHexString:@"#2488ef"];
    //    [self addSubview:self.sumNumberLB];
    //    [self.sumNumberLB mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.cyStarView.mas_right).offset(15);
    //        make.centerY.equalTo(self.cyStarView);
    //    }];
    //
    //    self.carNumberLB = [[UILabel alloc] init];
    //    self.carNumberLB.text = @"-------";
    //    self.carNumberLB.font = [UIFont systemFontOfSize:12];
    //    [self addSubview:self.carNumberLB];
    //    [self.carNumberLB mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.driverHeaderImageView.mas_right).offset(10);
    //        make.top.equalTo(self.cyStarView.mas_bottom).offset(8);
    //    }];
    //
    //    self.carTypeLB = [[UILabel alloc] init];
    //    self.carTypeLB.text = @"--------";
    //    self.carTypeLB.font = [UIFont systemFontOfSize:12];
    //    self.carTypeLB.numberOfLines = 0;
    //    [self addSubview:self.carTypeLB];
    //    [self.carTypeLB mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.carNumberLB);
    //        make.left.equalTo(self.carNumberLB.mas_right).offset(10);
    //        make.centerY.equalTo(self.carNumberLB);
    //        make.right.equalTo(self).offset(-85);
    //    }];
    
    
    self.telePhoneNumberBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.telePhoneNumberBtn setImage:[UIImage imageNamed:@"电话q"] forState:(UIControlStateNormal)];
    [self.telePhoneNumberBtn addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.telePhoneNumberBtn];
    [self.telePhoneNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.and.width.mas_offset(60);
    }];
    self.telePhoneNumberBtn.hidden = YES;
    
    self.luggage_numImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"行李"]];
    [self addSubview:self.luggage_numImageView];
    [self.luggage_numImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.driverHeaderImageView.mas_bottom).offset(15);
        make.width.and.height.mas_offset(20);
        make.left.equalTo(self.driverHeaderImageView);
    }];
    
    self.luggage_numLB = [[UILabel alloc] init];
    [self addSubview:self.luggage_numLB];
    [self.luggage_numLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.luggage_numImageView.mas_right);
        make.centerY.equalTo(self.luggage_numImageView);
    }];
    
    self.remarkLB = [[UILabel alloc] init];
    self.remarkLB.font = [UIFont systemFontOfSize:11];
    self.remarkLB.numberOfLines = 0;
    self.remarkLB.text = @"备注：就开始发生看见了对方那里是哪里发可能是尽快发你数据库的奶粉进口安东尼qerwiotuipe覅偶热加工诶如果你能够";
    [self addSubview:self.remarkLB];
    [self.remarkLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_offset(DeviceWidth - 20);
        make.top.equalTo(self.luggage_numImageView.mas_bottom).offset(15);
    }];
}
-(void)phoneAction{
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",self.driver_phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)setData:(NSDictionary *)dataDic{
    [self.driverHeaderImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"m_head"]] placeholderImage:[UIImage imageNamed:@"driver_head"]];
    self.driverNameLB.text = [NSString stringWithFormat:@"%@",dataDic[@"passenger_name"]];
    if ([dataDic[@"appraise_stars"] isKindOfClass:[NSNull class]]) {
        [self.cyStarView setViewWithNumber:0 width:10 space:2 enable:NO];
    }else{
        NSString *str = dataDic[@"appraise_stars"];
        [self.cyStarView setViewWithNumber:[str intValue] width:10 space:2 enable:NO];
    }
    //    self.carNumberLB.text = dataDic[@"vehicle_number"];
    //    self.carTypeLB.text = [NSString stringWithFormat:@"%@%@·%@",dataDic[@"vehicle_brand"],dataDic[@"vehicle_style"],dataDic[@"vehicle_color"]];
    self.remarkLB.text = [NSString stringWithFormat:@"备注:%@",dataDic[@"remark"]];
    self.driver_phone = dataDic[@"passenger_phone"];
    self.luggage_numLB.text = [NSString stringWithFormat:@"%@件",dataDic[@"luggage_num"]];
    //    self.sumNumberLB.text = [NSString stringWithFormat:@"核定载客位数%@人",dataDic[@"seat_num"]];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
