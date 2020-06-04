//
//  CYAddressView.h
//  DrDriver
//
//  Created by mac on 2017/6/19.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYAddressView : UIView

@property (nonatomic,strong) NSString * startStr;//开始位置
@property (nonatomic,strong) NSString * endStr;//结束位置
@property (nonatomic,strong) UILabel * startLable;//开始位置label
@property(nonatomic,strong)UILabel *startAddressLB;
@property (nonatomic,strong) UILabel * endLable;//结束位置label
@property(nonatomic,strong)UILabel *endAddressLB;

//@property (nonatomic,strong) UIImageView * downArrowImageView;
@property (nonatomic,strong) UIImageView * endImageView;

@property(nonatomic,strong)UIImageView *planeImageView;
@property(nonatomic,copy)NSString *planeString;
@property(nonatomic,strong)UILabel *planeLB;//接机航班号
@property(nonatomic,strong)UILabel *planeDateLB;//接机日期
@property(nonatomic,strong)UILabel *dateLB;//预约日期
@property(nonatomic,strong)UILabel *remarkLB;//备注
@property(nonatomic,strong)UIImageView * startImageView;


@property(nonatomic,strong)UILabel *startCityLB;
@property(nonatomic,strong)UILabel *endCityLB;
@property(nonatomic,strong)UIImageView *cityArrowsImageView;

@property(nonatomic,strong)UIImageView *personImageView;
@property(nonatomic,strong)UILabel *personLB;

@property(nonatomic,strong)UIImageView *luggageImageView;
@property(nonatomic,strong)UILabel *luggageLB;

@property(nonatomic,strong)UIImageView *priceImageView;
@property(nonatomic,strong)UILabel *priceLB;


-(void)updateSpace;

@end
