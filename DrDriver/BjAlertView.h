//
//  BjAlertView.h
//  DrDriver
//
//  Created by fy on 2018/9/5.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BjAlertView : UIView;

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *bjView;
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UILabel *titleLB;//立即报警标题
@property(nonatomic,strong)UILabel *addressLB;//位置信息label
@property(nonatomic,strong)UILabel *hintLB;//提示label
@property(nonatomic,strong)UIButton *bjBtn;
@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,strong) void (^cancel)();
@property(nonatomic,strong) void (^bjActionBlock)();

-(instancetype)initWithFrame:(CGRect)frame addressString:(NSString *)addressStr;


@end
