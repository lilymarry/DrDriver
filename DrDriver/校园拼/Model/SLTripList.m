
//
//  SLTripList.m
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "SLTripList.h"

@implementation SLTripList
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"list":@"SLStudent",
             @"latlng":@"Latlng"
    };//前边，是属性数组的名字，后边就是类名
}
@end
