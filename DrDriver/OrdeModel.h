//
//  OrdeModel.h
//  DrDriver
//
//  Created by mac on 2017/6/24.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrdeModel : NSObject

@property (nonatomic, strong) NSString * start_address;//起始地址
@property (nonatomic, strong) NSString * start_name;//起始地址
@property (nonatomic, strong) NSString * end_address;//目的地
@property (nonatomic, strong) NSString * end_name;//起始地址
@property (nonatomic, strong) NSString * state_name;//订单状态 (journey_state为1-4时,为进行中)
@property (nonatomic, strong) NSString * ctime;//日期
@property (nonatomic, strong) NSString * order_id;//订单id
@property (nonatomic, strong) NSString * order_type;//订单类型
@property (nonatomic, assign) NSInteger journey_state;//订单状态  0:待抢单1:待到达出发地2:待上车3:待送达4:待付款5:已完成7:用户取消8:司机取消9:无司机接单

@property (nonatomic, strong) NSString * journey_fee;//快车费用
@property (nonatomic,assign) NSInteger order_class;//订单类型  1:快车 2：出租车 3：扫码车
@property (nonatomic,assign) NSInteger submit_class;//叫车类型 1:普通叫车 2:摇一摇叫车

//抢单成功返回
@property (nonatomic, assign) double start_lng;//起始地经度
@property (nonatomic, assign) double start_lat;//起始地纬度
@property (nonatomic, assign) double end_lng;//目的地经度
@property (nonatomic, assign) double end_lat;//目的地纬度
//@property (nonatomic, strong) NSString * end_lat;//乘客头像
@property (nonatomic, strong) NSString * passenger_name;//乘客名称
//@property (nonatomic, strong) NSString * end_lat;//乘客完成单数
@property (nonatomic, strong) NSString * passenger_phone;//乘客电话
@property (nonatomic, strong) NSString * m_card_number;
@property (nonatomic, strong) NSString * m_head;//乘客头像
@property (nonatomic, strong) NSString * actual_price;
@property (nonatomic, strong) NSString *order_sn;//订单编号
@property (nonatomic, copy) NSString *driver_face_state;//时候扫脸认证

@property (nonatomic, copy) NSString *appoint_type;//预约类型 0及时单 1预约单 2接机单
@property (copy, nonatomic) NSString *appoint_time;//预约的时间
@property (copy, nonatomic) NSString *flight_number;//航班号
@property (copy, nonatomic) NSString *remark;//备注
@property(copy,nonatomic)NSString *flight_date;


//包车
@property(copy,nonatomic)NSString *start_city_id;//起点城市id
@property(copy,nonatomic)NSString *start_city_name;//起点城市名称
@property(copy,nonatomic)NSString *start_site_name;//起点站点名称
@property(copy,nonatomic)NSString *end_city_id;//终点城市id
@property(copy,nonatomic)NSString *end_city_name;//终点城市名称
@property(copy,nonatomic)NSString *end_site_name;//终点站点名称
@end
