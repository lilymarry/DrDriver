//
//  CYPay.m
//  takeOut
//
//  Created by mac on 16/10/24.
//  Copyright © 2016年 tangchaoke. All rights reserved.
//

#import "CYPay.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "WXApi.h"

CYPay * payManager=nil;

@implementation CYPay

+(CYPay *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (payManager==nil) {
            payManager=[[CYPay alloc]init];
        }
    });
    return payManager;
}

//支付宝支付

-(void)AliPayWithDictionary:(NSDictionary *)dic isYue:(BOOL)yue
{
//    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];

    // NOTE: app_id设置
    order.app_id = ALIPAY_APPID;

    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";

    // NOTE: 参数编码格式
    order.charset = @"utf-8";

    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];

    // NOTE: 支付版本
    order.version = @"1.0";

    // NOTE: sign_type设置
    order.sign_type = @"RSA";

    order.notify_url=[dic objectForKey:@"notify_url"];

    // NOTE: 商品数据
    order.biz_content = [BizContent new];
//    order.biz_content.seller_id=SellerID;
    order.biz_content.body = [dic objectForKey:@"body"];
    order.biz_content.subject = [dic objectForKey:@"subject"];

    if (yue) {//充值的订单号
        order.biz_content.out_trade_no = [dic objectForKey:@"recharge_sn"]; //订单ID（由商家自行制定）
    } else {//支付订单的订单号
        order.biz_content.out_trade_no = [dic objectForKey:@"order_sn"]; //订单ID（由商家自行制定）
    }

    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [dic objectForKey:@"total_fee"]; //商品价格
//    order.biz_content.total_amount=[dic objectForKey:@"total_fee"];

    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    CYLog(@"orderSpec = %@",orderInfo);

    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(ALIPAY_PRIVIT_KEY);
    NSString *signedString = [signer signString:orderInfo];

    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"langfengying";

        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];

        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            CYLog(@"reslut = %@",resultDic);

            if ([[resultDic objectForKey:@"resultStatus"] intValue]==9000) {

                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ispaysuccess"] intValue]==1) {

                    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"payorder"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"paysuccess" object:nil];
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"ispaysuccess"];

                }else{

                 //   [CYToolInstance otherShowTostWithString:@"充值成功"];
                }

            }

        }];
    }
}

//微信支付
-(void)WXPayWithDictionary:(NSDictionary *)dic
{
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dic objectForKey:@"partnerid"];
    req.prepayId            = [dic objectForKey:@"prepayid"];
    req.nonceStr            = [dic objectForKey:@"noncestr"];
    req.timeStamp           = [[dic objectForKey:@"timestamp"] intValue];
    req.package             = [dic objectForKey:@"package"];
    req.sign                = [dic objectForKey:@"sign"];
    
    [WXApi sendReq:req];
    //日志输出
    CYLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dic objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,[dic objectForKey:@"sign"] );
}

//银联支付 生产环境：(mode:00)  测试环境：(mode:01)
-(void)YinLianPayWithDictionary:(NSString *)tn vc:(UIViewController *)vc
{
//    //当获得的tn不为空时，调用支付接口
//    if (tn != nil && tn.length > 0)
//    {
//        [[UPPaymentControl defaultControl]
//         startPay:tn
//         fromScheme:@"UPPayDemo"
//         mode:@"01"
//         viewController:vc];
//    }

}

@end
