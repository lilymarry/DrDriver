//
//  DriveMapViewController.h
//  DrDriver
//
//  Created by mac on 2017/6/24.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface DriveMapViewController : UIViewController
@property (nonatomic, strong) AMapNaviDriveView *driveView;

@property (nonatomic, strong) void (^ closeDrive)();//关闭导航

@property (nonatomic, strong) void (^ moreClicked)();//更多按钮点击事件

@property (nonatomic, strong) void (^ pauseClicked)();//暂停按钮点击

@property (nonatomic, strong) void (^ resumeClicked)();//继续按钮点击

@property (nonatomic,strong) NSString * orderID;//订单id

@property (nonatomic,assign) NSInteger orderState;//订单状态

@end
