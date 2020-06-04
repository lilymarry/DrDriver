//
//  CardTiXianViewController.h
//  HouseManager
//
//  Created by mac on 17/1/19.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardTiXianViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *cardNumTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *yinHangTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *moneyTextFiled;

@property (assign, nonatomic) BOOL isSuccess;//是否认证信息成功

@end
