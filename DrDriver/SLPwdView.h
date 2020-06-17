//
//  SLPwdView.h
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/30.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPwdView : UIView

@property (strong,nonatomic) void (^cancleBlock)();

@property (strong,nonatomic) void (^sureBlock)(NSString *pwd);
-(void)showAlertView;//显示弹出视图
-(void)hideAlertView;//隐藏弹出视图
@end

NS_ASSUME_NONNULL_END
