//
//  TravelCancelReasonViewController.h
//  DrDriver
//
//  Created by 王彦森 on 2019/1/31.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TravelCancelReasonViewController : UIViewController

@property (strong, nonatomic) NSString * orderID;//订单id

@property(nonatomic,strong)void (^cancelBlock)();

@end

NS_ASSUME_NONNULL_END
