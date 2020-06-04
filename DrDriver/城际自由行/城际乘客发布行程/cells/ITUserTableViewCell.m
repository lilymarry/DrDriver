//
//  ITUserTableViewCell.m
//  DrUser
//
//  Created by fy on 2019/2/21.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITUserTableViewCell.h"

@implementation ITUserTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = TABLEVIEW_BACKCOLOR;
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
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
        self.startAdLB.text = @"--";
        self.startAdLB.font = [UIFont systemFontOfSize:15];
        self.startAdLB.textColor = [CYTSI colorWithHexString:@"#333333"];
        [self.bgView addSubview:self.startAdLB];
        
        self.startAddressLB = [[UILabel alloc] init];
        self.startAddressLB.text = @"------";
        self.startAddressLB.font = [UIFont systemFontOfSize:9];
        self.startAddressLB.textColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.startAddressLB];
        
        self.endImageLB  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"坐标-终点q"]];
        [self.bgView addSubview:self.endImageLB];
        
        self.endAdLB = [[UILabel alloc] init];
        self.endAdLB.text = @"--";
        self.endAdLB.font = [UIFont systemFontOfSize:15];
        self.endAdLB.textColor = [CYTSI colorWithHexString:@"#333333"];
        [self.bgView addSubview:self.endAdLB];
        
        self.endAddressLB = [[UILabel alloc] init];
        self.endAddressLB.text = @"------";
        self.endAddressLB.font = [UIFont systemFontOfSize:9];
        self.endAddressLB.textColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.endAddressLB];
        
//        self.priceLB = [[UILabel alloc] init];
//        self.priceLB.text = @"--元/人";
//        self.priceLB.font = [UIFont systemFontOfSize:15];
//        self.priceLB.textColor = [CYTSI colorWithHexString:@"#333333"];
//        [self.bgView addSubview:self.priceLB];
//
//        self.sumPriceLB = [[UILabel alloc] init];
//        self.sumPriceLB.text = @"一口价包车--元";
//        self.sumPriceLB.font = [UIFont systemFontOfSize:15];
//        self.sumPriceLB.textColor = [CYTSI colorWithHexString:@"#f5a623"];
//        [self.bgView addSubview:self.sumPriceLB];
        
    }
    return self;
}
-(void)layoutSubviews{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.mas_offset(2);
        make.width.mas_offset(DeviceWidth);
    }];
    
    
    
    [self.startCityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.bgView).offset(10);
    }];
    
    [self.endCityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.top.equalTo(self.bgView).offset(10);
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
    
    
//    [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bgView).offset(15);
//        make.top.equalTo(self.endImageLB.mas_bottom).offset(15);
//    }];
//
//    [self.sumPriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.bgView.mas_right).offset(-15);
//        make.centerY.equalTo(self.priceLB);
//    }];
    
}
-(void)setData:(NSDictionary *)dic{
    self.startCityLB.text = [NSString stringWithFormat:@"%@%@",dic[@"start_city"],dic[@"start_county"]];
    self.endCityLB.text = [NSString stringWithFormat:@"%@%@",dic[@"end_city"],dic[@"end_county"]];
    self.startAdLB.text = [NSString stringWithFormat:@"%@",dic[@"start_name"]];
    self.startAddressLB.text = dic[@"start_address"];
    self.endAdLB.text = [NSString stringWithFormat:@"%@",dic[@"end_name"]];
    self.endAddressLB.text = dic[@"end_address"];
//    self.priceLB.text = [NSString stringWithFormat:@"%@元/位",dic[@"driver_price"]];
//    self.sumPriceLB.text = [NSString stringWithFormat:@"一口价包车%@元",dic[@"driver_fixed_price"]];
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
