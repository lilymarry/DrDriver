//
//  ITUserOrderModel.h
//  DrDriver
//
//  Created by fy on 2019/1/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITUserOrderModel : NSObject

@property (nonatomic, copy) NSString * order_id;
@property (nonatomic, copy) NSString * order_sn;
@property (nonatomic, copy) NSString * m_head;
@property (nonatomic, copy) NSString * m_phone;
@property (nonatomic, copy) NSString * m_name;
@property (nonatomic, copy) NSString * appraise_stars;
@property (nonatomic, copy) NSString * passenger_num;
@property (nonatomic, copy) NSString * actual_money;
@property (nonatomic, copy) NSString * pay_type_name;
@property (nonatomic, copy) NSString * ctime;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * order_state;
@property (nonatomic, copy) NSString * state_name;
@property (nonatomic, copy) NSString * aboard_time;
@property(nonatomic, copy) NSString *driver_cancel_reason;
@property(nonatomic, copy) NSString *user_cancel_reason;
@property(nonatomic, copy) NSString *driver_star;
@property(nonatomic, copy) NSString *driver_reason;
@property(nonatomic, copy) NSString *driver_appraise;
@property(nonatomic, copy) NSString *driver_money;

@property(nonatomic, copy) NSString *start_name;
@property(nonatomic, copy) NSString *start_address;
@property(nonatomic, copy) NSString *end_name;
@property(nonatomic, copy) NSString *end_address;

@property(nonatomic, copy) NSString *start_lat;
@property(nonatomic, copy) NSString *start_lng;

@property(nonatomic, copy) NSString *start_distance;
@property(nonatomic, copy) NSString *end_distance;

@property(nonatomic, copy) NSString *luggage_num;
@property(nonatomic, copy) NSString *is_baoche;

@property(nonatomic, copy) NSString *state;

@property(nonatomic, copy) NSString *end_lat;
@property(nonatomic, copy) NSString *end_lng;

@property(nonatomic, copy) NSString *cust_phone;
@property(nonatomic, copy) NSString *m_card_number;
@property(nonatomic, copy) NSString *passenger_phone;
@property(nonatomic, copy) NSString *vip_name;
@end

NS_ASSUME_NONNULL_END
