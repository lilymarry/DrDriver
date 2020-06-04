//
//  ITFindUserOrderViewController.h
//  DrDriver
//
//  Created by fy on 2019/2/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITFindUserOrderViewController : UIViewController

@property(nonatomic,copy)NSString *travel_id;
@property (assign, nonatomic) BOOL isCanListen;//是否可以听单

@end

NS_ASSUME_NONNULL_END
