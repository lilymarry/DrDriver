//
//  DriverModel.h
//  DrDriver
//
//  Created by mac on 2017/6/24.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverModel : NSObject

@property (nonatomic, strong) NSString * driver_id;//司机ID
@property (nonatomic, strong) NSString * driver_account;//电话
@property (nonatomic, strong) NSString * driver_head;//用户昵称
@property (nonatomic, strong) NSString * driver_name;//司机姓名
@property (nonatomic, strong) NSString * m_head;//头像
@property (nonatomic, strong) NSString * company_name;//所属公司
@property (nonatomic, strong) NSString * driver_balance;//余额
@property (nonatomic, strong) NSString * driver_sex;//性别
@property (nonatomic, strong) NSString * vehicle_number;//绑定车牌号
@property (nonatomic, strong) NSString * token;//登录token

//分享数据
@property (strong, nonatomic) NSString * title;//标题
@property (strong, nonatomic) NSString * desc;//描述
@property (strong, nonatomic) NSString * alink_url;//跳转链接
@property (strong, nonatomic) NSString * driver_class;//1.快车2.出租车3.扫码车
@end
