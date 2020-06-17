//
//  SLTripListViewController.h
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/24.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 行程列表控制器
@interface SLTripListViewController : UIViewController

@property(nonatomic,copy,readwrite) NSString *whichType;//0 校园拼 1通勤行

@end

NS_ASSUME_NONNULL_END
