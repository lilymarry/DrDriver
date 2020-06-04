//
//  BankCardModel.h
//  DrDriver
//
//  Created by mac on 2017/6/25.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCardModel : NSObject

@property (strong, nonatomic) NSString * bank_id;//银行卡id
@property (strong, nonatomic) NSString * bank_logo;//银行logo
@property (strong, nonatomic) NSString * bank_name;//银行名称
@property (strong, nonatomic) NSString * account;//银行卡号
@property (strong, nonatomic) NSString * bank_address;//开户行地址
@property (strong, nonatomic) NSString * bank_class_id;//开户行分类id

@end
