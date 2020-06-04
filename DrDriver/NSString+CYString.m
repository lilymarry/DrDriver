//
//  NSString+CYString.m
//  CowShare
//
//  Created by mac on 17/4/1.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "NSString+CYString.h"

@implementation NSString (CYString)

/**
 * 值如果是空设置为空字符串
 */
-(NSString *)CYString
{
    BOOL one=NO;
    BOOL two=NO;
    BOOL three=NO;

    if ([self rangeOfString:@"(null)"].location != NSNotFound) {
        one=YES;
    }
    if ([self rangeOfString:@"<null>"].location != NSNotFound) {
        two=YES;
    }
    if ([self rangeOfString:@"null"].location != NSNotFound) {
        three=YES;
    }
    
    if ([self isKindOfClass:[NSNull class]] || one || two || three) {
        
        if ([self isKindOfClass:[NSNull class]]) {
            return @"";
        } else {
            
            NSString * theString=[self stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            NSString * string=[theString stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            NSString * str=[string stringByReplacingOccurrencesOfString:@"null" withString:@""];
            
            return str;
        }
        
    }else{
        return self;
    }
}

@end
