//
//  TrueRegisterViewController.h
//  DrUser
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrueRegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;

@property (strong, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *codeTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *invaliteTextFiled;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

@property (strong, nonatomic) NSString * inviteCode;//邀请码
@property (strong, nonatomic) IBOutlet UIButton *chooseButton;//选择协议按钮
//@property (strong, nonatomic) IBOutlet UIButton *rentCarButton;
//@property (strong, nonatomic) IBOutlet UIButton *quickCarButton;
//@property (strong, nonatomic) IBOutlet UIView *buttonBgView;

@end
