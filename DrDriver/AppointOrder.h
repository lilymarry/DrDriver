//
//  AppointOrder.h
//  DrDriver
//
//  Created by qqqqqqq on 2018/9/25.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointOrder : NSObject
@property (strong, nonatomic) NSString *order_id;//订单ID
@property (strong, nonatomic) NSString *start_address;//起始地
@property (strong, nonatomic) NSString *end_address;//目的地
@property (strong, nonatomic) NSString *state_name;//订单状态名称
@property (strong, nonatomic) NSString *appoint_type;//预约类型：1预约单，2接机单
@property (strong, nonatomic) NSString *ctime;//预约的时间
@property (strong, nonatomic) NSString *flight_number;//航班号

@end
