//
//  ITSelectAddressViewController.h
//  DrDriver
//
//  Created by fy on 2019/5/28.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITSelectAddressViewController : UIViewController
@property(nonatomic,copy)NSString *province;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *county;
@property(nonatomic,strong)void(^placeBlock)(NSString *name,NSString *address,NSString *lat,NSString *lng);
@end

NS_ASSUME_NONNULL_END
