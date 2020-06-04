//
//  SearchTravelListModel.h
//  DrDriver
//
//  Created by fy on 2019/2/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchTravelListModel : NSObject

@property(nonatomic, copy) NSString *start_province;
@property(nonatomic, copy) NSString *start_city;
@property(nonatomic, copy) NSString *start_county;
@property(nonatomic, copy) NSString *end_province;
@property(nonatomic, copy) NSString *end_city;
@property(nonatomic, copy) NSString *end_county;
@property(nonatomic, copy) NSString *start_date;
@property(nonatomic, copy) NSString *start_time;
@property(nonatomic, copy) NSString *end_time;
@property(nonatomic, copy) NSString *passenger_num;

@end

NS_ASSUME_NONNULL_END
