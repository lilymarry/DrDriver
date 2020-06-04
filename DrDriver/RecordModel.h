//
//  RecordModel.h
//  DrDriver
//
//  Created by mac on 2017/6/26.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject

@property (strong, nonatomic) NSString * operate_intro;//操作名称
@property (strong, nonatomic) NSString * money;//金额
@property (strong, nonatomic) NSString * ctime;//日期
@property (strong, nonatomic) NSString * withdraw_state;//提现状态 (null:不显示,不为空时红色字体)

@end
