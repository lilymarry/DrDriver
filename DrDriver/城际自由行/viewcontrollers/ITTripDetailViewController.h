//
//  ITTripDetailViewController.h
//  DrDriver
//
//  Created by fy on 2019/1/22.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITTripDetailViewController : UIViewController

@property(nonatomic,copy)NSString *travelID;
@property(nonatomic,copy)NSString *dateStr;
@property(nonatomic,copy)NSString *timeStr;
@property(nonatomic,copy)NSString *state;
@property (assign, nonatomic) BOOL isCanListen;//是否可以听单

@property(nonatomic,strong)void (^getDateBlock)();
-(void)getData;

@end

NS_ASSUME_NONNULL_END
