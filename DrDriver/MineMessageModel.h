//
//  MineMessageModel.h
//  DrUser
//
//  Created by mac on 2017/7/5.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineMessageModel : NSObject

@property (strong, nonatomic) NSString * message_id;//消息ID
@property (strong, nonatomic) NSString * content;//消息内容
@property (assign, nonatomic) NSInteger read_state;//0:未阅读 1:已读
@property (strong, nonatomic) NSString *ctime;//日期


@end
