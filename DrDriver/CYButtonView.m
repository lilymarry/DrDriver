//
//  CYButtonView.m
//  DrDriver
//
//  Created by mac on 2017/6/19.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "CYButtonView.h"
#import "JPUSHService.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>



@implementation CYButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)titleStr
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpMainView:frame title:titleStr];//设置主要视图
        
    }
    
    return self;
}

//设置主要视图
-(void)setUpMainView:(CGRect)frame title:(NSString *)titleStr
{
        
    self.backgroundColor=[UIColor whiteColor];
    self.layer.borderColor=TABLEVIEW_BACKCOLOR.CGColor;
    self.layer.borderWidth=1;
    
    //颜色视图
    self.colorView=[[UIView alloc]initWithFrame:CGRectMake(6, 6, frame.size.width-12, frame.size.height-12)];
    self.colorView.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
    self.colorView.layer.cornerRadius=(frame.size.width-12)/2;
    self.colorView.layer.masksToBounds=YES;
    [self addSubview:self.colorView];
    
    //听单动画按钮
    self.listenButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.listenButton setBackgroundImage:[UIImage imageNamed:@"listen_animation"] forState:UIControlStateNormal];
    self.listenButton.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.listenButton.hidden=YES;
    [self addSubview:self.listenButton];
    
    //听单lable
    self.midleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, (frame.size.height-20)/2, frame.size.width, 20)];
    self.midleLable.textColor=[UIColor whiteColor];
    self.midleLable.font=[UIFont systemFontOfSize:14];
    self.midleLable.textAlignment=NSTextAlignmentCenter;
    self.midleLable.text= titleStr;
    [self addSubview:self.midleLable];
    
    //抢label
    self.robLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 13, frame.size.width, 36)];
    self.robLable.textColor=[UIColor whiteColor];
    self.robLable.font=[UIFont boldSystemFontOfSize:25];
    self.robLable.textAlignment=NSTextAlignmentCenter;
    self.robLable.text=@"接";
    self.robLable.hidden=YES;
    [self addSubview:self.robLable];
    
    //秒数 label
    self.secondeLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 49, frame.size.width, 22)];
    self.secondeLable.textColor=[UIColor whiteColor];
    self.secondeLable.font=[UIFont systemFontOfSize:16];
    self.secondeLable.textAlignment=NSTextAlignmentCenter;
    self.secondeLable.text=@"8秒";
    self.secondeLable.hidden=YES;
    [self addSubview:self.secondeLable];
    
    self.progressView=[[UAProgressView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.progressView.tintColor = [CYTSI colorWithHexString:@"#386ac6"];
    self.progressView.lineWidth = 6.0;
    self.progressView.fillOnTouch = YES;
    self.progressView.hidden=YES;
    [self addSubview:self.progressView];
    
    //响应按钮
    self.responseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.responseButton.frame=CGRectMake(0, 0, frame.size.width, frame.size.width);
    [self.responseButton addTarget:self action:@selector(responseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.responseButton];
        
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }
}

//响应按钮点击事件
-(void)responseButtonClicked
{
    switch (self.buttonState) {
        case START_LISTEN://开始听单
        {
            if (self.isCanListen==NO) {
                
                [CYTSI otherShowTostWithString:@"您还没有通过审核，暂时不能听单"];
                return;
                
            }
            
//            NSLog(@"self.isHaveUnEndOrder%d",self.isHaveUnEndOrder);
            if (self.isHaveUnEndOrder) {
                
                [CYTSI otherShowTostWithString:@"您还有未完成的订单，请先完成"];
                return;
                
            }
            
            if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
                //位置服务是在设置中禁用
            {
//                NSLog(@"您没有开启了定位权限");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"打开定位开关"
                                                                message:@"定位服务未开启，请进入系统设置允许APP获取位置信息"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"立即开启", nil];
                [alert buttonTitleAtIndex:1];
                
                alert.delegate = self;
                [alert show];
                return;
            }
            
                UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
                
                if (UIUserNotificationTypeNone == setting.types)
                {
                    
//                    NSLog(@"推送关闭 8.0");
                    UIAlertView * myAlertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请打开：设置→通知→网路出行司机端→允许通知，否则您将无法听单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                    [myAlertView show];
                    
                    return;
                }
                
                else {
                    if ((UIUserNotificationTypeSound & setting.types) == 0) {
                        UIAlertView * myAlertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请打开：设置→通知→网路出行司机端→允许通知声音开启，否则您将无法听单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                        [myAlertView show];
                        
                        return;
                    }
//                    NSLog(@"推送打开 8.0");
                    
                    [JPUSHService setTags:nil alias:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        
                        CYLog(@"推送注册:%@",iAlias);
                        
                    }];
                    
                }
            
            
            self.buttonState=ALREADY_LISTEN;
            self.buttonBlock(self.buttonState);
        }
            break;
        case ALREADY_LISTEN://听单中
        {
            
        }
            break;
        case ROB_ORDER://抢单
        {
            self.buttonBlock(self.buttonState);
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"network"] isEqualToString:@"y"]) {
               [self stropCirclAnimation];
            }
       
        }
            break;
        case ROB_ORDER_FAILED://抢单失败
        {
            [CYTSI otherShowTostWithString:@"手慢了，订单已被抢~"];
        }
            break;
        case SCAN_CLIKCK://抢单失败
        {
            self.buttonState = SCAN_CLIKCK;
            self.buttonBlock(self.buttonState);
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"scan_click" object:nil];
        }
            break;
        default:
            break;
    }
    
}

//抢单失败后继续操作
-(void)failedAfter
{
    self.colorView.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
    
    [self stropCirclAnimation];
    self.buttonState=ALREADY_LISTEN;
    [self circlAnimation];//听单动画
}

//听单动画
-(void)circlAnimation
{
    self.listenButton.hidden=NO;
    self.midleLable.textColor=[CYTSI colorWithHexString:@"#333333"];
    self.midleLable.text=@"听单中";
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 3;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.listenButton.layer addAnimation:animation forKey:@"listenanimation"];
    
     [[NSUserDefaults standardUserDefaults] setObject:@"y" forKey:@"isWork"];
    
}

//停止听单
-(void)stropCirclAnimation
{
    [self.listenButton.layer removeAnimationForKey:@"listenanimation"];
    self.listenButton.hidden=YES;
    self.midleLable.textColor=[UIColor whiteColor];
    self.midleLable.text=@"开始上班";
    self.buttonState=START_LISTEN;
    self.colorView.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
    
    [self stopRobOrderAnimation];//停止抢单
    
    [[NSUserDefaults standardUserDefaults] setObject:@"n" forKey:@"isWork"];
}

//抢单动画
-(void)robOrderAnimation
{
    self.robLable.hidden=NO;
    self.secondeLable.hidden=NO;
    self.midleLable.hidden=YES;
    self.progressView.hidden=NO;
    self.buttonState=ROB_ORDER;
    
    [self.timer invalidate];
    
    self.progress=[self.secondeLable.text intValue]/100;
    
    //10秒0.1  5秒0.05
    self.timer=[NSTimer scheduledTimerWithTimeInterval:[self.secondeLable.text intValue] * 0.01 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
    
    self.secondTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSecond) userInfo:nil repeats:YES];
}

//停止抢单动画
-(void)stopRobOrderAnimation
{
    self.robLable.hidden=YES;
    self.secondeLable.hidden=YES;
    self.midleLable.hidden=NO;
    self.progressView.hidden=YES;
    self.buttonState=START_LISTEN;
    
    self.progress=0;
    [self.timer invalidate];
    [self.secondTimer invalidate];
}

//定时器圆环动画
- (void)updateProgress:(NSTimer *)timer
{
    self.progress = ((int)((self.progress * 100.0f) + 1.01) % 100) / 100.0f;
    [self.progressView setProgress:self.progress];
    
    if (self.progress>=0.98) {
        
        [self.progressView setProgress:1.0];
        [self.timer invalidate];
        
    }
}

//更新秒数
-(void)updateSecond
{
    if ([self.secondeLable.text intValue]-1>=0) {
        self.secondeLable.text=[NSString stringWithFormat:@"%d秒",[self.secondeLable.text intValue]-1];
    }else{
        [self.secondTimer invalidate];
        [self robOrderFaild];
        
        self.overTime();//抢单倒计时结束后的操作
    }
}

//抢单失败
-(void)robOrderFaild
{
    self.colorView.backgroundColor=[CYTSI colorWithHexString:@"#747474"];
    self.buttonState=ROB_ORDER_FAILED;
    
    [self.timer invalidate];
}

@end
