//
//  PriceDistanceModel.h
//  DrDriver
//
//  Created by mac on 2017/9/7.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceDistanceModel : NSObject

@property (nonatomic, strong) NSString * journey_fee;//打车费用
@property (nonatomic, strong) NSString * real_journey_time;//实时行驶时间
@property (nonatomic, strong) NSString * real_journey_fee;//实时打车费用
@property (nonatomic, strong) NSString * real_journey_mile;//实时行驶距离

//现金支付返回(journey_fee:应向客户收取费用)
@property (nonatomic, strong) NSString * service_fee;//平台服务费

@end
