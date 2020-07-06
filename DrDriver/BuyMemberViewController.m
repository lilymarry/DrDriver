//
//  BuyMemberViewController.m
//  DrDriver
//
//  Created by fy on 2020/7/1.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import "BuyMemberViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "BuyListView.h"
#import "PromotionViewController.h"
@interface BuyMemberViewController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topHHH;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation BuyMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"充值会员";
    [self setUpNav];
 
    if (IPHONE_X) {
          _topHHH.constant=84;
    }
    else
    {
           _topHHH.constant=64;
    }
    
    _addBtn.layer.cornerRadius=25;
    _addBtn.layer.masksToBounds=YES;
  
}
//设置导航栏
-(void)setUpNav
{
    UIButton * navBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame=CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}
-(void)navBackButtonClicked
{
        [self.navigationController popViewControllerAnimated:YES];
   
}
- (IBAction)addPress:(id)sender {
    BuyListView *view=[[BuyListView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    [self.view.window addSubview:view];
}

- (IBAction)promotionPress:(id)sender {
    PromotionViewController *pro=[[PromotionViewController alloc]init];
    [self.navigationController pushViewController:pro animated:YES];
    
}

- (IBAction)payPress:(id)sender {
    [self AliPay];
}

-(void)AliPay
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

    order.notify_url=@"www.baidu.com";

    // NOTE: 商品数据
    order.biz_content = [BizContent new];
//    order.biz_content.seller_id=SellerID;
    order.biz_content.body =@"我是测试数据";
    order.biz_content.subject = @"1";

    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
      order.biz_content.timeout_express = @"30m"; //超时时间设置
      order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01];
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
        NSString *appScheme = @"DrDriver";

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
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
