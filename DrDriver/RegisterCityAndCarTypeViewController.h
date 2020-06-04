//
//  RegisterCityAndCarTypeViewController.h
//  DrDriver
//
//  Created by fy on 2019/3/12.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterCityAndCarTypeViewController : UIViewController

@property (nonatomic,strong) DriverModel * driver;
@property (nonatomic, strong)NSDictionary * ModelDic;
@property (nonatomic, copy)NSString *type;

@end

NS_ASSUME_NONNULL_END
