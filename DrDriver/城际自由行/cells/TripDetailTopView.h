//
//  TripDetailTopView.h
//  DrDriver
//
//  Created by fy on 2019/1/22.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailTopView : UIView

@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,strong)UIImageView *topArrowImageView;

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

@property(nonatomic,strong)UIButton *startMapBtn;

@property(nonatomic,strong)UIImageView *numberImageView;
@property(nonatomic,strong)UILabel *numberLB;
@property(nonatomic,strong)UILabel *remainderLB;

@property(nonatomic,strong)UILabel *bottomBGView;
@property(nonatomic,strong)UILabel *bottomTitleLB;
@property(nonatomic,strong)UILabel *bottomLineLB;

@property(nonatomic,strong)void (^startBlock)();

@property(nonatomic,strong)void (^changeBlock)();

@property(nonatomic,strong)void (^stopBlock)();

-(void)setTravelDate:(NSDictionary *)dic;

@property(nonatomic, strong) UIButton *startbtn;

@property(nonatomic, strong) UIButton *btn;

@property(nonatomic, strong) UIButton *stopBtn;

@property(nonatomic,strong) NSDictionary *dic;


@property(nonatomic,strong)void (^mapBlock)(NSDictionary *dataDic);

@property(nonatomic,strong)UIButton *findUserBtn;
@property(nonatomic,strong)UILabel *redImageLB;
@property(nonatomic,strong)UILabel *remarkLB;

@property(nonatomic,strong)void (^findUserBlock)();

-(instancetype)initWithFrame:(CGRect)frame status:(NSString *)status remain_seat:(NSString *)remain_seat;

@property(nonatomic,strong)NSArray *takeArr;
@property(nonatomic,strong)NSArray *sendArr;
@property(nonatomic,strong)UIButton *userBtn;

@property(nonatomic,strong)void(^btnBlock)(NSArray *takeArr,NSArray *sendArr);

@property(nonatomic,strong)UILabel *travelIDLB;
@end

NS_ASSUME_NONNULL_END
