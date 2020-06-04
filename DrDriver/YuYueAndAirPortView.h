//
//  YuYueAndAirPortView.h
//  DrUser
//
//  Created by qqqqqqq on 2018/9/19.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YuYueAndAirPortViewDelegat<NSObject>

- (void)didClickCanCelbtn:(NSString *)order_id;

@end
@class OrderDetailModel;
@interface YuYueAndAirPortView : UIView

@property(nonatomic,strong) OrderDetailModel *orderModel;
+ (instancetype)createView;
@property(nonatomic,weak) id <YuYueAndAirPortViewDelegat> delegate;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@end
