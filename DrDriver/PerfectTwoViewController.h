//
//  PerfectTwoViewController.h
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverModel.h"
#import "CarModel.h"

@interface PerfectTwoViewController : UIViewController

@property (nonatomic,strong) DriverModel * driver;
@property (nonatomic,strong) CarModel * carColor;//车辆颜色

@property (nonatomic,strong) NSString * carBrandName;//车辆大品牌
@property (nonatomic,strong) NSString * vehicleStyle;//车辆详细品牌

@end
