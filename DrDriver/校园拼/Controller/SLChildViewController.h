//
//  SLChildViewController.h
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/16.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLStudent;
NS_ASSUME_NONNULL_BEGIN

@interface SLChildViewController : UIViewController
@property (copy, nonatomic,readwrite) NSString *timeStr;
@property (copy, nonatomic,readwrite) NSString *statuStr;
@property (copy, nonatomic,readwrite) NSString *typeStr;
@property (copy, nonatomic,readwrite) NSString *contract_id;
@property (copy, nonatomic,readwrite) NSString *statu;
@property(nonatomic, strong, readwrite) SLStudent *student;


@property(nonatomic,copy,readwrite) NSString *whichType;//0 校园拼 1通勤行
@end

NS_ASSUME_NONNULL_END
