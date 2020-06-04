//
//  TuiSongTableViewCell.m
//  DrDriver
//
//  Created by fy on 2019/7/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "TuiSongTableViewCell.h"

@implementation TuiSongTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.carTypeLB = [[UILabel alloc] init];
        self.carTypeLB.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.carTypeLB];
        
        self.timeLB = [[UILabel alloc] init];
        self.timeLB.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.timeLB];
        
        self.travelStateLB = [[UILabel alloc] init];
        self.travelStateLB.font = [UIFont systemFontOfSize:14];
        self.travelStateLB.textColor = [CYTSI colorWithHexString:@"#2488ef"];
        [self addSubview:self.travelStateLB];
        
        
        
        
        
        
        
        self.startImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trip_cell_star"]];
        [self addSubview:self.startImageView];
        
        self.startNameLB = [[UILabel alloc] init];
        self.startNameLB.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.startNameLB];
        
        self.startAddressLB = [[UILabel alloc] init];
        self.startAddressLB.font = [UIFont systemFontOfSize:12];
        self.startAddressLB.textColor = [UIColor lightGrayColor];
        [self addSubview:self.startAddressLB];
        
        self.endImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trip_cell_end"]];
        [self addSubview:self.endImageView];
        
        self.endNameLB = [[UILabel alloc] init];
        self.endNameLB.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.endNameLB];
        
        self.endAddressLB = [[UILabel alloc] init];
        self.endAddressLB.font = [UIFont systemFontOfSize:12];
        self.endAddressLB.textColor = [UIColor lightGrayColor];
        [self addSubview:self.endAddressLB];
        
        
        
        
        
        self.userDistanceLB = [[UILabel alloc] init];
        self.userDistanceLB.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.userDistanceLB];
        
        self.distanceLB = [[UILabel alloc] init];
        self.distanceLB.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.distanceLB];
        
        self.priceLB = [[UILabel alloc] init];
        self.priceLB.font = [UIFont systemFontOfSize:14];
        self.priceLB.textColor = [CYTSI colorWithHexString:@"#f5a623"];
        [self addSubview:self.priceLB];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.carTypeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(9);
        make.left.equalTo(self).mas_offset(8);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.carTypeLB);
    }];
    
    [self.travelStateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-9);
        make.top.equalTo(self.carTypeLB);
    }];
    
 
    
    [self.startImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.carTypeLB.mas_bottom).mas_offset(15);
        make.left.equalTo(self).mas_offset(8);
        make.width.and.height.mas_offset(8);
    }];
    
    [self.startNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startImageView.mas_right).mas_offset(5);
        make.centerY.equalTo(self.startImageView);
    }];
    
    [self.startAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startImageView.mas_right).mas_offset(5);
        make.top.equalTo(self.startNameLB.mas_bottom);
    }];
    
    [self.endImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startImageView.mas_bottom).mas_offset(30);
        make.left.equalTo(self).mas_offset(8);
        make.width.and.height.mas_offset(8);
    }];
    
    [self.endNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endImageView.mas_right).mas_offset(5);
        make.centerY.equalTo(self.endImageView);
    }];
    
    [self.endAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endImageView.mas_right).mas_offset(5);
        make.top.equalTo(self.endNameLB.mas_bottom);
    }];
    
    
    
    
    [self.distanceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.endAddressLB.mas_bottom).offset(15);
    }];
    
    [self.userDistanceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(8);
        make.top.equalTo(self.endAddressLB.mas_bottom).offset(15);
        make.right.equalTo(self.distanceLB.mas_left);
    }];
    
    
    [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-9);
        make.bottom.equalTo(self.userDistanceLB);
    }];
}

-(void)setDataDic:(NSDictionary *)dataDic{
    self.carTypeLB.text = dataDic[@"order_type_name"];
    self.timeLB.text = dataDic[@"ctime"];
    self.travelStateLB.text = dataDic[@"order_state"];
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
    self.priceLB.text = dataDic[@"fee"];
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
