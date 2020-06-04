//
//  CYAddressView.m
//  DrDriver
//
//  Created by mac on 2017/6/19.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "CYAddressView.h"

@implementation CYAddressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init
{
    if (self=[super init]) {
        
        [self creatMainView];//创建主要视图
        
    }
    
    return self;
}


//创建主要视图
-(void)creatMainView
{
   self.startImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"坐标-起始q"]];
    self.startImageView.frame=CGRectMake(16, 52, 25, 25);
    [self addSubview:self.startImageView];
    
    self.startLable=[[UILabel alloc]init];
    self.startLable.text=@"奉化道/大沽南路（路口）晶采大厦";
    self.startLable.numberOfLines=0;
    self.startLable.font = [UIFont systemFontOfSize:15];
    int startHeight=[CYTSI planRectHeight:@"奉化道/大沽南路（路口）晶采大厦" font:15 theWidth:DeviceWidth-46];
    [self addSubview:self.startLable];
    [self.startLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startImageView.mas_right).with.offset(3);
        make.right.equalTo(self.mas_right).with.offset(-14);
        make.top.equalTo(self.startImageView.mas_top).mas_offset(-5);
        make.height.mas_equalTo(startHeight);
    }];
    
    self.startAddressLB  = [[UILabel alloc] init];
    self.startAddressLB.font = [UIFont systemFontOfSize:10];
    self.startAddressLB.textColor = [UIColor lightGrayColor];
    [self addSubview:self.startAddressLB];
    [self.startAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startLable.mas_bottom);
        make.left.equalTo(self.startLable);
        make.right.equalTo(self).mas_offset(-3);
    }];
    
//    self.downArrowImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down_arrow"]];
//    [self addSubview:self.downArrowImageView];
//    [self.downArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(startImageView.mas_centerX);
//        make.top.equalTo(self.startAddressLB.mas_bottom).with.offset(2);
//        make.height.and.width.equalTo(@15);
//    }];
//    self.downArrowImageView.hidden = YES;
    
    self.endImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"坐标-终点q"]];
    self.endImageView.frame=CGRectMake(16, 22, 25, 25);
    [self addSubview:self.endImageView];
    [self.endImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.startImageView.mas_centerX);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
        make.top.equalTo(self.startAddressLB.mas_bottom).with.offset(10);
    }];
    
    
    self.endLable=[[UILabel alloc]init];
    self.endLable.text=@"南开区盈江里路与华宁道交口西侧63中学旁盈江西里小区";
    self.endLable.numberOfLines=0;
    self.endLable.font = [UIFont systemFontOfSize:15];
    int endHeight=[CYTSI planRectHeight:@"南开区盈江里路与华宁道交口西侧63中学旁盈江西里小区" font:15 theWidth:DeviceWidth-46];
    [self addSubview:self.endLable];
    [self.endLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endImageView.mas_right).with.offset(3);
        make.right.equalTo(self.mas_right).with.offset(-14);
        make.top.equalTo(self.endImageView.mas_top).mas_offset(-5);
        make.height.mas_equalTo(endHeight);
    }];
    
    self.endAddressLB  = [[UILabel alloc] init];
    self.endAddressLB.font = [UIFont systemFontOfSize:10];
    self.endAddressLB.textColor = [UIColor lightGrayColor];
    [self addSubview:self.endAddressLB];
    [self.endAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endLable.mas_bottom);
        make.left.equalTo(self.endLable);
        make.right.equalTo(self).mas_offset(-3);
    }];
    
    self.planeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plane"]];
    [self addSubview:self.planeImageView];
    self.planeImageView.hidden = YES;
    [self.planeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(14);
        make.top.mas_offset(10);
        make.width.and.height.mas_offset(15);
    }];
    
    self.planeLB = [[UILabel alloc] init];
    self.planeLB.textColor = [UIColor lightGrayColor];
    self.planeLB.font = [UIFont systemFontOfSize:13];
    self.planeLB.hidden = YES;
    [self addSubview:self.planeLB];
    [self.planeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.planeImageView);
        make.left.equalTo(self.planeImageView.mas_right).offset(15);
    }];
    
    self.planeDateLB = [[UILabel alloc] init];
    self.planeDateLB.textColor = [UIColor lightGrayColor];
    self.planeDateLB.font = [UIFont systemFontOfSize:13];
    self.planeDateLB.hidden = YES;
    [self addSubview:self.planeDateLB];
    [self.planeDateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.planeLB);
        make.left.equalTo(self.planeLB.mas_right).offset(15);
    }];
    
    self.dateLB = [[UILabel alloc] init];
    self.dateLB.textColor = [CYTSI colorWithHexString:@"#2488ef"];
    self.dateLB.font = [UIFont systemFontOfSize:16];
    self.dateLB.hidden = YES;
    [self addSubview:self.dateLB];
    [self.dateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_offset(10);
    }];
    
    self.remarkLB = [[UILabel alloc] init];
    self.remarkLB.text = @"";
    self.remarkLB.textColor = [UIColor lightGrayColor];
    self.remarkLB.font = [UIFont systemFontOfSize:14];
    self.remarkLB.numberOfLines = 0;
    [self addSubview:self.remarkLB];
    [self.remarkLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).mas_offset(-5);
        make.left.equalTo(@15);
        make.right.mas_offset(-15);
    }];
    
    
    
    self.cityArrowsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头"]];
    [self addSubview:self.cityArrowsImageView];
    [self.cityArrowsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).mas_offset(12);
        make.width.and.height.mas_offset(30);
    }];
    
    self.startCityLB = [[UILabel alloc] init];
    self.startCityLB.text = @"-----";
    self.startCityLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.startCityLB];
    [self.startCityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(13);
        make.top.equalTo(self).mas_offset(15);
        make.right.equalTo(self.cityArrowsImageView.mas_left).offset(-3);
    }];
    
    self.endCityLB = [[UILabel alloc] init];
    self.endCityLB.text = @"-----";
    self.endCityLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.endCityLB];
    [self.endCityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).mas_offset(-13);
        make.top.equalTo(self).mas_offset(15);
        make.left.equalTo(self.cityArrowsImageView.mas_right).mas_offset(3);
    }];
    
    self.personImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"座位"]];
    [self addSubview:self.personImageView];
    [self.personImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(16);
        make.top.equalTo(self.endAddressLB.mas_bottom).mas_offset(15);
        make.width.and.height.mas_offset(25);
    }];
    
    self.personLB = [[UILabel alloc] init];
    [self addSubview:self.personLB];
    [self.personLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.personImageView);
        make.left.equalTo(self.personImageView.mas_right).mas_offset(3);
    }];
    
    
    self.luggageLB = [[UILabel alloc] init];
    [self addSubview:self.luggageLB];
    [self.luggageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.personLB);
        make.centerX.equalTo(self).mas_offset(13);
    }];
    
    self.luggageImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"行李"]];
    [self addSubview:self.luggageImageView];
    [self.luggageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.personLB);
        make.right.equalTo(self.luggageLB.mas_left).mas_offset(-3);
        make.width.and.height.mas_offset(25);
    }];
    
    self.priceLB = [[UILabel alloc] init];
    [self addSubview:self.priceLB];
    [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.luggageLB);
        make.right.equalTo(self).mas_offset(-16);
    }];
    
    self.priceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ǯ"]];
    [self addSubview:self.priceImageView];
    [self.priceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLB);
        make.right.equalTo(self.priceLB.mas_left).mas_offset(-3);
    }];
}

-(void)setStartStr:(NSString *)startStr
{
    _startStr=startStr;
    
    _startLable.text=_startStr;
    int startHeight=[CYTSI planRectHeight:_startStr font:18 theWidth:self.startLable.frame.size.width];
    [self.startLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(startHeight);
    }];
    
}

-(void)setEndStr:(NSString *)endStr
{
    _endStr=endStr;
    
    self.endLable.text=_endStr;
    int endHeight=[CYTSI planRectHeight:_endStr font:18 theWidth:self.endLable.frame.size.width];
    [self.endLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(endHeight);
    }];
    
}

-(void)updateSpace
{
//    [self.downArrowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.startLable.mas_bottom).with.offset(-3);
//    }];
//    [self.endImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.downArrowImageView.mas_bottom).with.offset(2);
//    }];
//    [self.endLable mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.downArrowImageView.mas_bottom).with.offset(-3);
//    }];
}

@end
