//
//  ChildMoreModel.h
//  DrDriver
//
//  Created by qqqqqqq on 2020/1/2.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChildMoreModel : NSObject
@property (nonatomic, copy, readwrite) NSString * child_name;//学生姓名
@property (nonatomic, copy, readwrite) NSString * child_sex;//学生性别，1男，2女
@property (nonatomic, copy, readwrite) NSString * child_pic;//学生照片
@property (nonatomic, copy, readwrite) NSString * group_photo;//合照
@property (nonatomic, copy, readwrite) NSString * aboard_pic;//上车照片
@property (nonatomic, copy, readwrite) NSString * debus_pic;//下车照片
@property (nonatomic, copy, readwrite) NSArray * order_times;//时间列表
@end

NS_ASSUME_NONNULL_END
