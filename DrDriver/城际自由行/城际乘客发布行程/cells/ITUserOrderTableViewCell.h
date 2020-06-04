//
//  ITUserOrderTableViewCell.h
//  DrDriver
//
//  Created by fy on 2019/2/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITUserOrderTableViewCell : UITableViewCell

@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)UILabel *startCityLB;
@property(nonatomic,strong)UILabel *endCityLB;

@property(nonatomic,strong)UIImageView *arrowImageView;

@property(nonatomic,strong)UIImageView *startImageLB;
@property(nonatomic,strong)UILabel *startAdLB;
@property(nonatomic,strong)UILabel *startAddressLB;

@property(nonatomic,strong)UIImageView *endImageLB;
@property(nonatomic,strong)UILabel *endAdLB;
@property(nonatomic,strong)UILabel *endAddressLB;

@property(nonatomic,strong)UILabel *numberLB;
@property(nonatomic,strong)UILabel *sumPriceLB;

@property(nonatomic,strong)UILabel *timeLB;

-(void)setData:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
