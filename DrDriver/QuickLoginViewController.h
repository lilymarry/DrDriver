//
//  QuickLoginViewController.h
//  DrUser
//
//  Created by mac on 2017/7/10.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *codeTextFiled;
@property (strong, nonatomic) IBOutlet UIButton *chooseButton;
@property (strong, nonatomic) IBOutlet UIButton *xieYiButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (assign, nonatomic) BOOL isMainJump;//是否是登录过期或退出登录过来的
@property (assign, nonatomic) BOOL isCheck;//是否需要补充信息
@end
