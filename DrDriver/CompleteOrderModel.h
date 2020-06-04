//
//  CompleteOrderModel.h
//  DrDriver
//
//  Created by mac on 2017/6/24.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrdeModel.h"

@interface CompleteOrderModel : NSObject

@property (nonatomic, strong) NSArray * list;//已完成订单数据
@property (nonatomic, strong) NSString * total_page;//已完成订单分页

@end
