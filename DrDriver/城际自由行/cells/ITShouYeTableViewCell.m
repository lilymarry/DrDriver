//
//  ITShouYeTableViewCell.m
//  DrDriver
//
//  Created by fy on 2019/1/21.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITShouYeTableViewCell.h"


@implementation ITShouYeTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = TABLEVIEW_BACKCOLOR;
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        self.topLineLB = [[UILabel alloc] init];
        self.topLineLB.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.topLineLB];
        
        self.dateLB = [[UILabel alloc] init];
        self.dateLB.text = @"----年--月--日";
        self.dateLB.font = [UIFont systemFontOfSize:15];
        self.dateLB.textColor = [CYTSI colorWithHexString:@"#333333"];
        [self.bgView addSubview:self.dateLB];
        
        self.timeLB = [[UILabel alloc] init];
        self.timeLB.text = @"发车时间 --:--";
        self.timeLB.font = [UIFont systemFontOfSize:15];
        self.timeLB.textColor = [CYTSI colorWithHexString:@"#333333"];
        [self.bgView addSubview:self.timeLB];
        
        self.startCityLB = [[UILabel alloc] init];
        self.startCityLB.text = @"--";
        self.startCityLB.font = [UIFont systemFontOfSize:15];
        self.startCityLB.textColor = [CYTSI colorWithHexString:@"#333333"];
        [self.bgView addSubview:self.startCityLB];
        
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头"]];
        [self.bgView addSubview:self.arrowImageView];
        
        self.endCityLB = [[UILabel alloc] init];
        self.endCityLB.text = @"--";
        self.endCityLB.font = [UIFont systemFontOfSize:15];
        self.endCityLB.textColor = [CYTSI colorWithHexString:@"#333333"];
        [self.bgView addSubview:self.endCityLB];
        
        self.startImageLB  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"坐标-起始q"]];
        [self.bgView addSubview:self.startImageLB];
        
        
        self.startAdLB = [[UILabel alloc] init];
        self.startAdLB.text = @"---------";
        self.startAdLB.font = [UIFont systemFontOfSize:15];
        self.startAdLB.textColor = [CYTSI colorWithHexString:@"#333333"];
        [self.bgView addSubview:self.startAdLB];
        
        self.startAddressLB = [[UILabel alloc] init];
        self.startAddressLB.text = @"-------------------------";
        self.startAddressLB.font = [UIFont systemFontOfSize:9];
        self.startAddressLB.textColor = [CYTSI colorWithHexString:@"#999999"];
        [self.bgView addSubview:self.startAddressLB];
        
        self.endImageLB  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"坐标-终点q"]];
        [self.bgView addSubview:self.endImageLB];
        
        
        self.endAdLB = [[UILabel alloc] init];
        self.endAdLB.text = @"---------";
        self.endAdLB.font = [UIFont systemFontOfSize:15];
        self.endAdLB.textColor = [CYTSI colorWithHexString:@"#333333"];
        [self.bgView addSubview:self.endAdLB];
        
        self.endAddressLB = [[UILabel alloc] init];
        self.endAddressLB.text = @"-------------------------";
        self.endAddressLB.font = [UIFont systemFontOfSize:9];
        self.endAddressLB.textColor = [CYTSI colorWithHexString:@"#999999"];
        [self.bgView addSubview:self.endAddressLB];
        
        self.numberImageView = [[UIImageView alloc] init];
        self.numberImageView.image = [UIImage imageNamed:@"座位"];
        [self.bgView addSubview:self.numberImageView];
        
        self.numberLB = [[UILabel alloc] init];
        self.numberLB.text = @"已定乘客 -- 位";
        self.numberLB.font = [UIFont systemFontOfSize:15];
        self.numberLB.textColor = [CYTSI colorWithHexString:@"#333333"];
        [self.bgView addSubview:self.numberLB];
        
        self.remainderLB = [[UILabel alloc] init];
        self.remainderLB.text = @"剩余座位 -- 位";
        self.remainderLB.font = [UIFont systemFontOfSize:15];
        self.remainderLB.textColor = [CYTSI colorWithHexString:@"#333333"];
        [self.bgView addSubview:self.remainderLB];
        
        self.stateLB = [[UILabel alloc] init];
        self.stateLB.text = @"-----";
        self.stateLB.backgroundColor = [CYTSI colorWithHexString:@"#2488ef"];
        self.stateLB.textColor  = [UIColor whiteColor];
        self.stateLB.layer.cornerRadius=5;
        self.stateLB.layer.masksToBounds = YES;
        self.stateLB.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.stateLB];
    }
    return self;
}
-(void)layoutSubviews{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.mas_offset(0);
        make.width.mas_offset(DeviceWidth);
    }];
    
    [self.topLineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(1);
        make.width.mas_offset(DeviceWidth);
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    [self.dateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.bgView).offset(10);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.top.equalTo(self.bgView).offset(10);
    }];
    
    
    [self.startCityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLB.mas_bottom).offset(10);
        make.left.equalTo(self.bgView).offset(15);
    }];
    
    [self.endCityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.top.equalTo(self.dateLB.mas_bottom).offset(10);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.centerY.equalTo(self.startCityLB);
        make.width.and.height.mas_offset(30);
    }];
    
    
    
    [self.startImageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_offset(25);
        make.top.equalTo(self.startCityLB.mas_bottom).offset(15);
        make.left.equalTo(self.bgView).offset(10);
    }];
    
    
    [self.startAdLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startImageLB.mas_right).offset(7);
        make.centerY.equalTo(self.startImageLB.mas_centerY).offset(-3);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
    [self.startAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startImageLB.mas_right).offset(7);
        make.top.equalTo(self.startAdLB.mas_bottom);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
    
    
    [self.endImageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_offset(25);
        make.top.equalTo(self.startImageLB.mas_bottom).offset(15);
        make.left.equalTo(self.bgView).offset(10);
    }];
    
    
    [self.endAdLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endImageLB.mas_right).offset(7);
        make.centerY.equalTo(self.endImageLB.mas_centerY).offset(-3);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
    [self.endAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endImageLB.mas_right).offset(7);
        make.top.equalTo(self.endAdLB.mas_bottom);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
    
    [self.numberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(10);
        make.top.equalTo(self.endAddressLB.mas_bottom).offset(15);
        make.width.and.height.mas_offset(20);
    }];
    
    [self.numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberImageView.mas_right).offset(5);
        make.centerY.equalTo(self.numberImageView);
    }];
    
    [self.remainderLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.centerY.equalTo(self.numberLB);
    }];
    
    [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.endAddressLB.mas_bottom).offset(45);
        make.height.mas_offset(30);
        make.width.mas_offset(DeviceWidth - 30);
    }];
    
}
-(void)setDataDic:(NSDictionary *)dic{
    self.dateLB.text = dic[@"travel_date"];
    self.timeLB.text = [NSString stringWithFormat:@"发车时间 %@",dic[@"travel_time"]];
    self.startCityLB.text = [NSString stringWithFormat:@"%@%@",dic[@"start_city"],dic[@"start_county"]];
    self.endCityLB.text = [NSString stringWithFormat:@"%@%@",dic[@"end_city"],dic[@"end_county"]];
    self.startAdLB.text = dic[@"start_name"];
    self.startAddressLB.text = dic[@"start_address"];
    self.endAdLB.text = dic[@"end_name"];
    self.endAddressLB.text = dic[@"end_address"];
    if ([dic[@"fix_num"] isKindOfClass:[NSNull class]]) {
        self.numberLB.text = @"已定乘客0位";
    }else{
        self.numberLB.text = [NSString stringWithFormat:@"已定乘客%@位",dic[@"fix_num"]];
    }
    self.remainderLB.text = [NSString stringWithFormat:@"剩余座位%@位",dic[@"remain_seat"]];
    self.stateLB.text = dic[@"state"];
    self.stateLB.backgroundColor = [CYTSI colorWithHexString:@"#2488ef"];
    self.stateLB.textColor  = [UIColor whiteColor];
    if ([dic[@"state"] isEqualToString:@"待发车"] || [dic[@"state"] isEqualToString:@"暂无用户叫车"]) {
        self.numberLB.hidden = NO;
        self.remainderLB.hidden = NO;
        self.numberImageView.hidden = NO;
        if ([dic[@"fix_num"] isKindOfClass:[NSNull class]]) {
            self.numberLB.text = @"已定乘客0位";
        }else{
            self.numberLB.text = [NSString stringWithFormat:@"已定乘客%@位",dic[@"fix_num"]];
        }
//        [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.endAddressLB.mas_bottom).offset(45);
//        }];
        self.remainderLB.text = [NSString stringWithFormat:@"剩余座位%@位",dic[@"remain_seat"]];
    }else if ([dic[@"state"] isEqualToString:@"行程中"]){
        self.numberLB.hidden = YES;
        self.remainderLB.hidden = YES;
        self.numberImageView.hidden = YES;
        //        [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.endAddressLB.mas_bottom).offset(15);
        //        }];
    }else if([dic[@"state"] isEqualToString:@"行程已结束"]){
        self.numberLB.hidden = YES;
        self.remainderLB.hidden = YES;
        self.numberImageView.hidden = YES;
        //        [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.endAddressLB.mas_bottom).offset(15);
        //        }];
    }else if([dic[@"state"] isEqualToString:@"司机异常取消"]){
        self.numberLB.hidden = YES;
        self.remainderLB.hidden = YES;
        self.numberImageView.hidden = YES;
        //        [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.endAddressLB.mas_bottom).offset(15);
        //        }];
        self.stateLB.text = @"已取消";
        self.stateLB.textColor = [UIColor whiteColor];
        self.stateLB.backgroundColor = [UIColor lightGrayColor];
    }else if([dic[@"state"] isEqualToString:@"已完成"]){
        self.numberLB.hidden = YES;
        self.remainderLB.hidden = YES;
        self.numberImageView.hidden = YES;
        self.stateLB.textColor = [UIColor whiteColor];
        self.stateLB.backgroundColor = [UIColor lightGrayColor];
        //        [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.endAddressLB.mas_bottom).offset(15);
        //        }];
    }else if([dic[@"state"] isEqualToString:@"已取消"]){
        self.numberLB.hidden = YES;
        self.remainderLB.hidden = YES;
        self.numberImageView.hidden = YES;
        self.stateLB.textColor = [UIColor whiteColor];
        self.stateLB.backgroundColor = [UIColor lightGrayColor];
        //        [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.endAddressLB.mas_bottom).offset(15);
        //        }];
    }else{
        self.numberLB.hidden = YES;
        self.remainderLB.hidden = YES;
        self.numberImageView.hidden = YES;
        //        [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.endAddressLB.mas_bottom).offset(15);
        //        }];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
