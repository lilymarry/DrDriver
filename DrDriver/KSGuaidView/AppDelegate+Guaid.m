//
//  AppDelegate+Guaid.m
//  KSGuaidViewDemo
//
//  Created by Mr.kong on 2017/5/31.
//  Copyright © 2017年 Bilibili. All rights reserved.
//

#import "AppDelegate+Guaid.h"
#import "KSGuaidViewController.h"

#import <objc/runtime.h>

const char* kGuaidWindowKey = "kGuaidWindowKey";
NSString * const kLastVersionKey = @"kLastVersionKey";

@implementation AppDelegate (Guaid)

+ (void)load{

    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString* lastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:kLastVersionKey];
        NSString* curtVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        
        if ([curtVersion compare:lastVersion] == NSOrderedDescending) {
            Method originMethod = class_getInstanceMethod(self.class, @selector(application:didFinishLaunchingWithOptions:));
            Method customMethod = class_getInstanceMethod(self.class, @selector(guaid_application:didFinishLaunchingWithOptions:));
            
            method_exchangeImplementations(originMethod, customMethod);

        }
    });
}

- (BOOL)guaid_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.guaidWindow = [[UIWindow alloc] init];
    self.guaidWindow.frame = self.guaidWindow.screen.bounds;
    self.guaidWindow.backgroundColor = [UIColor clearColor];
    self.guaidWindow.windowLevel = UIWindowLevelStatusBar + 1;
    [self.guaidWindow makeKeyAndVisible];
    
    KSGuaidViewController* vc = [[KSGuaidViewController alloc] init];

    __weak typeof(self) weakSelf = self;
    
    vc.shouldHidden = ^{
        
        NSString* curtVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] setObject:curtVersion forKey:kLastVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [weakSelf.guaidWindow resignKeyWindow];
        
        weakSelf.guaidWindow.hidden = YES;
        weakSelf.guaidWindow = nil;
    };
    
    self.guaidWindow.rootViewController = vc;
    
    [self requestAuthor];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"invite_code"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPhoneNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    return [self guaid_application:application didFinishLaunchingWithOptions:launchOptions];
}

//创建本地通知
- (void)requestAuthor
{
        // 设置通知的类型可以为弹窗提示,声音提示,应用图标数字提示
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        // 授权通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
}

- (UIWindow *)guaidWindow{
    return  objc_getAssociatedObject(self, kGuaidWindowKey);
}
- (void)setGuaidWindow:(UIWindow *)guaidWindow{
    objc_setAssociatedObject(self, kGuaidWindowKey, guaidWindow, OBJC_ASSOCIATION_RETAIN);
}

@end
