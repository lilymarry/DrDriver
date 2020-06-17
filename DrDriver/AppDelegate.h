//
//  AppDelegate.h
//  DrDriver
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeftSlideViewController * leftSlider;
@property (strong, nonatomic) UINavigationController * shouyeNav;
@property(nonatomic,strong) NSTimer * driverLocationTimer;//司机位置定时器
@property(nonatomic,assign)NSInteger networkCount;//上传经纬度网络请求失败次数
@property(nonatomic,strong) NSTimer *driverTimer;//后台运行提示定时器
@property(nonatomic,copy)NSString *listenState;

@end

