//
//  UISearchBar+LeftAligenment.m
//  ETravel
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "UISearchBar+LeftAligenment.h"

@implementation UISearchBar (LeftAligenment)

-(void)setLeftPlaceholder:(NSString *)placeholder {
    self.placeholder = placeholder;
    
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector]) {
        BOOL centeredPlaceholder = NO;
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&centeredPlaceholder atIndex:2];
        [invocation invoke];
    }
}

@end
