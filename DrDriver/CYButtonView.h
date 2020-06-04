//
//  CYButtonView.h
//  DrDriver
//
//  Created by mac on 2017/6/19.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"

typedef NS_ENUM (NSInteger , buttonState) {
    
    START_LISTEN = 1,     //开始听单
    ALREADY_LISTEN = 2,   //听单中
    ROB_ORDER = 3,        //抢单
    ROB_ORDER_FAILED = 4,  //抢单失败
    SCAN_CLIKCK = 5,       //点击收款码
    UNFINISHORDER = 6  //行程中
};

@interface CYButtonView : UIView <UIAlertViewDelegate>

@property (assign, nonatomic) buttonState buttonState;//按钮状态
@property (strong, nonatomic) void (^ buttonBlock)(NSInteger);//按钮点击
@property (strong, nonatomic) void (^ overTime)();//抢单时间倒计时结束后的操作

@property (strong, nonatomic) UIView * colorView;//中间颜色视图
@property (strong, nonatomic) UILabel * midleLable;//中间显示的lable
@property (strong, nonatomic) UIButton * responseButton;//响应按钮
@property (strong, nonatomic) UIButton * listenButton;//听单图片
@property (strong, nonatomic) UILabel * robLable;//抢label
@property (strong, nonatomic) UILabel * secondeLable;//秒数label
@property (strong, nonatomic) UAProgressView * progressView;//进度条
@property (assign, nonatomic) CGFloat progress;//进度
@property (strong, nonatomic) NSTimer * timer;//定时器
@property (strong, nonatomic) NSTimer * secondTimer;//监控秒数的定时器
@property (assign, nonatomic) BOOL isCanListen;//是否可以听单
@property (assign, nonatomic) BOOL isHaveUnEndOrder;//是否有未完成的订单
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)titleStr;//初始化

/**
 *  抢单动画
 */
-(void)robOrderAnimation;

/**
 *  抢单失败后继续操作
 */
-(void)failedAfter;

/**
 *  停止听单
 */
-(void)stropCirclAnimation;

/**
 *  停止抢单
 */
-(void)stopRobOrderAnimation;

/**
 *  开始听单
 */
-(void)circlAnimation;

@end
