//
//  ITDriverModel.h
//  DrDriver
//
//  Created by fy on 2019/1/24.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITDriverModel : NSObject

@property (nonatomic, copy) NSString * driver_id;
@property (nonatomic, copy) NSString * cumulate_count;
@property (nonatomic, copy) NSString * complete_rate;
@property (nonatomic, copy) NSString * driver_account;
@property (nonatomic, copy) NSString * driver_head;
@property (nonatomic, copy) NSString * driver_name;
@property (nonatomic, copy) NSString * driver_sex;
@property (nonatomic, copy) NSString * company_name;
@property (nonatomic, copy) NSString * balance;
@property (nonatomic, copy) NSString * appraise_stars;
@property (nonatomic, copy) NSString * vehicle_number;
@property (nonatomic, copy) NSString * invite_code;
@property (nonatomic, assign) NSInteger audit_state;//审核状态 1:审核中 2:已通过 3:未通过审核
@property (nonatomic, assign) NSInteger driver_class;//司机类别 1：快车司机  2：出租车司机
@property (nonatomic, strong) NSArray * today_list;
@property (nonatomic, strong) NSArray * tomorrow_list;
@property (nonatomic, strong) NSArray * travel_list;

@end

NS_ASSUME_NONNULL_END
