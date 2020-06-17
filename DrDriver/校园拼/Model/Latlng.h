//
//  Latlng.h
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/26.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Latlng : NSObject
@property (nonatomic, copy, readwrite) NSString * child_name;//学生姓名
@property (nonatomic, copy, readwrite) NSString * start_lat;//
@property (nonatomic, copy, readwrite) NSString * start_lng;//
@property (nonatomic, copy, readwrite) NSString * end_lat;//
@property (nonatomic, copy, readwrite) NSString * end_lng;//
@property (nonatomic, copy, readwrite) NSString *cm_name;

@end

NS_ASSUME_NONNULL_END
