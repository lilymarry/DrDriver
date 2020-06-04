//
//  AFRequestManager.h
//  takeRefresh
//
//  Created by mac on 16/11/7.
//  Copyright © 2016年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HttpSuccess)(id responseObject);

typedef void (^HttpFailure)(NSError *error);

@interface AFRequestManager : NSObject

+ (void)postRequestWithUrl:(NSString *)url params:(NSDictionary *)params tost:(BOOL)tost special:(int)special success:(HttpSuccess)success failure:(HttpFailure)failure;

@end
