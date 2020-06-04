//
//  SureTiXianViewController.h
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SureTiXianViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *bankCardImageView;
@property (strong, nonatomic) IBOutlet UILabel *bankCardLable;
@property (strong, nonatomic) IBOutlet UILabel *bankCardNumberLable;
@property (strong, nonatomic) IBOutlet UITextField *moneyTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *codeTextFiled;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic) NSString * moneyStr;//钱包余额

@end
