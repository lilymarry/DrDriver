//
//  ITUserDetailViewController.h
//  DrDriver
//
//  Created by fy on 2019/2/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITUserDetailViewController : UIViewController
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,copy)NSString *travel_id;
@property(nonatomic,strong)void (^getMainData)();
//@property(nonatomic,strong)void (^getDetailData)();
@property (assign, nonatomic) BOOL isCanListen;//是否可以听单

@end

NS_ASSUME_NONNULL_END
