//
//  ITUserSearchModel.m
//  DrUser
//
//  Created by fy on 2019/2/21.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITUserSearchModel.h"

@implementation ITUserSearchModel

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserSearch" object:self userInfo:nil];
}

@end
