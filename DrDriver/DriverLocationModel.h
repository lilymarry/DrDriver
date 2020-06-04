//
//  DriverLocationModel.h
//  DrDriver
//
//  Created by mac on 2017/9/15.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverLocationModel : NSObject

@property (nonatomic, assign) double driver_lng;//经度
@property (nonatomic, assign) double driver_lat;//纬度
@property (nonatomic, assign) double speed;//速度
@property (nonatomic, assign) double angle;//角度
@property (nonatomic, assign) double stime;//时间

@end
