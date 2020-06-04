//
//  ITShouYeTableViewCell.h
//  DrDriver
//
//  Created by fy on 2019/1/21.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITShouYeTableViewCell : UITableViewCell

@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)UILabel *topLineLB;

@property(nonatomic,strong)UILabel *dateLB;
@property(nonatomic,strong)UILabel *timeLB;

@property(nonatomic,strong)UILabel *startCityLB;
@property(nonatomic,strong)UILabel *endCityLB;

@property(nonatomic,strong)UIImageView *arrowImageView;

@property(nonatomic,strong)UIImageView *startImageLB;
//@property(nonatomic,strong)UILabel *startTitleLB;
@property(nonatomic,strong)UILabel *startAdLB;
@property(nonatomic,strong)UILabel *startAddressLB;

@property(nonatomic,strong)UIImageView *endImageLB;
//@property(nonatomic,strong)UILabel *endTitleLB;
@property(nonatomic,strong)UILabel *endAdLB;
@property(nonatomic,strong)UILabel *endAddressLB;

@property(nonatomic,strong)UIImageView *numberImageView;
@property(nonatomic,strong)UILabel *numberLB;
@property(nonatomic,strong)UILabel *remainderLB;

@property(nonatomic, strong)UILabel *stateLB;
@property(nonatomic, copy)NSString *state;


-(void)setDataDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
