//
//  ITUserSearchModel.h
//  DrUser
//
//  Created by fy on 2019/2/21.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITUserSearchModel : NSObject

@property(nonatomic, copy) NSString *start_province;
@property(nonatomic, copy) NSString *start_city;
@property(nonatomic, copy) NSString *start_county;
@property(nonatomic, copy) NSString *end_province;
@property(nonatomic, copy) NSString *end_city;
@property(nonatomic, copy) NSString *end_county;

@property(nonatomic, copy) NSString *start_name;
@property(nonatomic, copy) NSString *start_address;
@property(nonatomic, copy) NSString *start_lat;
@property(nonatomic, copy) NSString *start_lng;

@property(nonatomic, copy) NSString *end_name;
@property(nonatomic, copy) NSString *end_address;
@property(nonatomic, copy) NSString *end_lat;
@property(nonatomic, copy) NSString *end_lng;

@end

NS_ASSUME_NONNULL_END
