//
//  NotiMessageModel.h
//  DrDriver
//
//  Created by mac on 2017/6/27.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotiModel.h"

@interface NotiMessageModel : NSObject

@property (copy, nonatomic) NSString * title;//推送标题
@property (copy, nonatomic) NSString * content;//推送内容
@property (strong, nonatomic) NotiModel * extras;//消息主题





@end
