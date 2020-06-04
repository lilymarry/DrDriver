//
//  ITOrderDetailView.h
//  DrUser
//
//  Created by fy on 2019/1/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITOrderDetailView : UIView

@property(nonatomic,strong)UILabel *startCityLB;
@property(nonatomic,strong)UILabel *endCityLB;

@property(nonatomic,strong)UIImageView *arrowImageView;

@property(nonatomic,strong)UIImageView *startImageLB;
@property(nonatomic,strong)UILabel *startAdLB;
@property(nonatomic,strong)UILabel *startAddressLB;

@property(nonatomic,strong)UIImageView *endImageLB;
@property(nonatomic,strong)UILabel *endAdLB;
@property(nonatomic,strong)UILabel *endAddressLB;

@property(nonatomic,strong)UILabel *timeLB;

@property(nonatomic,strong)UILabel *priceLB;
//@property(nonatomic,strong)UILabel *sumPriceLB;

@property(nonatomic,strong)UIButton *startMapBtn;
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,copy)NSString *state;

@property(nonatomic,strong)void (^mapBlock)(NSDictionary *dataDic);


-(void)setData:(NSDictionary *)dic;

@property(nonatomic,strong)UILabel *startAcrossLine;
@property(nonatomic,strong)UILabel *startVerticalLine;
@property(nonatomic,strong)UIImageView *startDetailImageView;
@property(nonatomic,strong)UILabel *startDetailNameLB;
@property(nonatomic,strong)UILabel *startDetailAddressLB;

@property(nonatomic,strong)UILabel *endAcrossLine;
@property(nonatomic,strong)UILabel *endVerticalLine;
@property(nonatomic,strong)UIImageView *endDetailImageView;
@property(nonatomic,strong)UILabel *endDetailNameLB;
@property(nonatomic,strong)UILabel *endDetailAddressLB;

@end

NS_ASSUME_NONNULL_END
