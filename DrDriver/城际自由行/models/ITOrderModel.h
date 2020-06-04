//
//  ITOrderModel.h
//  DrDriver
//
//  Created by fy on 2019/1/24.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITOrderModel : NSObject

@property (nonatomic, copy) NSString * travel_id;
@property (nonatomic, copy) NSString * start_province;
@property (nonatomic, copy) NSString * start_city;
@property (nonatomic, copy) NSString * start_county;
@property (nonatomic, copy) NSString * start_address;
@property (nonatomic, copy) NSString * end_province;
@property (nonatomic, copy) NSString * end_city;
@property (nonatomic, copy) NSString * end_county;
@property (nonatomic, copy) NSString * end_address;
@property (nonatomic, copy) NSString * fix_num;
@property (nonatomic, copy) NSString * remain_seat;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * travel_date;
@property (nonatomic, copy) NSString * travel_time;

@end

NS_ASSUME_NONNULL_END
