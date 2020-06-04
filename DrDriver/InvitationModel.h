//
//  InvitationModel.h
//  DrDriver
//
//  Created by mac on 2017/6/26.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvitationModel : NSObject

@property (strong, nonatomic) NSString * invite_class;//邀请类型
@property (strong, nonatomic) NSString * account;//手机号
@property (strong, nonatomic) NSString * nickname;//昵称
@property (strong, nonatomic) NSString * ctime;//时间

@end
