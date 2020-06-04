//
//  CYPay.h
//  takeOut
//
//  Created by mac on 16/10/24.
//  Copyright © 2016年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CYPay : NSObject

+(CYPay *)sharedInstance;

//支付宝支付
-(void)AliPayWithDictionary:(NSDictionary *)dic  isYue:(BOOL)yue;

//微信支付
-(void)WXPayWithDictionary:(NSDictionary *)dic;

//银联支付
-(void)YinLianPayWithDictionary:(NSString *)tn vc:(UIViewController *)vc;

@end
