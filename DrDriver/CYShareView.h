//
//  CYShareView.h
//  DrDriver
//
//  Created by mac on 2017/7/21.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYShareView : UIView

@property (strong,nonatomic) UIView * shareView;//分享视图
@property (strong,nonatomic) void (^shareClicked)(NSInteger);//分享按钮点击事件

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray;

-(void)showShareView;//显示弹出视图
-(void)hideShareView;//隐藏弹出视图

@end
