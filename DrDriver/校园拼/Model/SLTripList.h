//
//  SLTripList.h
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLTripList : NSObject
@property (nonatomic, copy, readwrite) NSString * route_id;//行程id
@property (nonatomic, copy, readwrite) NSString * currdate;//行程日期
@property (nonatomic, copy, readwrite) NSString * type_name;//拼车类型名称
@property (nonatomic, copy, readwrite) NSString * travel_type_name;//上学、下学
@property (nonatomic, copy, readwrite) NSString * children;//学生姓名
@property (nonatomic, copy, readwrite) NSString * route_state;//行程状态名称
@property (nonatomic, strong, readwrite) NSArray * list;//学生信息列表
@property (nonatomic, strong, readwrite) NSArray * latlng;//经纬度列表
@property (nonatomic, copy, readwrite) NSString * travel_type;//0上学，1下学
@property (nonatomic, copy, readwrite) NSString *passenger;//乘客姓名

@end

NS_ASSUME_NONNULL_END
