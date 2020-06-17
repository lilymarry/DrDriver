//
//  AFRequestManager.m
//  takeRefresh
//
//  Created by mac on 16/11/7.
//  Copyright © 2016年 tangchaoke. All rights reserved.
//

#import "AFRequestManager.h"
#import "AFNetworking.h"
#import "JPUSHService.h"

@implementation AFRequestManager

//special为防止特殊接口处理，一般不用
+ (void)postRequestWithUrl:(NSString *)url params:(NSDictionary *)params tost:(BOOL)tost special:(int)special success:(HttpSuccess)success failure:(HttpFailure)failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    manager.requestSerializer.timeoutInterval = 30.0f;
    //添加版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSMutableDictionary *param = [params mutableCopy];
    [param setValue:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"v"];
    [param setValue:@"iOS" forKey:@"s"];
    
    if (tost) {//有弹窗请求
        
        //初始化进度框，置于当前的View当中
        UIWindow * window=[UIApplication sharedApplication].delegate.window;
        MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:window];
        
        [window addSubview:HUD];
        
        HUD.bezelView.backgroundColor=[UIColor blackColor];
        HUD.bezelView.alpha=1;
        HUD.label.textColor=[UIColor whiteColor];
        HUD.activityIndicatorColor=[UIColor whiteColor];
        
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        //设置对话框文字
        HUD.labelText = @"请稍等";
        [HUD showAnimated:YES];
        
        NSString * urlString=[NSString stringWithFormat:@"%@%@",HTTP_URL,url];
        CYLog(@"请求地址：%@\n 请求参数：%@\n",urlString,param);
        [manager POST:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            CYLog(@"返回数据：%@",responseObject);
            if (success)
                
            {
                
                if ([[responseObject objectForKey:@"flag"] isEqualToString:@"success"]) {
                    success(responseObject);
                } else {
//                    NSLog(@"0000000000000000000000");
                    //token出错
                    if ([[responseObject objectForKey:@"error_code"] intValue]==1111) {
                        
                        [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                            
                            CYLog(@"推送注册:%@",iAlias);
                            
                        }];
                        
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"invite_code"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"driver_class"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isError"] == nil) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginfailed" object:nil];
                            [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                                
                                CYLog(@"取消推送注册:%@",iAlias);
                                
                            }];
                            [[NSUserDefaults standardUserDefaults] setObject:@"n" forKey:@"isError"];
//                            NSLog(@"postNotificationName-loginfailed");
                        }
                        
                        [HUD removeFromSuperview];
                        [CYTSI otherShowTostWithString:@"登录失效，请重新登录！"];
                        return;
                        
                    }
                    
                    [CYTSI otherShowTostWithString:[responseObject objectForKey:@"message"]];
                    
                    //抢单失败也要返回
                    if (special==1) {
                        success(responseObject);
                    }
                    
                }
                
            }
            
            [HUD removeFromSuperview];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            CYLog(@"请求错误：%@",error);
            if (error)
                
            {
                
                failure(error);
                [CYTSI otherShowTostWithString:@"请求失败"];
                
            }
            [HUD removeFromSuperview];
        }];
        
    } else {//无弹窗请求
        
        NSString * urlString=[NSString stringWithFormat:@"%@%@",HTTP_URL,url];
        
        if (special==2) {
            urlString=DRIVER_NEARBY_START_LOCATION_PUSH;
        }
        
        CYLog(@"请求地址：%@\n 请求参数：%@\n",urlString,param);
        [manager POST:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            CYLog(@"返回数据：%@",responseObject);
            if (success)
                
            {
                if ([url isEqualToString:@"Driver/Driver/update_vehicle_location"]) {
                    success(responseObject);
                }else if([url isEqualToString:@"Driver/Driver/driver_online_state"]){
                     success(responseObject);
                }else{
                    if ([[responseObject objectForKey:@"flag"] isEqualToString:@"success"]) {
                        success(responseObject);
                    } else {
                        //token出错
                        if ([[responseObject objectForKey:@"error_code"] intValue]==1111) {
                            
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"invite_code"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"driver_class"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isError"] == nil) {
                                [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                                    
                                    CYLog(@"取消推送注册:%@",iAlias);
                                    
                                }];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginfailed" object:nil];
                                [[NSUserDefaults standardUserDefaults] setObject:@"n" forKey:@"isError"];
//                                NSLog(@"postNotificationName-loginfailed");
                            }
                            
                            [CYTSI otherShowTostWithString:@"登录失效，请重新登录！"];
                            return;
                            
                        }
                        
                        if (special!=1) {//不需要弹窗提醒
                            
                            [CYTSI otherShowTostWithString:[responseObject objectForKey:@"message"]];
                            
                        }
                        
                    }
                }
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            CYLog(@"请求错误：%@",error);
            if (error)
                
            {
                
                failure(error);
                
                if (special!=1 && special!=2) {//不需要弹窗提醒
                    
                    [CYTSI otherShowTostWithString:@"请求失败"];
                    
                }
                
            }
            
        }];
        
    }
    
}

@end
