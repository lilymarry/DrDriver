//
//  CYCrash.h
//  Spain
//
//  Created by mac on 2017/8/9.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYCrash : NSObject

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;

@end
