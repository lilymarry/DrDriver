//
//  ShouYeModel.h
//  DrDriver
//
//  Created by mac on 2017/6/24.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CompleteOrderModel;
@interface ShouYeModel : NSObject

@property (nonatomic, copy) NSString * driver_id;//司机ID
@property (nonatomic, copy) NSString * order_count;//总单量
@property (nonatomic, copy) NSString * today_count;//今日成交量
@property (nonatomic, copy) NSString * complete_rate;//成交率
@property (nonatomic, copy) NSString * today_complete_rate;//今日成交率
@property (nonatomic, copy) NSString * driver_account;//电话
@property (nonatomic, copy) NSString * driver_head;//头像
@property (nonatomic, copy) NSString * driver_name;//姓名
@property (nonatomic, copy) NSString * driver_sex;//性别
@property (nonatomic, copy) NSString * company_name;//所属公司
@property (nonatomic, copy) NSString * driver_balance;//余额
@property (nonatomic, copy) NSString * vehicle_number;//绑定车牌号
@property (nonatomic, strong) NSArray * unfinished_order;//未完成订单(无分页)
@property (nonatomic, strong) CompleteOrderModel * complete_order;//已完成订单
@property (nonatomic, assign) int appraise_stars;//星级
@property (nonatomic, copy) NSString * invite_code;//邀请码
@property (nonatomic, assign) NSInteger audit_state;//审核状态 1:审核中 2:已通过 3:未通过审核
@property (nonatomic, assign) NSInteger driver_class;//司机类别 1：快车司机  2：出租车司机
@property (nonatomic, strong) NSArray * journey_list;//今日行程列表
@property (nonatomic, copy) NSString *today_fee;//今日收入
@property (nonatomic, assign) NSInteger cumulate_count;//总订单量
@property (nonatomic, copy) NSString *total_page;

@property (nonatomic, copy) NSString * online_time;//今日在线时长
@property (nonatomic, copy) NSString * peak_time;//今日高峰在线时长
@property (nonatomic, copy) NSString *driver_fee;//今日金额
@property (nonatomic, copy) NSString * listen_face_state;//听单是否需要扫脸,1开启，0关闭
@property (nonatomic, copy) NSString *receipt_face_state;//接单是否需要扫脸,1开启，0关闭
@property (nonatomic, copy) NSString *driver_face_state;//是否已经认证,1已认证，0未认证
@property (nonatomic, copy) NSString *face_number;//活体检测需要的检测数量

@property (nonatomic, strong) NSArray *appoint_order;//预约或接机单
@property (nonatomic, copy) NSString *online_state;//司机上班状态
@property (nonatomic, strong)NSArray *journey_order;//即时订单列表
@property (nonatomic, strong)NSArray *travel_list;//自由行订单
@property (nonatomic, strong)NSArray *school_order;//校园拼订单
@property (nonatomic, strong)NSArray *work_order;//校园拼订单
@end
