//
//  IBTimePickerView.h
//  O2
//
//  Created by 李士杰 on 15/5/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//  出生日期,时间选择器

#import <UIKit/UIKit.h>

@protocol TimePickerViewDelegate <NSObject>

- (void)getTime:(NSDate *)time;
- (void)cancleTime;
@end
@interface TimePickerView : UIView

@property(nonatomic,assign)id<TimePickerViewDelegate>delegate;
@end
