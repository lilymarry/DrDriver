//
//  SLContract.h
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/17.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SLStudent;
NS_ASSUME_NONNULL_BEGIN

@interface SLContract : NSObject

@property (nonatomic, copy, readwrite) NSString * contract_id;//合约id
@property (nonatomic, copy, readwrite) NSString * type_name;//用车类型名称
@property (nonatomic, copy, readwrite) NSString * startdate;//开始日期
@property (nonatomic, copy, readwrite) NSString * enddate;//结束日期
@property (nonatomic, copy, readwrite) NSString * state_name;//合约状态名称
@property (nonatomic, copy, readwrite) NSString * children;//孩子姓名
@property (nonatomic, strong, readwrite) NSArray * details;//孩子详情
@property (nonatomic, copy, readwrite) NSString * state;//合约状态
@property (nonatomic, copy, readwrite) NSString *passenger;//乘客

@end

NS_ASSUME_NONNULL_END
