//
//  AddBankCardSuccessViewController.h
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBankCardSuccessViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;

@property (assign, nonatomic) BOOL isOrder;//是否是支付订单成功
@property (strong, nonatomic) NSString * payMoney;//支付金额
@property (strong, nonatomic) NSString * orderId;//订单id

@property (strong, nonatomic) IBOutlet UILabel *theLable;

@end
