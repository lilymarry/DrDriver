//
//  ScanCarModel.h
//  DrDriver
//
//  Created by qqqqqqq on 2018/4/28.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanCarModel : NSObject
@property (strong, nonatomic) NSString *driver_id;// 司机id
@property (strong, nonatomic) NSString *driver_name;// 司机姓名
@property (strong, nonatomic) NSString *driver_sex;// 司机性别
@property (strong, nonatomic) NSString *driver_head;// 司机头像
@property (strong, nonatomic) NSString *cumulate_count;// 总订单数量
@property (strong, nonatomic) NSString *today_count;// 今日订单数量
@property (strong, nonatomic) NSString *today_fee;// 今日收入
@property (strong, nonatomic) NSString *journey_list;//今日行程列表
@property (strong, nonatomic) NSString *ctime;// 时间
@property (strong, nonatomic) NSString *driver_price;// 金额
@property (strong, nonatomic) NSString *order_sn;//订单号
@property (strong, nonatomic) NSString *order_id;//订单id
@end
