//
//  SelectPathViewController.h
//  DrDriver
//
//  Created by fy on 2019/2/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectPathViewController : UIViewController

@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *ITstartAddressBtn;
@property(nonatomic,strong)UILabel *ITstartLB;
@property(nonatomic,strong)UIImageView *ITstartImage;
@property(nonatomic,strong)UIView *ITendAddressBtn;
@property(nonatomic,strong)UILabel *ITendLB;
@property(nonatomic,strong)UIImageView *ITendImage;
@property(nonatomic,copy)NSString *start_province;
@property(nonatomic,copy)NSString *start_city;
@property(nonatomic,copy)NSString *start_county;

@property(nonatomic,strong)UIView *ITTimeBtn;
@property(nonatomic,strong)UILabel *ITTimeLB;
@property(nonatomic,strong)UIImageView *ITTimeImage;

@property(nonatomic,strong)UIView *ITNumberBtn;
@property(nonatomic,strong)UILabel *ITNumberLB;
@property(nonatomic,strong)UIImageView *ITNumberImage;

@property(nonatomic,strong)void (^getMainData)();

@end

NS_ASSUME_NONNULL_END
