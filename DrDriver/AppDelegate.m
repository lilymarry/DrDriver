//
//  AppDelegate.m
//  DrDriver
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LeftViewController.h"
//#import "LoginViewController.h"
#import "QuickLoginViewController.h"
#import "IQKeyboardManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"
#import "WXApiObject.h"

#import "APOpenAPI.h"

#import "CYCrash.h"
#import "AFNetworking.h"

#import <AVFoundation/AVFoundation.h>

#import "KSGuaidViewController.h"
#import "ScanCarViewController.h"

#import "MineMessageViewController.h"
#import "SpeechSynthesizer.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "CYOrderView.h"
#import "CharteredViewController.h"
#import "IndependentTravelView.h"

#import "AudioRecoderManager.h"

@interface AppDelegate () <JPUSHRegisterDelegate,TencentSessionDelegate,WXApiDelegate,APOpenAPIDelegate,CLLocationManagerDelegate,AMapLocationManagerDelegate>

@property (strong, nonatomic) TencentOAuth * tencentOAuth;

@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic ,strong)CYOrderView * orderView;//地址视图

@property (nonatomic ,strong, readwrite) AudioRecoderManager *audioManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    
    [self sendCrashText];//发送崩溃日志
    
    [self ContinuedLocationManager];
    
    //后台播报关键
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    //注册第三方应用
    [self registerThird:launchOptions];
    
    [UINavigationBar appearance].barTintColor=[CYTSI colorWithHexString:@"##383635"];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    
    //改变电池条颜色（plist设置）
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //未登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]==nil) {
        
        QuickLoginViewController * vc=[[QuickLoginViewController alloc]init];
        self.shouyeNav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        LeftViewController * leftVC=[[LeftViewController alloc]init];
        
        self.leftSlider=[[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.shouyeNav];
        [self.leftSlider setPanEnabled:NO];
        self.window.rootViewController=self.leftSlider;
        
    } else {//已登录
        NSString *d_class = [[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"];
        if ([d_class isEqualToString:@"3"]) {//扫码车进入
            ScanCarViewController * vc=[[ScanCarViewController alloc]init];
            [self jumpInWhichVC:vc];
            
        }else if ([d_class isEqualToString:@"6"]){//包车进入
            CharteredViewController * vc=[[CharteredViewController alloc]init];
            [self jumpInWhichVC:vc];
        }
        //        else if ([d_class isEqualToString:@"8"]){//城际自由行进入
        //            IndependentTravelView * vc=[[IndependentTravelView alloc]init];
        //            [self jumpInWhichVC:vc];
        //        }
        else{
            ViewController * vc=[[ViewController alloc]init];
            [self jumpInWhichVC:vc];
        }
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginRecord:) name:@"beginRecord" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRecord) name:@"stopRecord" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginUpdate) name:@"beginUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopUpdate) name:@"stopUpdate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrderState:) name:@"orderState" object:nil];
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(warningTone:) name:@"warningTone" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facefail) name:@"facefail" object:nil];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;//清空角标个数
    
    
    
#pragma mark  城际自由行程序未启动点击透传消息
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]!=nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (launchOptions) {
            NSDictionary *pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            if ([pushNotificationKey[@"operate_class"] isEqualToString:@"driver_travel_msg"]) {
                [userDefaults setObject:pushNotificationKey[@"travel_id"] forKey:@"messagePushData"];
                [userDefaults synchronize];
                [userDefaults setObject:@"yes" forKey:@"messagePushState"];
                [userDefaults synchronize];
            }else{
                [userDefaults setObject:@"no" forKey:@"messagePushState"];
                [userDefaults synchronize];
            }
        }else{
            [userDefaults setObject:@"no" forKey:@"messagePushState"];
            [userDefaults synchronize];
        }
    }
    
    return YES;
}



-(void)warningTone:(NSNotification *)noti{
    NSDictionary *dic =noti.userInfo;
    self.listenState = dic[@"state"];
}
- (void)jumpInWhichVC:(UIViewController *)vc{
    
    self.shouyeNav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    LeftViewController * leftVC=[[LeftViewController alloc]init];
    
    self.leftSlider=[[LeftSlideViewController alloc]initWithLeftView:leftVC andMainView:self.shouyeNav];
    self.window.rootViewController=self.leftSlider;
}
-(void)changeOrderState:(NSNotification *)noti{
    NSDictionary *dic =noti.userInfo;
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"orderState"] forKey:@"orderState"];
//    NSLog(@"changeOrderState ========orderStateState%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"orderState"]);
}
-(void)beginUpdate{
    NSLog(@"beginUpdate");
    if (![_driverLocationTimer isValid]) {
//        [_driverLocationTimer invalidate];
//        _driverLocationTimer = nil;
        _driverLocationTimer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateDriverLocation) userInfo:nil repeats:YES];
           [[NSRunLoop currentRunLoop] addTimer:_driverLocationTimer forMode:NSRunLoopCommonModes];
    }
   
}
-(void)stopUpdate{
    NSLog(@"stopUpdate");
    self.listenState = @"下班";
    if ([_driverLocationTimer isValid]) {
        [_driverLocationTimer invalidate];
        _driverLocationTimer = nil;
    }
}
//播放推送标题
-(void)playVideo:(NSString *)title
{
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:title];
}
//持续更新司机位置的定时器
-(void)updateDriverLocation
{
    self.listenState = @"行程中";
    NSLog(@"appdelegate=============");
    double   latitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"] doubleValue];
    double  longtitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"] doubleValue];
    NSString *urlStr;
   
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"] == nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
        return;
    }
    urlStr = DRIVER_UPDATE_VEHICLE_LOCATION;
    
    NSMutableDictionary *para=[NSMutableDictionary dictionary];
    [para setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"driver_id"];
    [para setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"] forKey:@"driver_lng"];
    [para setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"] forKey:@"driver_lat"];
    [para setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationSpeed"] forKey:@"speed"];
    [para setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationCourse"] forKey:@"angle"];
    [para setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationStime"] forKey:@"stime"];
    [para setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"order_id"] forKey:@"order_id"];
    [para setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"orderState"] forKey:@"state"];
    [para setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
    [para setValue:@"1" forKey:@"is_fatigue"];
    /*
        dic =  @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],
                 @"driver_lng":[[NSUserDefaults standardUserDefaults]objectForKey:@"driverLocationLo"],
                 @"driver_lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"],
                 @"speed":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationSpeed"],
                 @"angle":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationCourse"],
                 @"stime":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationStime"],
                 @"order_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"order_id"],
                 @"state":[[NSUserDefaults standardUserDefaults] objectForKey:@"orderState"],
                 @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
                 ,@"is_fatigue":@"1"};
     */
    //上传服务器司机的位置
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:para];
    [AFRequestManager postRequestWithUrl:urlStr params:dic tost:NO special:1 success:^(id responseObject) {
        self.networkCount = 0;
        if ([responseObject[@"error_code"] isEqualToString:@"3333"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"overTime" object:self userInfo:nil];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"message"] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:alertB];
            
            [[self currentViewController] presentViewController:alertC animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        self.networkCount++;
        if (self.networkCount >= 6) {
            [self playVideo:@"您的网络异常，请检查网络设置"];//播放网络异常语音提示
        }
    }];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]==nil) {
        
        return;
        
    }
    
    //计算两点间的距离
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"new_latitude"]==nil) {
        
        return;
    }
    
    //根据订单状态判断是否需要开始计费
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"orderState"] isEqualToString:@"3"]) {
        double newLatitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"new_latitude"] doubleValue];
        double newLongitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"new_longitude"] doubleValue];
        
        //计算两点间的直线距离
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(newLatitude,newLongitude));
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longtitude));
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2)/1000+[[[NSUserDefaults standardUserDefaults] objectForKey:@"new_distance"] doubleValue];
        NSString * distanceStr=[NSString stringWithFormat:@"%f",distance];
        
        CYLog(@"计算的距离：%@",distanceStr);
        
        //保存最新点及距离
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",latitude] forKey:@"new_latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",longtitude] forKey:@"new_longitude"];
        [[NSUserDefaults standardUserDefaults] setObject:distanceStr forKey:@"new_distance"];
    }
}
- (UIViewController *)currentViewController {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    } else {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabbar = (UITabBarController *)nextResponder;
        UINavigationController *nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result = nav.childViewControllers.lastObject;
        
    } else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController *nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    } else {
        result = nextResponder;
    }
    return result;
}
#pragma mark ---  保证程序不被系统杀死
-(void)ContinuedLocationManager
{
    //1.创建定位管理对象
    _manager = [[CLLocationManager alloc]init];
    
    //2.设置属性 distanceFilter、desiredAccuracy
    [_manager setDistanceFilter:kCLDistanceFilterNone];//实时更新定位位置
    [_manager setDesiredAccuracy:kCLLocationAccuracyBest];//定位精确度
    if([_manager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        [_manager requestAlwaysAuthorization];
    }
    //该模式是抵抗程序在后台被杀，申明不能够被暂停
    _manager.pausesLocationUpdatesAutomatically = NO;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        //在后台也可定位
        [_manager requestAlwaysAuthorization];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        _manager.allowsBackgroundLocationUpdates = YES;
    }
    //3.设置代理
    _manager.delegate = self;
    //4.开始定位
    [_manager startUpdatingLocation];
    //5.获取朝向
    [_manager startUpdatingHeading];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(driverLocation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
}

-(void)driverLocation{
    //开始定位
    [self.locationManager startUpdatingLocation];
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    //定位结果
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",location.coordinate.latitude] forKey:@"driverLocationLa"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",location.coordinate.longitude] forKey:@"driverLocationLo"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.6f",location.speed] forKey:@"driverLocationSpeed"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.6f",location.course] forKey:@"driverLocationCourse"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.6f",[location.timestamp timeIntervalSince1970]] forKey:@"driverLocationStime"];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //    CLLocation *curr = [locations lastObject];
    //    NSLog(@"curr.coordinate.latitude%f curr.coordinate.longitude%f",curr.coordinate.latitude,curr.coordinate.longitude);
}

//注册第三方应用
-(void)registerThird:(NSDictionary *)launchOptions
{
    //注册高德地图
    [AMapServices sharedServices].apiKey=@"c6bc4269c364702cbc3632656f126d14";
    
    //注册推送
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"1955bccbe76191dd26e84ff0"
                          channel:nil
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;//清空角标个数
    
    //注册QQ
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1106174781" andDelegate:self];
    
    //注册微信
    [WXApi registerApp:@"wx495f5e2d7cf60612" withDescription:@"demo 2.0"];
    
    //极光透传消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //注册支付宝分享
    [APOpenAPI registerApp:@"2017070607665594"];
    
    //人脸识别注册
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
    [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
//    NSLog(@"canWork = %d",[[FaceSDKManager sharedInstance] canWork]);
    
}
- (void)networkDidReceiveMessage:(NSNotification *)notification
{
//    NSLog(@"networkDidReceiveMessagenetworkDidReceiveMessage%@",notification);
    NSDictionary * userInfo = [notification userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchuan" object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newOrder" object:self userInfo:userInfo];
    
    if ([CYTSI runningInBackground]) {
        [self presentLocalNotification:userInfo[@"extras"][@"operate_class"]];
    }
}

-(void)presentLocalNotification:(NSString *)operate_class{
    if ([operate_class isEqualToString:@"new_order"] || [operate_class isEqualToString:@"new_order_appoint"] || [operate_class isEqualToString:@"new_order_flight"]) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = @"您有新的订单";
        localNotification.soundName = @"Order.caf";
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSLog(@"deviceToken%@",deviceToken);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^__strong)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    NSLog(@"userInfouserInfo%@",userInfo);
    if([userInfo[@"operate_class"] isEqualToString:@"message_center"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"xiangqing" forKey:@"jpushMessage"];
        NSString *d_class = [[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"];
        if ([d_class isEqualToString:@"3"]) {//扫码车进入
//            NSLog(@"SCANVC_xiangqing");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SCANVC_xiangqing" object:self userInfo:userInfo];
        }else{//出租车进入
//            NSLog(@"VC_xiangqing");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VC_xiangqing" object:self userInfo:userInfo];
        }
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]!=nil) {
        //城际自由行
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chengjiMessage" object:self userInfo:userInfo];
    }
    
    // Required
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if([userInfo[@"operate_class"] isEqualToString:@"message_center"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"xiangqing" forKey:@"jpushMessage"];
        NSString *d_class = [[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"];
        if ([d_class isEqualToString:@"3"]) {//扫码车进入
//            NSLog(@"SCANVC_xiangqing");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SCANVC_xiangqing" object:self userInfo:userInfo];
        }else{//出租车进入
//            NSLog(@"VC_xiangqing");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VC_xiangqing" object:self userInfo:userInfo];
        }
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]!=nil) {
        //城际自由行
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chengjiMessage" object:self userInfo:userInfo];
    }
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[NSUserDefaults standardUserDefaults] setObject:@"xiangqing" forKey:@"jpushMessage"];
    //城际自由行
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]!=nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chengjiMessage" object:self userInfo:userInfo];
    }
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}



#pragma mark - QQ delegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
    
    //    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
    
    //    return [TencentOAuth HandleOpenURL:url];
}

//发送崩溃日志
-(void)sendCrashText
{
    [CYCrash setDefaultHandler];
    // 发送崩溃日志
    NSString * crashName=[[NSUserDefaults standardUserDefaults] objectForKey:@"crash_name"];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataPath = [path stringByAppendingPathComponent:crashName];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    if (data != nil) {
        [self sendExceptionLogWithData:data path:dataPath];
    }
}

#pragma mark -- 发送崩溃日志
- (void)sendExceptionLogWithData:(NSData *)data path:(NSString *)path
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5.0f;
    //告诉AFN，支持接受 text/xml 的数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    NSString *urlString = @"http://app.wllives.com/index.php/Api/Version/crash_log";
    
    NSString * crashName=[[NSUserDefaults standardUserDefaults] objectForKey:@"crash_name"];
    
    [manager POST:urlString parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:@"crash_log" fileName:crashName mimeType:@"txt"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        NSLog(@"***发送崩溃成功");
        // 删除文件
        NSFileManager *fileManger = [NSFileManager defaultManager];
        [fileManger removeItemAtPath:path error:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        NSLog(@"发送失败：%@",error);
        
    }];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {

    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self.manager startUpdatingLocation];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {

    if ([self.listenState isEqualToString:@"yes"] || [self.listenState isEqualToString:@"行程中"]) {
        [self begin];
    }
    //后台运行
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    [self.manager startUpdatingLocation];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    NSLog(@"进入前台");
    [self stop];
    //进入前台
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change_front" object:self];
}
-(void)begin{
//    NSLog(@"127378963827623%@",self.listenState);
    if ([self.listenState isEqualToString:@"yes"] || [self.listenState isEqualToString:@"行程中"]){
        [self playVideo:@"网路出行持续喂您派单中"];//播放推送标题
    }
    if ([_driverTimer isValid]) {
        [_driverTimer invalidate];
        _driverTimer = nil;
    }
    _driverTimer =  [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(driverTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_driverTimer forMode:NSRunLoopCommonModes];
}
-(void)stop{
    if ([_driverTimer isValid]) {
        [_driverTimer invalidate];
        _driverTimer = nil;
    }
}
-(void)driverTimerAction{
    if (self.networkCount == 0){
        AudioServicesPlaySystemSound(1113);
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}


#pragma mark - 录音相关

-(void)beginRecord:(NSNotification*)noti{
    self.audioManager.order_id = noti.userInfo[@"route_id"];
    self.audioManager.order_type = noti.userInfo[@"order_type"];
    NSLog(@"beginRecord ============");
    [self.audioManager startUploadRecoard];
}

- (void)stopRecord{
    if (self.audioManager){
        NSLog(@"stopRecord ============");
       [self.audioManager stopRecord];
    }
      
}

- (AudioRecoderManager *)audioManager{
    if (!_audioManager) {
        _audioManager = [[AudioRecoderManager alloc] init];
    }
    
    return _audioManager;
}

@end

