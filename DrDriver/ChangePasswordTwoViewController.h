//
//  ChangePasswordTwoViewController.h
//  DrUser
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordTwoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *passwordTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *aginPasswordTextFiled;
@property (strong, nonatomic) IBOutlet UIButton *sureButton;

@property (strong, nonatomic) NSString * codeStr;//验证码

@end
