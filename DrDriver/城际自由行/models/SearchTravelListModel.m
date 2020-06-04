//
//  SearchTravelListModel.m
//  DrDriver
//
//  Created by fy on 2019/2/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "SearchTravelListModel.h"

@implementation SearchTravelListModel

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSearch" object:self userInfo:nil];
    
}

@end
