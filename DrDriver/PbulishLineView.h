//
//  PbulishLineView.h
//  DrDriver
//
//  Created by qqqqqqq on 2020/1/14.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PbulishLineView : UIView

/// 点击固定线路
@property (nonatomic, copy, readwrite) void(^lineOneBlock)();

/// f点击自定义线路
@property (nonatomic, copy, readwrite) void(^lineTwoBlick)();

/// 显示视图
- (void)showView;

/// 隐藏视图
- (void)hiddenView;
@end

NS_ASSUME_NONNULL_END
