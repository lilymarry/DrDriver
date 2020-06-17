//
//  WeekModel.h
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeekModel : NSObject
@property (nonatomic, copy, readwrite) NSString * end_time;
@property (nonatomic, copy, readwrite) NSString * start_time;
@property (nonatomic, copy, readwrite) NSString * week;
@end

NS_ASSUME_NONNULL_END
