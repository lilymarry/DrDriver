//
//  MineMessageTableViewCell.m
//  DrUser
//
//  Created by mac on 2017/7/5.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "MineMessageTableViewCell.h"

@implementation MineMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.shadowColor = [UIColor colorWithRed:110/255.0 green:109/255.0 blue:124/255.0 alpha:1].CGColor;//阴影颜色
    self.bgView.layer.shadowOffset = CGSizeMake(0, 3);//偏移距离
    self.bgView.layer.shadowOpacity = 0.8;//不透明度
    self.bgView.layer.shadowRadius = 5;//半径
    self.bgView.layer.cornerRadius = 10;
    [self addSubview:self.bgView];
    
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.font = [UIFont systemFontOfSize:15];
    self.titleLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.titleLB];
    
    self.detailLB = [[UILabel alloc] init];
    self.detailLB.font = [UIFont systemFontOfSize:13];
    self.detailLB.numberOfLines = 0;
    self.detailLB.textColor = [CYTSI colorWithHexString:@"#666666"];
    [self.bgView addSubview:self.detailLB];
    
    self.timeLB = [[UILabel alloc] init];
    self.timeLB.font = [UIFont systemFontOfSize:10];
    self.timeLB.textColor = [CYTSI colorWithHexString:@"#999999"];
    [self.bgView addSubview:self.timeLB];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_offset(DeviceWidth - 20);
        make.height.mas_offset(100);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.bgView).offset(15);
    }];
    
    [self.detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.top.equalTo(self.titleLB.mas_bottom).offset(15);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(10);
        make.right.equalTo(self.bgView).offset(-15);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
