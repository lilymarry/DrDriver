//
//  CustomizeViewController.h
//  DrDriver
//
//  Created by qqqqqqq on 2020/1/14.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomizeViewController : UIViewController

@property(nonatomic,copy)NSString *line_id;

@property(nonatomic,strong)void (^getData)();

@end

NS_ASSUME_NONNULL_END
