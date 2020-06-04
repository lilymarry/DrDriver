//
//  MessageTableViewCell.m
//  DrUser
//
//  Created by fy on 2018/10/12.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.shadowColor = [UIColor colorWithRed:110/255.0 green:109/255.0 blue:124/255.0 alpha:1].CGColor;//阴影颜色
        self.bgView.layer.shadowOffset = CGSizeMake(0, 3);//偏移距离
        self.bgView.layer.shadowOpacity = 0.8;//不透明度
        self.bgView.layer.shadowRadius = 5;//半径
        self.bgView.layer.cornerRadius = 10;
        [self addSubview:self.bgView];
        
        self.imView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info"]];
        [self.bgView addSubview:self.imView];
        
        
        self.titleLB = [[UILabel alloc] init];
        self.titleLB.text = @"通知";
        [self.bgView addSubview:self.titleLB];
        
        
        self.detailLB = [[UILabel alloc] init];
        self.detailLB.textColor = [UIColor lightGrayColor];
        self.detailLB.font = [UIFont systemFontOfSize:15];
        [self.bgView addSubview:self.detailLB];
        
        
        self.timeLB = [[UILabel alloc] init];
        self.timeLB.font = [UIFont systemFontOfSize:13];
        self.timeLB.textColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.timeLB];
        
       
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_offset(DeviceWidth - 20);
        make.height.mas_offset(100);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.imView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.and.height.mas_offset(40);
        make.left.equalTo(self.bgView).offset(20);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imView.mas_right).offset(20);
        make.bottom.equalTo(self.bgView.mas_centerY).offset(-5);
    }];
    
    [self.detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(10);
        make.left.equalTo(self.titleLB);
        make.right.equalTo(self.bgView.mas_right).offset(-5);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(5);
        make.right.equalTo(self.bgView).offset(-10);
    }];
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
