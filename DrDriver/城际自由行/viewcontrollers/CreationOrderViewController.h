//
//  CreationOrderViewController.h
//  DrDriver
//
//  Created by fy on 2019/1/21.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 自定义线路控制器
@interface CreationOrderViewController : UIViewController

@property(nonatomic,copy)NSString *line_id;

@property(nonatomic,strong)void (^getData)();

@end

NS_ASSUME_NONNULL_END
