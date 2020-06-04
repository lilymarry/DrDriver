//
//  ITListModel.h
//  DrDriver
//
//  Created by 王彦森 on 2019/2/3.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITListModel : NSObject


@property (strong, nonatomic) NSString * end_address;
@property (strong, nonatomic) NSString * start_address;
@property (strong, nonatomic) NSString * state;
@property (strong, nonatomic) NSString * travel_date;
@property (strong, nonatomic) NSString * travel_time;

@property (strong, nonatomic) NSString * travel_id;


@end

NS_ASSUME_NONNULL_END
