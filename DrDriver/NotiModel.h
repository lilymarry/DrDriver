//
//  NotiModel.h
//  DrDriver
//
//  Created by mac on 2017/6/27.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotiModel : NSObject

@property (strong, nonatomic) NSString * distance;//距离
@property (strong, nonatomic) NSString * journey_mile;//路程
@property (strong, nonatomic) NSString * order_id;//订单ID
@property (strong, nonatomic) NSString * start_address;//开始地址
@property (strong, nonatomic) NSString * end_address;//结束地址
@property (strong, nonatomic) NSString * passenger_phone;//乘客电话
@property (strong, nonatomic) NSString * operate_class;//(new_order:新订单,passenger_payment:乘客已付款,passenger_cancel_order:乘客取消订单)
@property (strong, nonatomic) NSString * journey_fee;//支付金额
@property (strong, nonatomic) NSString * cancel_reason;//取消原因
@property (nonatomic,assign) NSInteger order_class;//订单类型  1:快车 2：出租车
@property (nonatomic,assign) NSInteger submit_class;//叫车类型 1:普通叫车 2:摇一摇叫车

@property (copy, nonatomic) NSString *appoint_type;//预约类型
@property (copy, nonatomic) NSString *appoint_time;//预约时间
@property (copy, nonatomic) NSString *flight_number;//航班号
@property (copy, nonatomic) NSString *flight_date;//航班日期
@property (copy, nonatomic) NSString *remark;//备注信息
@property (copy, nonatomic) NSString *refund_reason;//包车乘客取消原因
@property (copy, nonatomic) NSString *start_city;
@property (copy, nonatomic) NSString *start_name;
@property (copy, nonatomic) NSString *order_name;
@property (copy, nonatomic) NSString *travel_id;
@property (copy, nonatomic) NSString *luggage_num;
@property (copy, nonatomic) NSString *end_name;
@property (copy, nonatomic) NSString *end_city;
@property (copy, nonatomic) NSString *passenger_num;

@end
