//
//  LoginViewController.h
//  DrUser
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *accountTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextFiled;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;


@property (assign, nonatomic) BOOL isCheck;//是否需要补充信息
@end
