//
//  ITOrderDetailTableViewCell.h
//  DrDriver
//
//  Created by fy on 2019/1/22.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYStarView.h"
#import "ITUserOrderModel.h"
#import "CYStarView.h"


NS_ASSUME_NONNULL_BEGIN

@interface ITOrderDetailTableViewCell : UITableViewCell

@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)UILabel *userNameLB;
@property(nonatomic,strong)CYStarView *cyStarView;

@property(nonatomic,strong)UILabel *stateLB;
@property(nonatomic,strong)UIButton *phoneBtn;

@property(nonatomic,strong)UILabel *userNumberLB;
@property(nonatomic,strong)UILabel *userRemarkLB;
@property(nonatomic,strong)UILabel *orderNumberLB;
@property(nonatomic,strong)UILabel *timeLB;
@property(nonatomic,strong)UILabel *priceLB;

@property(nonatomic,strong)UILabel *reasonLB;
@property(nonatomic,strong)UILabel *bottomTimeLB;

@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *confirmBtn;

-(void)setWithModel:(ITUserOrderModel *)model state:(NSString *)orderState travelStartName:(NSString *)startName tarvelEndName:(NSString *)endName;
@property(nonatomic, copy)NSString *user_phone;
@property(nonatomic, copy)NSString *order_id;
@property(nonatomic, copy)NSString *head;
@property(nonatomic, copy)NSString *name;
@property(nonatomic,copy)NSString *cust_phone;//客服电话

@property(nonatomic,copy)void (^callCustPhone)(NSString *custPhone);


@property(nonatomic,strong)void (^cancelBlock)(NSString *orderID);

@property(nonatomic,strong)void (^confirmBlock)();

@property(nonatomic,copy)NSString *state;

@property(nonatomic,strong)CYStarView *driverStarView;

@property(nonatomic,strong)UILabel *rightBottomLB;

@property(nonatomic,strong)UIView *pingjiaView;

@property(nonatomic,strong)void (^pingjiaBlock)(NSDictionary *orderDic);

@property(nonatomic,strong)UILabel *pingjiaLB;

@property(nonatomic,strong)UILabel *idCarLB;
@property(nonatomic,strong)UILabel *phoneNumberLB;

@property(nonatomic,strong)UIImageView *startDetailImageView;
@property(nonatomic,strong)UILabel *startDetailNameLB;
@property(nonatomic,strong)UILabel *startDetailAddressLB;

@property(nonatomic,strong)UIImageView *endDetailImageView;
@property(nonatomic,strong)UILabel *endDetailNameLB;
@property(nonatomic,strong)UILabel *endDetailAddressLB;

@property(nonatomic, copy)NSString *start_lat;
@property(nonatomic, copy)NSString *start_lng;

@property(nonatomic, strong)void(^userTravelBlock)(NSString *start_lat,NSString *start_lng);

@property(nonatomic,strong)UIImageView *vipImageView;
@property(nonatomic,strong)UILabel *vipLb;

@end

NS_ASSUME_NONNULL_END
