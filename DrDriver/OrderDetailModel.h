//
//  OrderDetailModel.h
//  DrDriver
//
//  Created by mac on 2017/6/26.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property (nonatomic, strong) NSString * start_address;//起始地址
@property (nonatomic, strong) NSString * end_address;//目的地
@property (nonatomic, strong) NSString * state_name;//订单状态 (journey_state为1-4时,为进行中)
@property (nonatomic, strong) NSString * ctime;//日期
@property (nonatomic, strong) NSString * m_head;//用户头像
@property (nonatomic, strong) NSString * m_card_number;
@property (nonatomic, strong) NSString * passenger_name;//用户昵称
@property (nonatomic, strong) NSString * passenger_phone;//用户手机号
@property (nonatomic, assign) NSInteger journey_state;//订单状态
@property (nonatomic, assign) NSInteger driver_appraise;//是否评价 0:未评价 1:已评价
@property (nonatomic, assign) int driver_star;//评价星级 1-5

@property (nonatomic, assign) double start_lng;//起始经度
@property (nonatomic, assign) double start_lat;//起始纬度
@property (nonatomic, assign) double end_lng;//结束经度
@property (nonatomic, assign) double end_lat;//结束纬度
@property (nonatomic, strong) NSString * actual_price;//支付金额
@property (nonatomic, strong) NSString * journey_fee;//司机收到的钱
@property (nonatomic, strong) NSString * driver_price;//包车司机收到的钱
@property (nonatomic, strong) NSString * order_id;//订单id

@property (nonatomic, strong) NSArray * locus_point;//行程轨迹点
@property (nonatomic, strong) NSString *order_sn;//订单号
@property (nonatomic, strong) NSString *pay_type;//支付方式  1 余额  2  支付宝支付   3  微信支付
@property (nonatomic, assign) NSInteger passenger_appraise;//乘客是否评价 0:未评价 1:已评价
@property (nonatomic, assign) int passenger_star;//乘客评价星级 1-5
@property (nonatomic,assign) NSInteger order_class;//订单类型  1:快车 2：出租车
@property (nonatomic,assign) NSInteger submit_class;//叫车类型 1:普通叫车 2:摇一摇叫车

@property (nonatomic, copy) NSString *flight_date;//航班日期
@property (nonatomic, copy) NSString *flight_number;// 航班号
@property (nonatomic, copy) NSString *appoint_time;//预约时间
@property (nonatomic, copy) NSString *appoint_type;//预约类型

@property (nonatomic, copy) NSString *passenger_remark;//乘客备注
@property (nonatomic, copy) NSString *remark;//乘客备注

//包车
@property(copy,nonatomic)NSString *start_city_id;//起点城市id
@property(copy,nonatomic)NSString *start_city_name;//起点城市名称
@property(copy,nonatomic)NSString *start_site_name;//起点站点名称
@property(copy,nonatomic)NSString *end_city_id;//终点城市id
@property(copy,nonatomic)NSString *end_city_name;//终点城市名称
@property(copy,nonatomic)NSString *end_site_name;//终点站点名称
@property(copy,nonatomic)NSString *order_class_name;
@property(copy,nonatomic)NSString *cust_phone;//客服电话
@end
