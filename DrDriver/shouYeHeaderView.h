//
//  shouYeHeaderView.h
//  DrDriver
//
//  Created by qqqqqqq on 2018/9/21.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShouYeModel;
@interface shouYeHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *peakHoursBtn;//高峰在线
@property (weak, nonatomic) IBOutlet UIButton *todayHoursBtn;//今日在线
@property (weak, nonatomic) IBOutlet UIButton *todayMoneyBtn;//今日金额
- (IBAction)peakHoursAction:(UIButton *)sender;
- (IBAction)todayHoursAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *noticeLB;//平台公告

+ (instancetype)createView;

@property(nonatomic,strong)ShouYeModel *shouye;

@property(nonatomic,strong) void (^peakHoursBlock)(NSString *state);

@property(nonatomic,strong) void (^todayHoursBlock)(NSString *state);

@end
