//
//  PerfectOneViewController.h
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverModel.h"

@interface PerfectOneViewController : UIViewController

@property (nonatomic,strong) NSString * choosedCity;//已选择的城市
@property (nonatomic,strong) DriverModel * driver;

@end
