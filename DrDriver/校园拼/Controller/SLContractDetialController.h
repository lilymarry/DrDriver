//
//  SLContractDetialController.h
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/16.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLContractDetialController : UIViewController
@property (nonatomic, strong ,readwrite) NSString *contract_id;
@property(nonatomic,copy,readwrite) NSString *whichType;//0 校园拼 1通勤行
@end

NS_ASSUME_NONNULL_END
