//
//  SLStudent.h
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/17.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SLStudent : NSObject
@property (nonatomic, copy, readwrite) NSString * detail_id;//合约id
@property (nonatomic, copy, readwrite) NSString * home_name;//家庭住址名称
@property (nonatomic, copy, readwrite) NSString * home_address;//家庭住址详细地址
@property (nonatomic, copy, readwrite) NSString * home_lat;//家庭住址纬度
@property (nonatomic, copy, readwrite) NSString * home_lng;//家庭住址经度
@property (nonatomic, copy, readwrite) NSString * school_name;//学校名称
@property (nonatomic, copy, readwrite) NSString * school_address;//学校详细地址
@property (nonatomic, copy, readwrite) NSString * school_lat;//学校纬度
@property (nonatomic, copy, readwrite) NSString * school_lng;//学校经度
@property (nonatomic, copy, readwrite) NSString * driver_id;//合约id
@property (nonatomic, copy, readwrite) NSString * pay_time;//付款时间
@property (nonatomic, copy, readwrite) NSString * pay_type_name;//支付方式名称
@property (nonatomic, copy, readwrite) NSString * price;//支付金额 元
@property (nonatomic, copy, readwrite) NSString * child_name;//小孩姓名
@property (nonatomic, copy, readwrite) NSString * child_sex;//小孩性别，1男 2女
@property (nonatomic, copy, readwrite) NSString * child_age;//小孩年龄
@property (nonatomic, copy, readwrite) NSString * child_pic;//孩子照片
@property (nonatomic, copy, readwrite) NSString * parent_phone;//联系家长
@property (nonatomic, strong, readwrite) NSArray * week_time;


//校园拼行程详情
@property (nonatomic, copy, readwrite) NSString * order_id;//订单id
@property (nonatomic, copy, readwrite) NSString * route_id;//行程id
@property (nonatomic, copy, readwrite) NSString * travel_type;//0上学，1下学
@property (nonatomic, copy, readwrite) NSString *order_state_name;//订单状态名称
@property (nonatomic, copy, readwrite) NSString *order_state;//订单状态，0：司机未发车，1司机未到达，2未上车，3已上车，4行程中，5司机已送达，6家长确认送达，7司机取消，8乘客取消，9陪伴中
@property (nonatomic, copy, readwrite) NSString *start_name;//
@property (nonatomic, copy, readwrite) NSString *start_address;//
@property (nonatomic, copy, readwrite) NSString *end_name;//
@property (nonatomic, copy, readwrite) NSString *end_address;//
@property (nonatomic, copy, readwrite) NSString *school_time;//上学或下学时间点
@property (nonatomic, copy, readwrite) NSString * passenger_phone;//家长手机号
@property (nonatomic, copy, readwrite) NSString * start_lat;//
@property (nonatomic, copy, readwrite) NSString * start_lng;//
@property (nonatomic, copy, readwrite) NSString * end_lat;//
@property (nonatomic, copy, readwrite) NSString * end_lng;//

//上学拍照
@property (nonatomic, copy, readwrite) NSString * aboard_pic;//上车照片
@property (nonatomic, copy, readwrite) NSString * debus_pic;//下车照片
@property (nonatomic, copy, readwrite) NSString *accompany_type;//大于0，隐藏下学黄色按钮
@property (nonatomic, copy, readwrite) NSString * arrive_time;//司机到达上车点的时间


//通勤行
@property (nonatomic, copy, readwrite) NSString *m_name;//乘客姓名
@property (nonatomic, copy, readwrite) NSString *company_name;//公司名称
@property (nonatomic, copy, readwrite) NSString *company_address;//公司地址
@property (nonatomic, copy, readwrite) NSString *company_lat;//公司纬度
@property (nonatomic, copy, readwrite) NSString *company_lng;//公司经度
@property (nonatomic, copy, readwrite) NSString *work_time;//上班或下班时间点
@end

NS_ASSUME_NONNULL_END
