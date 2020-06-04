//
//  ShouYeModel.m
//  DrDriver
//
//  Created by mac on 2017/6/24.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "ShouYeModel.h"

@implementation ShouYeModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"journey_list" : @"ScanCarModel",
             @"appoint_order":@"AppointOrder"
             };
}

@end
