//
//  SchoolFirstViewCell.m
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/14.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "SchoolViewCell.h"
#import "SLContract.h"
#import "SLTripList.h"
@interface SchoolViewCell ()
@property (nonatomic, strong, readwrite) UIView *BgView;//白色背景
@property (nonatomic, strong, readwrite) UILabel *timeLabel;//时间
@property (nonatomic, strong, readwrite) UILabel *peopleLabel;//几人拼
@property (nonatomic, strong, readwrite) UILabel *statuLabel;//状态
@property (nonatomic, strong, readwrite) UILabel *nameLabel;//拼车姓名
@property (nonatomic, strong, readwrite) UIImageView *circleImageView;//原型图片

@end

@implementation SchoolViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = TABLEVIEW_BACKCOLOR;
        self.BgView = [[UIView alloc] init];
        self.BgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.BgView];
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.text = @"----------";
        self.timeLabel.textColor = [UIColor darkGrayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:16];
        [self.BgView addSubview:self.timeLabel];
        self.peopleLabel = [[UILabel alloc] init];
        self.peopleLabel.text = @"-------";
        self.peopleLabel.textColor = [UIColor darkGrayColor];
        self.peopleLabel.font = [UIFont systemFontOfSize:14];
        [self.BgView addSubview:self.peopleLabel];
        self.statuLabel = [[UILabel alloc] init];
        self.statuLabel.text = @"-----";
        self.statuLabel.textColor = CATECOLOR_SELECTED ;
        self.statuLabel.font = [UIFont systemFontOfSize:16];
        [self.BgView addSubview:self.statuLabel];
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.text = @"----------";
        self.nameLabel.textColor = [UIColor grayColor];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self.BgView addSubview:self.nameLabel];
        self.circleImageView = [[UIImageView alloc] init];
        self.circleImageView.image = [UIImage imageNamed:@"yuan"];
        [self.BgView addSubview:self.circleImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.BgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        make.top.mas_equalTo(self.mas_top).mas_offset(10);
    }];
    [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_left).mas_offset(15);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(15);
        make.width.and.height.mas_equalTo(8);
    }];
    [self.peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.circleImageView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.circleImageView.mas_centerY);
    }];
    [self.statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        make.centerY.mas_equalTo(self.circleImageView.mas_centerY);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_left);
        make.right.mas_equalTo(self.timeLabel.mas_right);
        make.top.mas_equalTo(self.circleImageView.mas_top).mas_offset(20);
    }];
}

/// 合同列表显示内容
/// @param contract  数据
- (void)setContract:(SLContract *)contract{
    _contract = contract;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@——%@",_contract.startdate,_contract.enddate];
    self.peopleLabel.text = [NSString stringWithFormat:@"%@",_contract.type_name];
    if ([_contract.state isEqualToString:@"2"]) {
        self.statuLabel.textColor = CATECOLOR_SELECTED;
    }else{
        self.statuLabel.textColor = [UIColor grayColor];
    }
    self.statuLabel.text = _contract.state_name;
    if ([_contract.passenger isEqualToString:@""]||_contract.passenger == nil) {
        self.nameLabel.text = [NSString stringWithFormat:@"学生——%@",_contract.children];
        
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"乘车人——%@",_contract.passenger];
        
      }
}

/// 行程列表
/// @param tripList 数据
- (void)setTripList:(SLTripList *)tripList{
    _tripList = tripList;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@  %@",_tripList.currdate,_tripList.travel_type_name];
    self.peopleLabel.text = [NSString stringWithFormat:@"%@",_tripList.type_name];
    if ([_tripList.route_state isEqualToString:@"进行中"]) {
           self.statuLabel.textColor = CATECOLOR_SELECTED;
       }else{
           self.statuLabel.textColor = [UIColor grayColor];
       }
    self.statuLabel.text = _tripList.route_state;
    if ([_tripList.passenger isEqualToString:@""]||_tripList.passenger == nil) {
        self.nameLabel.text = [NSString stringWithFormat:@"学生——%@",_tripList.children];
    }else{
         self.nameLabel.text = [NSString stringWithFormat:@"乘车人：%@",_tripList.passenger];
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
