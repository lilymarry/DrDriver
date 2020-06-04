//
//  TuiSongOrderAlertView.h
//  DrDriver
//
//  Created by fy on 2019/7/19.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuiSongOrderAlertView : UIView

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *orderView;


@property(nonatomic,strong)UILabel *carTypeLB;
@property(nonatomic,strong)UILabel *timeLB;

@property(nonatomic,strong)UIImageView *startImageView;
@property(nonatomic,strong)UILabel *startAddressLB;
@property(nonatomic,strong)UIImageView *endImageView;
@property(nonatomic,strong)UILabel *endAddressLB;

@property(nonatomic,strong)UILabel *startNameLB;
@property(nonatomic,strong)UILabel *endNameLB;

@property(nonatomic,strong)UILabel *userDistanceLB;
@property(nonatomic,strong)UILabel *distanceLB;


@property(nonatomic,strong)UIImageView *bottomImageView;
@property(nonatomic,strong)UIButton *takeOrderBtn;

@property(nonatomic,strong)UIButton *closeBtn;
-(void)setDataDic:(NSDictionary *)dataDic;

@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,copy)NSString *order_type;
@property(nonatomic,copy)NSString *appoint_type;

@property(nonatomic,copy)void (^takeOrderBlock)(NSString *order_ID,NSString *order_type,NSString *appoint_type);
@property(nonatomic,copy)void (^closeBlock)();
@end

NS_ASSUME_NONNULL_END
