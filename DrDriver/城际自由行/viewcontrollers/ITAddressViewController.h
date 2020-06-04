//
//  ITAddressViewController.h
//  DrDriver
//
//  Created by fy on 2019/1/24.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITAddressViewController : UIViewController

@property(nonatomic,strong)void (^addressBlock)(NSDictionary *addressDic);

@end

NS_ASSUME_NONNULL_END
