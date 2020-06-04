//
//  ChooseCarTypeViewController.h
//  DrDriver
//
//  Created by mac on 2017/8/16.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCarTypeViewController : UIViewController

@property (assign, nonatomic) NSInteger type;//选择类型1：选择品牌  2：选择颜色
@property (assign, nonatomic) NSInteger OtherType;//用来区分是从注册过来的还是补充信息过来的
@end
