//
//  SLContract.m
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/17.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "SLContract.h"

@implementation SLContract

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"details" : @"SLStudent"
    };//前边，是属性数组的名字，后边就是类名
}

@end
