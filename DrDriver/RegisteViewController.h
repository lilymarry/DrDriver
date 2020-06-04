//
//  RegisteViewController.h
//  ETravel
//
//  Created by mac on 2017/5/15.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisteViewController : UIViewController

@property (nonatomic,assign) BOOL isLogin;//是否是从登录过来的
@property (nonatomic,assign) BOOL isForget;//是否是忘记密码
@property (strong, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *codeTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *miMaTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *secretTextFiled;
@property (strong, nonatomic) IBOutlet UIButton *sureButton;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
@property (strong, nonatomic) IBOutlet UILabel *secretLable;
@property (strong, nonatomic) IBOutlet UIButton *xieYiButton;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgViewTop;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (assign, nonatomic) BOOL isChange;//是否是修改密码

@end
